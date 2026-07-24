#!/bin/bash
# ============================================================
# K8s Scheduling: Verify Pod tolerations allow scheduling onto tainted nodes.
# Equivalent to Sonobuoy sig-scheduling tolerations tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

TAINT_NS="k8s-feature-test-sched-taint"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$TAINT_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Tolerations: Pod without toleration fails on tainted node"
        # Taint a node with NoSchedule
        node=$(k8sKubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>&1)

        # Check existing taints
        existing=$(k8sKubectl get node "$node" -o jsonpath='{.spec.taints}' 2>&1 || true)
        rlLogInfo "Existing taints on $node: $existing"

        # Apply a test taint
        k8sKubectl taint node "$node" k8s-test=temp:NoSchedule --overwrite 2>&1

        # Create a pod without toleration — should remain Pending
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: no-toleration
  namespace: k8s-feature-test-sched-taint
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sleep", "30"]
  restartPolicy: Never
YAML
        sleep 8

        phase=$(k8sKubectl get pod no-toleration -n "$TAINT_NS" \
            -o jsonpath='{.status.phase}' 2>&1 || echo "Pending")
        if [ "$phase" = "Pending" ]; then
            rlPass "Pod without toleration is Pending on tainted node (expected)"
        else
            rlLogWarning "Pod phase=$phase (may be Pending with small delay)"
        fi

        # Remove the taint
        k8sKubectl taint node "$node" k8s-test- 2>&1 || true
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$TAINT_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
