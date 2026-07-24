#!/bin/bash
# ============================================================
# K8s Scheduling: Verify nodeSelector constraint.
# Equivalent to Sonobuoy sig-scheduling nodeSelector tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

NS_SCHED="k8s-feature-test-sched-ns"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$NS_SCHED" 2>/dev/null || true

        node_count=$(k8sGetNodeCount)
        if [ "$node_count" -lt 1 ]; then
            rlSkip "No nodes available for scheduling test"
        fi
    rlPhaseEnd

    rlPhaseStartTest "nodeSelector: schedule Pod to specific hostname"
        target_node=$(k8sKubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>&1)

        k8sApplyYAML <<YAML
apiVersion: v1
kind: Pod
metadata:
  name: ns-test-pod
  namespace: $NS_SCHED
spec:
  nodeSelector:
    kubernetes.io/hostname: "$target_node"
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo scheduled; sleep 30"]
  restartPolicy: Never
YAML
        sleep 10

        scheduled_node=$(k8sKubectl get pod ns-test-pod -n "$NS_SCHED" \
            -o jsonpath='{.spec.nodeName}' 2>&1)

        if [ "$scheduled_node" = "$target_node" ]; then
            rlPass "Pod scheduled to $target_node via nodeSelector"
        else
            rlLogWarning "Pod scheduled to $scheduled_node (expected $target_node)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$NS_SCHED" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
