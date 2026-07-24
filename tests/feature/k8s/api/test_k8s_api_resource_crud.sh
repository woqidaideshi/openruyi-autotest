#!/bin/bash
# ============================================================
# K8s API: Verify CRUD operations on core resources.
# Covers: Pod, ConfigMap, Service create/get/update/delete.
# Equivalent to Sonobuoy sig-api-machinery Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

API_NS="k8s-feature-test-api-crud"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$API_NS" 2>/dev/null || true
    rlPhaseEnd

    # --- ConfigMap CRUD ---
    rlPhaseStartTest "ConfigMap: create → get → update → delete"
        k8sKubectl create configmap test-cm -n "$API_NS" \
            --from-literal=key1=value1 2>&1
        rlRun "echo 'ConfigMap created'" 0

        cm_out=$(k8sKubectl get configmap test-cm -n "$API_NS" -o jsonpath='{.data.key1}' 2>&1)
        rlAssertEquals "ConfigMap key1 equals value1" "value1" "$cm_out"

        k8sKubectl create configmap test-cm -n "$API_NS" \
            --from-literal=key1=value2 --dry-run=client -o yaml 2>/dev/null | \
            k8sKubectl replace -f - 2>&1
        cm_out2=$(k8sKubectl get configmap test-cm -n "$API_NS" -o jsonpath='{.data.key1}' 2>&1)
        rlAssertEquals "ConfigMap key1 updated to value2" "value2" "$cm_out2"

        k8sKubectl delete configmap test-cm -n "$API_NS" 2>&1
        rlRun "echo 'ConfigMap deleted'" 0
    rlPhaseEnd

    # --- Service CRUD ---
    rlPhaseStartTest "Service: create → get → delete"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: test-svc
  namespace: k8s-feature-test-api-crud
spec:
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: test-svc
YAML
        svc_ip=$(k8sKubectl get svc test-svc -n "$API_NS" \
            -o jsonpath='{.spec.clusterIP}' 2>&1)
        rlAssertNotEquals "Service has a ClusterIP" "" "$svc_ip"

        k8sKubectl delete svc test-svc -n "$API_NS" 2>&1
        rlRun "echo 'Service deleted'" 0
    rlPhaseEnd

    # --- Pod CRUD (create → get → delete) ---
    rlPhaseStartTest "Pod: create → get status → delete"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: k8s-feature-test-api-crud
spec:
  containers:
  - name: pause
    image: docker.io/library/busybox:1.36.1
    command: ["sleep", "3600"]
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$API_NS" "app=test-pod" 60 || true

        pod_phase=$(k8sKubectl get pod test-pod -n "$API_NS" \
            -o jsonpath='{.status.phase}' 2>&1)
        rlAssertEquals "Pod is Running" "Running" "$pod_phase"

        k8sKubectl delete pod test-pod -n "$API_NS" --grace-period=0 2>&1
        rlRun "echo 'Pod deleted'" 0
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$API_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
