#!/bin/bash
# ============================================================
# Feature test: K8s - Sonobuoy-equivalent smoke verification
# ============================================================
# Purpose: Replicate openruyi-riscv-sonobuoy-smoke.yaml checks:
#          1) Architecture is riscv64
#          2) DNS resolves kubernetes.default.svc.cluster.local
#          3) API Server reachable via Service DNS + SA Token
#          Runs as DaemonSet pods (one per node), exactly like
#          the original Sonobuoy plugin.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/lib.sh"

SMOKE_NS="k8s-feature-test-sonobuoy-smoke"
SMOKE_DS="openruyi-riscv-smoke"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        rlLogInfo "Starting Sonobuoy-equivalent smoke test..."

        # Create test namespace
        k8sKubectl create namespace "$SMOKE_NS" 2>/dev/null || true
        rlLogInfo "Test namespace $SMOKE_NS ready"
    rlPhaseEnd

    # ----------------------------------------------------------
    # Check 1: Architecture verification (master-side, instant)
    # ----------------------------------------------------------
    rlPhaseStartTest "Verify cluster node architecture is riscv64"
        arch_output=$(k8sKubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.architecture}' 2>&1)
        rlRun "echo '$arch_output'" 0 "List node architectures"

        non_riscv=$(echo "$arch_output" | tr ' ' '\n' | grep -v "riscv64" | wc -l)
        if [ "$non_riscv" -eq 0 ]; then
            rlPass "All nodes report architecture = riscv64"
        else
            rlFail "Found $non_riscv node(s) with non-riscv64 architecture: $arch_output"
        fi
    rlPhaseEnd

    # ----------------------------------------------------------
    # Deploy DaemonSet: one busybox per node (like Sonobuoy plugin)
    # ----------------------------------------------------------
    rlPhaseStartTest "Deploy smoke-check DaemonSet"
        k8sKubectl apply -n "$SMOKE_NS" -f - <<'YAML'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: openruyi-riscv-smoke
spec:
  selector:
    matchLabels:
      app: openruyi-riscv-smoke
  template:
    metadata:
      labels:
        app: openruyi-riscv-smoke
    spec:
      tolerations:
      - operator: Exists
      containers:
      - name: plugin
        image: docker.io/library/busybox:1.36.1
        command: ["/bin/sh", "-c"]
        args:
        - |
          set -eu
          echo "test=openruyi-riscv-sonobuoy-smoke"
          echo "date=$(date -u +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || true)"
          echo "pod_hostname=$(cat /etc/hostname)"
          echo "arch=$(uname -m)"
          echo "===DNS_START==="
          nslookup kubernetes.default.svc.cluster.local 2>&1 || true
          echo "===DNS_END==="
          echo "===API_START==="
          wget -qO- --timeout=10 --no-check-certificate \
            --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
            https://kubernetes.default.svc.cluster.local/version 2>&1 || true
          echo "===API_END==="
          echo "status=pass"
          # Keep pod alive for log inspection
          while true; do sleep 3600; done
      restartPolicy: Always
YAML
        rlRun "echo 'DaemonSet applied'" 0 "Created $SMOKE_DS DaemonSet"

        # Wait for all DaemonSet pods to be Running
        k8sKubectl wait --for=condition=Ready pod \
            -l "app=$SMOKE_DS" \
            -n "$SMOKE_NS" \
            --timeout=120s 2>&1 || true

        # Show DaemonSet status
        ds_status=$(k8sKubectl get ds "$SMOKE_DS" -n "$SMOKE_NS" --no-headers 2>&1)
        rlLogInfo "DaemonSet status: $ds_status"

        desired=$(echo "$ds_status" | awk '{print $2}')
        ready=$(echo "$ds_status" | awk '{print $4}')
        if [ "$desired" = "$ready" ] && [ "$desired" -ge 1 ]; then
            rlPass "DaemonSet $SMOKE_DS: $ready/$desired pods Ready"
        else
            rlFail "DaemonSet $SMOKE_DS: only $ready/$desired Ready"
        fi
    rlPhaseEnd

    # ----------------------------------------------------------
    # Check 2: Arch from inside pod (each node)
    # ----------------------------------------------------------
    rlPhaseStartTest "Verify arch=riscv64 inside each DaemonSet pod"
        pod_names=$(k8sKubectl get pods -n "$SMOKE_NS" \
            -l "app=$SMOKE_DS" \
            -o jsonpath='{.items[*].metadata.name}' 2>&1)

        all_pass=true
        for pod in $pod_names; do
            arch=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1 | grep "^arch=" | cut -d= -f2)
            if [ "$arch" = "riscv64" ]; then
                rlLogInfo "Pod $pod: arch=riscv64 OK"
            else
                rlLogError "Pod $pod: arch=$arch (expected riscv64)"
                all_pass=false
            fi
        done

        if $all_pass; then
            rlPass "All smoke pods report arch=riscv64"
        else
            rlFail "Some pods reported non-riscv64 architecture"
        fi
    rlPhaseEnd

    # ----------------------------------------------------------
    # Check 3: DNS resolution of kubernetes.default
    # ----------------------------------------------------------
    rlPhaseStartTest "Verify DNS resolves kubernetes.default.svc.cluster.local"
        all_pass=true
        for pod in $pod_names; do
            pod_logs=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1)
            dns_section=$(echo "$pod_logs" | sed -n '/===DNS_START===/,/===DNS_END===/p')
            rlLogInfo "Pod $pod DNS output: $dns_section"

            # nslookup should return an IP
            if echo "$dns_section" | grep -q "Address:"; then
                resolved_ip=$(echo "$dns_section" | grep "Address:" | tail -1 | awk '{print $NF}' | tr -d '\r')
                rlLogInfo "Pod $pod: resolved kubernetes.default to $resolved_ip"
            else
                rlLogWarning "Pod $pod: nslookup did not find 'Address:' line"
                all_pass=false
            fi
        done

        if $all_pass; then
            rlPass "DNS resolution succeeded on all pods"
        else
            rlFail "DNS resolution failed on some pods"
        fi
    rlPhaseEnd

    # ----------------------------------------------------------
    # Check 4: API Server reachable via Service DNS
    # ----------------------------------------------------------
    rlPhaseStartTest "Verify API Server reachable via Service DNS"
        all_pass=true
        for pod in $pod_names; do
            pod_logs=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1)
            api_section=$(echo "$pod_logs" | sed -n '/===API_START===/,/===API_END===/p')

            # Should get JSON with version info
            if echo "$api_section" | grep -q '"major"'; then
                version_info=$(echo "$api_section" | grep '"gitVersion"' | head -1)
                rlLogInfo "Pod $pod: API Server version info retrieved"
            else
                rlLogError "Pod $pod: failed to get API Server version"
                rlLogInfo "Raw API output: $api_section"
                all_pass=false
            fi
        done

        if $all_pass; then
            rlPass "API Server reachable from all DaemonSet pods"
        else
            rlFail "API Server unreachable from some pods"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$SMOKE_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
        rlLogInfo "Test namespace $SMOKE_NS cleaned up"
    rlPhaseEnd

rlJournalEnd
