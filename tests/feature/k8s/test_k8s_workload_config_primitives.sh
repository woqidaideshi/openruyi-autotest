#!/bin/bash
# ============================================================
# Feature test: K8s Workload - ConfigMap, Secret, ServiceAccount
# ============================================================
# Purpose: Verify K8s workload configuration primitives work
#          correctly on RISC-V: ConfigMap/Secret mounting and env injection.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/lib.sh"

TEST_NS="k8s-feature-test-workload"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        sleep 2
    rlPhaseEnd

    rlPhaseStartTest "Create ConfigMap and mount as volume"
        k8sKubectl create configmap test-config -n "$TEST_NS" --from-literal=key1=value1 --from-literal=key2=value2 2>/dev/null
        
        cat > /tmp/cm-pod.yaml << 'CMEOF'
apiVersion: v1
kind: Pod
metadata:
  name: cm-test-pod
  namespace: CMNS
spec:
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sh", "-c", "cat /etc/config/key1 && cat /etc/config/key2 && sleep 60"]
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  volumes:
  - name: config-vol
    configMap:
      name: test-config
  restartPolicy: Never
CMEOF
        sed -i "s/CMNS/$TEST_NS/g" /tmp/cm-pod.yaml

        k8sKubectl apply -f /tmp/cm-pod.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod cm-test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        
        log_output=$(k8sKubectl logs cm-test-pod -n "$TEST_NS" 2>&1)
        rlLogInfo "ConfigMap pod log: $log_output"
        rlAssertGrep "value1" "$log_output" "ConfigMap key1 = value1"
        rlAssertGrep "value2" "$log_output" "ConfigMap key2 = value2"
    rlPhaseEnd

    rlPhaseStartTest "Create Secret and inject as environment variable"
        k8sKubectl create secret generic test-secret -n "$TEST_NS" \
            --from-literal=username=admin --from-literal=password=s3cr3t 2>/dev/null
        
        cat > /tmp/secret-pod.yaml << 'SECEOF'
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
  namespace: SECNS
spec:
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sh", "-c", "echo USER=$SECRET_USER && echo PASS=$SECRET_PASS && sleep 60"]
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
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  restartPolicy: Never
SECEOF
        sed -i "s/SECNS/$TEST_NS/g" /tmp/secret-pod.yaml

        k8sKubectl apply -f /tmp/secret-pod.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod secret-test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        
        secret_logs=$(k8sKubectl logs secret-test-pod -n "$TEST_NS" 2>&1)
        rlLogInfo "Secret pod env output: $secret_logs"
        rlAssertGrep "USER=admin" "$secret_logs" "Secret username injected as env"
        rlAssertGrep "PASS=s3cr3t" "$secret_logs" "Secret password injected as env"
    rlPhaseEnd

    rlPhaseStartTest "Create ServiceAccount and verify in pod"
        k8sKubectl create serviceaccount test-sa -n "$TEST_NS" 2>/dev/null
        
        cat > /tmp/sa-pod.yaml << 'SAEOF'
apiVersion: v1
kind: Pod
metadata:
  name: sa-test-pod
  namespace: SANS
spec:
  serviceAccountName: test-sa
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sh", "-c", "cat /var/run/secrets/kubernetes.io/serviceaccount/token && sleep 10"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  restartPolicy: Never
SAEOF
        sed -i "s/SANS/$TEST_NS/g" /tmp/sa-pod.yaml

        k8sKubectl apply -f /tmp/sa-pod.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod sa-test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        
        sa_verify=$(k8sKubectl get pod sa-test-pod -n "$TEST_NS" -o jsonpath='{.spec.serviceAccountName}' 2>&1)
        if [ "$sa_verify" = "test-sa" ]; then
            rlPass "ServiceAccount test-sa is assigned to pod"
        else
            rlFail "ServiceAccount not assigned correctly (got: $sa_verify)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/cm-pod.yaml /tmp/secret-pod.yaml /tmp/sa-pod.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
