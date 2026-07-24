#!/bin/bash
# ============================================================
# K8s Workload: Verify ReplicaSet maintains replica count.
# Equivalent to Sonobuoy sig-apps ReplicaSet Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

RS_NS="k8s-feature-test-wl-rs"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$RS_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "ReplicaSet: create and verify replica count maintenance"
        k8sApplyYAML <<'YAML'
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: test-rs
  namespace: k8s-feature-test-wl-rs
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test-rs
  template:
    metadata:
      labels:
        app: test-rs
    spec:
      containers:
      - name: main
        image: docker.io/library/busybox:1.36.1
        command: ["sleep", "3600"]
YAML
        k8sWaitForPodReady "$RS_NS" "app=test-rs" 120

        ready=$(k8sKubectl get rs test-rs -n "$RS_NS" \
            -o jsonpath='{.status.readyReplicas}' 2>&1)
        rlAssertEquals "ReplicaSet has 2 ready replicas" "2" "$ready"

        # Delete one pod and verify ReplicaSet recreates it
        pod_to_delete=$(k8sKubectl get pods -n "$RS_NS" -l "app=test-rs" \
            -o jsonpath='{.items[0].metadata.name}' 2>&1)
        k8sKubectl delete pod "$pod_to_delete" -n "$RS_NS" --grace-period=0 2>&1

        sleep 15
        ready_after=$(k8sKubectl get rs test-rs -n "$RS_NS" \
            -o jsonpath='{.status.readyReplicas}' 2>&1)
        rlAssertEquals "ReplicaSet restored to 2 ready replicas after pod deletion" "2" "$ready_after"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$RS_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
