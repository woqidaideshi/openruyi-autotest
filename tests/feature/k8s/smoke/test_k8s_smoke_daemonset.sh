#!/bin/bash
# ============================================================
# K8s Smoke: DaemonSet-based integrated smoke verification.
# Equivalent to Sonobuoy RISC-V smoke plugin
# (openruyi-riscv-sonobuoy-smoke.yaml).
# Runs a DaemonSet pod on each node that verifies:
#   1) Architecture = riscv64
#   2) DNS resolves kubernetes.default.svc.cluster.local
#   3) API Server /version reachable via SA token
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

SMOKE_NS="k8s-feature-test-smoke-ds"
SMOKE_DS="openruyi-riscv-smoke"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$SMOKE_NS" 2>/dev/null || true

        # Check required image
        if ! k8sImageExists "busybox:1.36.1"; then
            rlSkip "busybox:1.36.1 image not available in containerd"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Deploy smoke-check DaemonSet"
        k8sApplyYAML <<'YAML'
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: openruyi-riscv-smoke
  namespace: k8s-feature-test-smoke-ds
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
          echo "arch=$(uname -m)"
          echo "---DNS---"
          nslookup kubernetes.default.svc.cluster.local 2>&1 || true
          echo "---API---"
          wget -qO- --timeout=10 --no-check-certificate \
            --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
            https://kubernetes.default.svc.cluster.local/version 2>&1 || true
          echo "---DONE---"
          while true; do sleep 3600; done
      restartPolicy: Always
YAML
        rlRun "echo 'DaemonSet created'" 0 "DaemonSet $SMOKE_DS deployed"

        k8sWaitForPodReady "$SMOKE_NS" "app=$SMOKE_DS" 120

        ds_status=$(k8sKubectl get ds "$SMOKE_DS" -n "$SMOKE_NS" --no-headers 2>&1)
        rlLogInfo "DaemonSet status: $ds_status"

        desired=$(echo "$ds_status" | awk '{print $2}')
        ready=$(echo "$ds_status" | awk '{print $4}')
        if [ "$desired" = "$ready" ] && [ "$desired" -ge 1 ]; then
            rlPass "DaemonSet: $ready/$desired pods Ready"
        else
            rlFail "DaemonSet: only $ready/$desired Ready"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify arch=riscv64 inside each DaemonSet pod"
        pod_names=$(k8sKubectl get pods -n "$SMOKE_NS" \
            -l "app=$SMOKE_DS" \
            -o jsonpath='{.items[*].metadata.name}' 2>&1)

        all_ok=true
        for pod in $pod_names; do
            logs=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1)
            arch=$(echo "$logs" | grep "^arch=" | cut -d= -f2)
            if [ "$arch" = "riscv64" ]; then
                rlLogInfo "Pod $pod: arch=riscv64 OK"
            else
                rlFail "Pod $pod: arch=$arch (expected riscv64)"
                all_ok=false
            fi
        done
        $all_ok && rlPass "All smoke pods report arch=riscv64"
    rlPhaseEnd

    rlPhaseStartTest "Verify DNS resolution from DaemonSet pods"
        all_ok=true
        for pod in $pod_names; do
            logs=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1)
            dns_section=$(echo "$logs" | sed -n '/---DNS---/,/---API---/p')
            if echo "$dns_section" | grep -q "Address:"; then
                rlLogInfo "Pod $pod: DNS resolved successfully"
            else
                rlFail "Pod $pod: DNS resolution failed"
                all_ok=false
            fi
        done
        $all_ok && rlPass "DNS resolution succeeded on all pods"
    rlPhaseEnd

    rlPhaseStartTest "Verify API Server reachable from DaemonSet pods"
        all_ok=true
        for pod in $pod_names; do
            logs=$(k8sKubectl logs -n "$SMOKE_NS" "$pod" 2>&1)
            api_section=$(echo "$logs" | sed -n '/---API---/,/---DONE---/p')
            if echo "$api_section" | grep -q '"major"'; then
                rlLogInfo "Pod $pod: API Server reachable"
            else
                rlFail "Pod $pod: API Server unreachable"
                all_ok=false
            fi
        done
        $all_ok && rlPass "API Server reachable from all DaemonSet pods"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$SMOKE_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
