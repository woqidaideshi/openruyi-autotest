#!/bin/bash
# ============================================================
# K8s suite-level shared library
# ============================================================
# Uses flag-file + reference counting to ensure the k8s cluster
# connectivity check runs only ONCE across all test cases.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from subdirectories (smoke/, api/, pod/, ...)
#   . "$(dirname "$0")/lib.sh"       # from k8s/ directory
#
# Then call: k8sSetup in rlPhaseStartSetup
# Cleanup is auto-registered via rlCleanupAppend.
#
# New helper functions (v2):
#   k8sApplyYAML       - apply YAML from string or heredoc
#   k8sWaitForPodReady - wait until pods with label are Ready
#   k8sGetPodName      - get first pod name by label
#   k8sExecInPod       - execute command inside a pod
#   k8sDeleteResource  - safe delete (ignore not found)
#   k8sImageExists     - check if image is in containerd
#   k8sGetNodeCount    - get total Ready node count
#   k8sKataRuntimeAvailable - check if kata-clh RuntimeClass exists

K8S_FLAG="/tmp/.beakerlib_k8s_feature_suite"

k8sSetup() {
    if [ ! -f "$K8S_FLAG" ]; then
        # First test to arrive: verify cluster connectivity
        rlLogInfo "K8s suite: first test, verifying cluster connectivity..."

        # Source topology
        if [ -f "$TMT_TEST_TOPOLOGY_FILE" ]; then
            . "$TMT_TEST_TOPOLOGY_FILE"
        fi

        # Write topology fallback
        if [ -z "${TEST_SERVER_1_HOST:-}" ]; then
            echo "installed=1" > "$K8S_FLAG"
            echo "ref=1" >> "$K8S_FLAG"
            rlLogInfo "K8s: no topology file, running on local cluster"
            return 0
        fi

        # Verify SSH to master node
        local ssh_cmd="sshpass -p '${TEST_SERVER_1_PASSWORD:-}' ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p ${TEST_SERVER_1_PORT:-22} ${TEST_SERVER_1_USER:-root}@${TEST_SERVER_1_HOST}"
        
        if $ssh_cmd "which kubectl" 2>/dev/null; then
            echo "installed=0" > "$K8S_FLAG"
            rlLogInfo "K8s master node reachable, kubectl found"
        else
            echo "installed=1" > "$K8S_FLAG"
            rlLogInfo "K8s master node reachable but kubectl not found"
        fi
        echo "ref=1" >> "$K8S_FLAG"
    else
        # Subsequent tests: increment ref count
        local ref
        ref=$(grep "^ref=" "$K8S_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$K8S_FLAG"
        rlLogInfo "K8s suite already initialized by other test, reference count: $ref"
    fi

    rlCleanupAppend "k8sCleanup"
}

k8sCleanup() {
    if [ ! -f "$K8S_FLAG" ]; then
        return 0
    fi

    local ref
    ref=$(grep "^ref=" "$K8S_FLAG" | cut -d= -f2)
    ref=$((ref - 1))

    if [ "$ref" -le 0 ]; then
        rlLogInfo "K8s suite: last test, cleaning up..."
        rm -f "$K8S_FLAG"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$K8S_FLAG"
        rlLogInfo "K8s suite: retain (still have $ref test(s) not completed)"
    fi
}

# ============================================================
# K8s config (discovered at setup time)
# ============================================================
K8S_KUBECONFIG="${K8S_KUBECONFIG:-/etc/kubernetes/admin.conf}"
K8S_USE_SUDO="${K8S_USE_SUDO:-true}"

# ============================================================
# Helper: source topology variables
# ============================================================
_k8sSourceTopology() {
    if [ -f "$TMT_TEST_TOPOLOGY_FILE" ]; then
        . "$TMT_TEST_TOPOLOGY_FILE"
    fi
}

# ============================================================
# Helper: execute command on K8s master node via SSH
# ============================================================
_k8sMasterSSH() {
    local cmd="$1"
    _k8sSourceTopology
    local host="${TEST_SERVER_1_HOST:-127.0.0.1}"
    local port="${TEST_SERVER_1_PORT:-22}"
    local user="${TEST_SERVER_1_USER:-root}"
    local pass="${TEST_SERVER_1_PASSWORD:-}"

    if command -v sshpass &>/dev/null; then
        sshpass -p "$pass" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -p "$port" "$user@$host" "$cmd" 2>/dev/null
    else
        # Fallback: use expect-style password injection via ssh -o PasswordAuthentication
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 -o PreferredAuthentications=password \
            -o PubkeyAuthentication=no -p "$port" "$user@$host" "echo '$pass' | sudo -S true 2>/dev/null; $cmd" 2>/dev/null
    fi
}

# ============================================================
# Helper: execute kubectl command on K8s master node
# Uses sudo because kubeconfig is owned by root on RISC-V K8s nodes
# ============================================================
k8sKubectl() {
    local args="$*"
    if [ -f "$TMT_TEST_TOPOLOGY_FILE" ]; then
        _k8sSourceTopology
        local pass="${TEST_SERVER_1_PASSWORD:-}"
        if [ "$K8S_USE_SUDO" = "true" ]; then
            _k8sMasterSSH "echo '$pass' | sudo -S kubectl --kubeconfig=$K8S_KUBECONFIG $args"
        else
            _k8sMasterSSH "kubectl --kubeconfig=$K8S_KUBECONFIG $args"
        fi
    else
        # Local execution: use sudo because kubeconfig is root-owned on RISC-V
        if [ "$K8S_USE_SUDO" = "true" ]; then
            sudo kubectl --kubeconfig="$K8S_KUBECONFIG" $args
        else
            kubectl --kubeconfig="$K8S_KUBECONFIG" $args
        fi
    fi
}

# ============================================================
# Helper: check K8s cluster health
# ============================================================
k8sClusterHealthCheck() {
    rlLogInfo "Checking K8s cluster health..."

    # Check nodes
    local nodes_output
    nodes_output=$(k8sKubectl get nodes --no-headers 2>&1)
    rlAssertNotGrep "NotReady\|SchedulingDisabled" "$nodes_output" "All nodes are Ready"

    # Count ready nodes
    local ready_count
    ready_count=$(echo "$nodes_output" | grep -c "Ready" || true)
    rlLogInfo "Ready nodes: $ready_count"
    rlAssertGreaterOrEqual "At least 2 nodes ready" "$ready_count" 2

    # Check pods in kube-system
    local pods_output
    pods_output=$(k8sKubectl get pods -n kube-system --no-headers 2>&1)
    local running_count
    running_count=$(echo "$pods_output" | grep -c "Running" || true)
    rlLogInfo "Running pods in kube-system: $running_count"
}

# ============================================================
# Helper: apply YAML from heredoc or file via kubectl
# Usage: k8sApplyYAML <<< "$yaml_content"
#        k8sApplyYAML < file.yaml
# ============================================================
k8sApplyYAML() {
    local yaml_content
    yaml_content=$(cat)
    k8sKubectl apply -f - <<< "$yaml_content" 2>&1
}

# ============================================================
# Helper: wait for pods matching label to become Ready
# Usage: k8sWaitForPodReady <namespace> <label-selector> <timeout-seconds>
# Returns: 0 on success, 1 on timeout
# ============================================================
k8sWaitForPodReady() {
    local ns="$1"
    local label="$2"
    local timeout="${3:-120}"

    rlLogInfo "Waiting for pods with label '$label' in ns '$ns' (timeout=${timeout}s)..."
    k8sKubectl wait --for=condition=Ready pod \
        -l "$label" \
        -n "$ns" \
        --timeout="${timeout}s" 2>&1
}

# ============================================================
# Helper: get the first pod name matching a label
# Usage: pod=$(k8sGetPodName <namespace> <label-selector>)
# ============================================================
k8sGetPodName() {
    local ns="$1"
    local label="$2"

    k8sKubectl get pods -n "$ns" -l "$label" \
        -o jsonpath='{.items[0].metadata.name}' 2>&1
}

# ============================================================
# Helper: execute command inside a pod
# Usage: k8sExecInPod <namespace> <pod-name> -- <command...>
#        k8sExecInPod <namespace> <pod-name> "command string"
# ============================================================
k8sExecInPod() {
    local ns="$1"
    local pod="$2"
    shift 2

    k8sKubectl exec -n "$ns" "$pod" -- "$@" 2>&1
}

# ============================================================
# Helper: safe delete (ignore if resource doesn't exist)
# Usage: k8sDeleteResource <type> <name> [-n <namespace>]
# ============================================================
k8sDeleteResource() {
    local type="$1"
    local name="$2"
    shift 2

    k8sKubectl delete "$type" "$name" "$@" --ignore-not-found=true --timeout=60s 2>&1 || true
}

# ============================================================
# Helper: check if an image exists in containerd
# Usage: k8sImageExists "busybox:1.36.1" → returns 0 if exists
# ============================================================
k8sImageExists() {
    local image="$1"
    local result

    result=$(_k8sMasterSSH "sudo ctr -n k8s.io images ls -q 2>/dev/null | grep -F '$image'" 2>/dev/null)
    if [ -n "$result" ]; then
        rlLogInfo "Image '$image' found in containerd"
        return 0
    else
        rlLogWarning "Image '$image' NOT found in containerd"
        return 1
    fi
}

# ============================================================
# Helper: get the number of Ready nodes in the cluster
# Usage: count=$(k8sGetNodeCount)
# ============================================================
k8sGetNodeCount() {
    local count
    count=$(k8sKubectl get nodes --no-headers 2>/dev/null | grep -c "Ready" || echo "0")
    echo "$count" | tr -d ' '
}

# ============================================================
# Helper: check if kubectl exec/logs works
# Some RISC-V K8s clusters have apiserver configured without
# --kubelet-client-certificate, causing exec/logs to fail with
# "Unauthorized". Returns 0 if available.
# ============================================================
k8sExecAvailable() {
    # Cache result
    if [ -n "${K8S_EXEC_AVAILABLE:-}" ]; then
        return $K8S_EXEC_AVAILABLE
    fi

    # Try a quick exec on a test pod
    local ns="default"
    local test_pod="k8s-exec-check-$$"
    k8sKubectl run "$test_pod" -n "$ns" \
        --image=docker.io/library/busybox:1.36.1 \
        --restart=Never -- sleep 10 2>/dev/null

    # Wait up to 15s for pod to be running
    for i in $(seq 1 15); do
        local status
        status=$(k8sKubectl get pod "$test_pod" -n "$ns" -o jsonpath='{.status.phase}' 2>/dev/null)
        if [ "$status" = "Running" ]; then
            break
        fi
        sleep 1
    done

    if k8sKubectl exec "$test_pod" -n "$ns" -- echo ok 2>/dev/null | grep -q ok; then
        rlLogInfo "kubectl exec: AVAILABLE"
        K8S_EXEC_AVAILABLE=0
    else
        rlLogWarning "kubectl exec/logs NOT available — apiserver kubelet client cert missing"
        K8S_EXEC_AVAILABLE=1
    fi

    k8sKubectl delete pod "$test_pod" -n "$ns" --force --grace-period=0 2>/dev/null || true
    return $K8S_EXEC_AVAILABLE
}

# ============================================================
# Helper: check if CoreDNS is deployed in the cluster
# Returns 0 if available (DNS pod found).
# ============================================================
k8sDNSAvailable() {
    if [ -n "${K8S_DNS_AVAILABLE:-}" ]; then
        return $K8S_DNS_AVAILABLE
    fi

    local dns_pods
    dns_pods=$(k8sKubectl get pods -A -l k8s-app=kube-dns --no-headers 2>/dev/null)
    if [ -n "$dns_pods" ]; then
        rlLogInfo "CoreDNS: AVAILABLE"
        K8S_DNS_AVAILABLE=0
        return 0
    fi

    # Also check coredns label variant
    dns_pods=$(k8sKubectl get pods -A -l k8s-app=coredns --no-headers 2>/dev/null)
    if [ -n "$dns_pods" ]; then
        rlLogInfo "CoreDNS: AVAILABLE"
        K8S_DNS_AVAILABLE=0
        return 0
    fi

    rlLogWarning "CoreDNS NOT deployed in this cluster"
    K8S_DNS_AVAILABLE=1
    return 1
}

# ============================================================
# Helper: check if kata-clh RuntimeClass exists
# Usage: k8sKataRuntimeAvailable → returns 0 if available
# ============================================================
k8sKataRuntimeAvailable() {
    local result
    result=$(k8sKubectl get runtimeclass kata-clh -o name 2>/dev/null)
    if [ -n "$result" ]; then
        rlLogInfo "RuntimeClass 'kata-clh' found"
        return 0
    else
        rlLogWarning "RuntimeClass 'kata-clh' NOT found — Kata containers not available"
        return 1
    fi
}
