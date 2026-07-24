#!/bin/bash
# ============================================================
# K8s Pod: Verify multi-container Pod with init container.
# Covers: Init container runs first, shared emptyDir volume.
# Equivalent to Sonobuoy sig-node multi-container tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

MULTI_NS="k8s-feature-test-pod-multi"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$MULTI_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Multi-container Pod with init container and shared volume"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: multi-container-test
  namespace: k8s-feature-test-pod-multi
spec:
  initContainers:
  - name: init
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo init-done > /shared/init.txt"]
    volumeMounts:
    - name: shared
      mountPath: /shared
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "cat /shared/init.txt; echo main-running; sleep 3600"]
    volumeMounts:
    - name: shared
      mountPath: /shared
  volumes:
  - name: shared
    emptyDir: {}
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$MULTI_NS" "app=multi-container-test" 60 || true

        pod_phase=$(k8sKubectl get pod multi-container-test -n "$MULTI_NS" \
            -o jsonpath='{.status.phase}' 2>&1)
        rlAssertEquals "Multi-container Pod is Running" "Running" "$pod_phase"

        # Verify init container completed
        init_done=$(k8sKubectl get pod multi-container-test -n "$MULTI_NS" \
            -o jsonpath='{.status.initContainerStatuses[0].state.terminated.reason}' 2>&1)
        rlAssertEquals "Init container completed successfully" "Completed" "$init_done"

        # Verify main container sees init container's data
        logs=$(k8sKubectl logs multi-container-test -n "$MULTI_NS" -c main 2>&1)
        rlAssertGrep "init-done" "$logs" "Main container sees init container output via shared volume"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$MULTI_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
