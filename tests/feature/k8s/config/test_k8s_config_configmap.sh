#!/bin/bash
# ============================================================
# K8s Config: Verify ConfigMap creation, volume mount, and env injection.
# Equivalent to Sonobuoy sig-config ConfigMap Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

CM_NS="k8s-feature-test-cfg-cm"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$CM_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "ConfigMap: create and verify volume mount"
        k8sKubectl create configmap test-config \
            -n "$CM_NS" \
            --from-literal=app.name=myapp \
            --from-literal=app.version=v1.0 2>&1

        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: cm-test-pod
  namespace: k8s-feature-test-cfg-cm
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "cat /etc/config/app.name; echo; cat /etc/config/app.version; sleep 300"]
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
  volumes:
  - name: config-vol
    configMap:
      name: test-config
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$CM_NS" "app=cm-test-pod" 60 || true

        logs=$(k8sKubectl logs cm-test-pod -n "$CM_NS" 2>&1)
        rlAssertGrep "myapp" "$logs" "ConfigMap app.name mounted correctly"
        rlAssertGrep "v1.0" "$logs" "ConfigMap app.version mounted correctly"
    rlPhaseEnd

    rlPhaseStartTest "ConfigMap: verify as environment variable"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: cm-env-pod
  namespace: k8s-feature-test-cfg-cm
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo \$APP_NAME; echo \$APP_VER; sleep 30"]
    env:
    - name: APP_NAME
      valueFrom:
        configMapKeyRef:
          name: test-config
          key: app.name
    - name: APP_VER
      valueFrom:
        configMapKeyRef:
          name: test-config
          key: app.version
  restartPolicy: Never
YAML
        sleep 10

        logs=$(k8sKubectl logs cm-env-pod -n "$CM_NS" 2>&1)
        rlAssertGrep "myapp" "$logs" "ConfigMap injected as env var (app.name)"
        rlAssertGrep "v1.0" "$logs" "ConfigMap injected as env var (app.version)"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$CM_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
