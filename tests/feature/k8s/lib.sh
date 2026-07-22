#!/bin/bash
# ============================================================
# K8s suite-level shared library
# ============================================================
# Uses flag-file + reference counting to ensure the k8s cluster
# connectivity check runs only ONCE across all test cases.
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from subdirectories
#   . "$(dirname "$0")/lib.sh"       # from k8s/ directory
#
# Then call: k8sSetup in rlPhaseStartSetup
# Cleanup is auto-registered via rlCleanupAppend.

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
