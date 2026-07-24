#!/bin/bash
# ============================================================
# K8s Config: Verify Secret creation, volume mount, and env injection.
# Equivalent to Sonobuoy sig-config Secret Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

SEC_NS="k8s-feature-test-cfg-sec"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$SEC_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Secret: create Secret and verify volume mount"
        # Create opaque Secret
        k8sKubectl create secret generic test-secret \
            -n "$SEC_NS" \
            --from-literal=username=admin \
            --from-literal=password=secret123 2>&1

        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
  namespace: k8s-feature-test-cfg-sec
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "cat /etc/secrets/username; echo; cat /etc/secrets/password; sleep 300"]
    volumeMounts:
    - name: secret-vol
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-vol
    secret:
      secretName: test-secret
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$SEC_NS" "app=secret-test-pod" 60 || true

        logs=$(k8sKubectl logs secret-test-pod -n "$SEC_NS" 2>&1)
        rlAssertGrep "admin" "$logs" "Secret username mounted correctly"
        rlAssertGrep "secret123" "$logs" "Secret password mounted correctly"
    rlPhaseEnd

    rlPhaseStartTest "Secret: verify as environment variable"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
  namespace: k8s-feature-test-cfg-sec
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo \$SECRET_USER; echo \$SECRET_PASS; sleep 30"]
    env:
    - name: SECRET_USER
      valueFrom:
        secretKeyRef:
          name: test-secret
          key: username
    - name: SECRET_PASS
      valueFrom:
        secretKeyRef:
          name: test-secret
          key: password
  restartPolicy: Never
YAML
        sleep 10

        logs=$(k8sKubectl logs secret-env-pod -n "$SEC_NS" 2>&1)
        rlAssertGrep "admin" "$logs" "Secret injected as env var (username)"
        rlAssertGrep "secret123" "$logs" "Secret injected as env var (password)"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$SEC_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
