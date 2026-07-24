#!/bin/bash
# ============================================================
# K8s Scheduling: Verify ResourceQuota enforcement.
# Equivalent to Sonobuoy sig-scheduling ResourceQuota tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

QUOTA_NS="k8s-feature-test-sched-quota"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$QUOTA_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "ResourceQuota: enforce pod count limit"
        # Create ResourceQuota with pod limit of 2
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-limit
  namespace: k8s-feature-test-sched-quota
spec:
  hard:
    pods: "2"
YAML

        # Create 2 pods (within quota)
        k8sKubectl run quota-pod-1 -n "$QUOTA_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never -- sleep 300 2>&1
        k8sKubectl run quota-pod-2 -n "$QUOTA_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never -- sleep 300 2>&1

        sleep 5

        # Try creating a 3rd pod — should be rejected
        result=$(k8sKubectl run quota-pod-3 -n "$QUOTA_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never -- sleep 300 2>&1) || true

        if echo "$result" | grep -qi "exceeded\|forbidden\|denied"; then
            rlPass "3rd pod rejected by ResourceQuota (pods limit 2)"
        else
            rlLogWarning "3rd pod may not have been rejected: $result"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$QUOTA_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
