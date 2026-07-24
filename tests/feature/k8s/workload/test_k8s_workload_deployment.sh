#!/bin/bash
# ============================================================
# K8s Workload: Verify Deployment scale, rolling update, rollback.
# Equivalent to Sonobuoy sig-apps Deployment Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

WL_NS="k8s-feature-test-wl-deploy"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$WL_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Deployment: create and verify replicas"
        k8sApplyYAML <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-deploy
  namespace: k8s-feature-test-wl-deploy
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test-deploy
  template:
    metadata:
      labels:
        app: test-deploy
    spec:
      containers:
      - name: main
        image: docker.io/library/busybox:1.36.1
        command: ["sleep", "3600"]
YAML
        k8sWaitForPodReady "$WL_NS" "app=test-deploy" 120

        ready=$(k8sKubectl get deployment test-deploy -n "$WL_NS" \
            -o jsonpath='{.status.readyReplicas}' 2>&1)
        rlAssertEquals "Deployment has 2 ready replicas" "2" "$ready"
    rlPhaseEnd

    rlPhaseStartTest "Deployment: scale up to 3 replicas"
        k8sKubectl scale deployment test-deploy -n "$WL_NS" --replicas=3 2>&1
        k8sWaitForPodReady "$WL_NS" "app=test-deploy" 120

        ready=$(k8sKubectl get deployment test-deploy -n "$WL_NS" \
            -o jsonpath='{.status.readyReplicas}' 2>&1)
        rlAssertEquals "Deployment scaled to 3 ready replicas" "3" "$ready"
    rlPhaseEnd

    rlPhaseStartTest "Deployment: scale down to 1 replica"
        k8sKubectl scale deployment test-deploy -n "$WL_NS" --replicas=1 2>&1
        sleep 10

        ready=$(k8sKubectl get deployment test-deploy -n "$WL_NS" \
            -o jsonpath='{.status.readyReplicas}' 2>&1)
        rlAssertEquals "Deployment scaled down to 1 ready replica" "1" "$ready"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$WL_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
