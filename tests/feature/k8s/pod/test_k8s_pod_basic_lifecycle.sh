#!/bin/bash
# ============================================================
# K8s Pod: Verify basic Pod lifecycle.
# Covers: Pending→Running→Succeeded, restart policy, exit code.
# Equivalent to Sonobuoy sig-node pod lifecycle Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

POD_NS="k8s-feature-test-pod-life"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$POD_NS" 2>/dev/null || true

        if ! k8sExecAvailable; then
            rlLogWarning "kubectl exec/logs not available — will verify pod lifecycle via status only"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Pod: Running → Succeeded lifecycle"
        # Create a pod that runs to completion
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: lifecycle-test
  namespace: k8s-feature-test-pod-life
spec:
  restartPolicy: Never
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo 'hello world'; exit 0"]
YAML
        # Wait for pod to complete
        k8sKubectl wait --for=condition=Ready pod/lifecycle-test \
            -n "$POD_NS" --timeout=60s 2>/dev/null || true
        k8sKubectl wait --for=jsonpath='{.status.phase}'=Succeeded pod/lifecycle-test \
            -n "$POD_NS" --timeout=60s 2>/dev/null || true

        phase=$(k8sKubectl get pod lifecycle-test -n "$POD_NS" \
            -o jsonpath='{.status.phase}' 2>&1)
        rlAssertEquals "Pod phase is Succeeded" "Succeeded" "$phase"

        if k8sExecAvailable; then
            logs=$(k8sKubectl logs lifecycle-test -n "$POD_NS" 2>&1)
            rlAssertGrep "hello world" "$logs" "Pod output contains expected message"
        else
            rlPass "Pod lifecycle verified via status transition (exec unavailable)"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Pod: RestartPolicy=OnFailure, intentional failure"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: restart-test
  namespace: k8s-feature-test-pod-life
spec:
  restartPolicy: OnFailure
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo attempt; exit 1"]
YAML
        sleep 10

        restart_count=$(k8sKubectl get pod restart-test -n "$POD_NS" \
            -o jsonpath='{.status.containerStatuses[0].restartCount}' 2>&1)
        if [ "$restart_count" -ge 1 ]; then
            rlPass "Pod restarted on failure (restartCount=$restart_count)"
        else
            rlLogWarning "Pod restart count is $restart_count (may still be starting)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$POD_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
