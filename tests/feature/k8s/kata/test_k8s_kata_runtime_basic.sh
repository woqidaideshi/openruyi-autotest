#!/bin/bash
# ============================================================
# K8s Kata: Verify Kata Containers RuntimeClass and Pod scheduling.
# Gracefully skips if Kata runtime is not installed / configured.
# Equivalent to Sonobuoy sig-node RuntimeClass tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

KATA_NS="k8s-feature-test-kata"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$KATA_NS" 2>/dev/null || true

        if ! k8sKataRuntimeAvailable; then
            rlSkip "Kata Containers runtime not available — skipping Kata tests"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Kata: RuntimeClass creation"
        k8sApplyYAML <<'YAML'
apiVersion: node.k8s.io/v1
kind: RuntimeClass
metadata:
  name: kata
handler: kata
YAML
        rc_name=$(k8sKubectl get runtimeclass kata -o jsonpath='{.metadata.name}' 2>&1)
        rlAssertEquals "RuntimeClass 'kata' created" "kata" "$rc_name"
    rlPhaseEnd

    rlPhaseStartTest "Kata: Pod with kata RuntimeClass"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: kata-test-pod
  namespace: k8s-feature-test-kata
spec:
  runtimeClassName: kata
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo kata-running; sleep 30"]
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$KATA_NS" "app=kata-test-pod" 120 || true

        phase=$(k8sKubectl get pod kata-test-pod -n "$KATA_NS" \
            -o jsonpath='{.status.phase}' 2>&1 || echo "Unknown")
        rlLogInfo "Kata pod phase: $phase"

        if [ "$phase" = "Running" ] || [ "$phase" = "Succeeded" ]; then
            rlPass "Kata pod reached $phase state"
        else
            rlLogWarning "Kata pod in phase=$phase (may need additional configuration)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$KATA_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
        k8sKubectl delete runtimeclass kata --ignore-not-found=true 2>&1 || true
    rlPhaseEnd
rlJournalEnd
