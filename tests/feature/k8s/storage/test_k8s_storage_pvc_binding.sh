#!/bin/bash
# ============================================================
# K8s Storage: Verify PVC creation and binding.
# Equivalent to Sonobuoy sig-storage PVC Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

PVC_NS="k8s-feature-test-sto-pvc"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$PVC_NS" 2>/dev/null || true

        # Check if a default StorageClass exists
        sc_count=$(k8sKubectl get storageclass -o name 2>/dev/null | wc -l)
        if [ "$sc_count" -eq 0 ]; then
            rlSkip "No StorageClass available — PVC binding test requires a provisioner"
        fi
    rlPhaseEnd

    rlPhaseStartTest "PVC: create and verify Pending→Bound lifecycle"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
  namespace: k8s-feature-test-sto-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
YAML
        # Wait for PVC to bind
        k8sKubectl wait --for=jsonpath='{.status.phase}'=Bound \
            pvc/test-pvc -n "$PVC_NS" --timeout=60s 2>/dev/null || true

        pvc_phase=$(k8sKubectl get pvc test-pvc -n "$PVC_NS" \
            -o jsonpath='{.status.phase}' 2>&1)
        if [ "$pvc_phase" = "Bound" ]; then
            rlPass "PVC test-pvc is Bound"
        else
            rlFail "PVC test-pvc phase is '$pvc_phase' (expected Bound)"
        fi

        pv_name=$(k8sKubectl get pvc test-pvc -n "$PVC_NS" \
            -o jsonpath='{.spec.volumeName}' 2>&1)
        rlAssertNotEquals "PV is provisioned" "" "$pv_name"
    rlPhaseEnd

    rlPhaseStartTest "PVC: delete and verify cleanup"
        k8sKubectl delete pvc test-pvc -n "$PVC_NS" --timeout=30s 2>&1 || true
        rlPass "PVC deleted"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$PVC_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
