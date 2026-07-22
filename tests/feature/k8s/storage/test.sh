#!/bin/bash
# ============================================================
# Feature test: K8s Storage - PVC lifecycle with local-path provisioner
# ============================================================
# Purpose: Verify local-path-provisioner works on RISC-V
#          - PVC creation, binding, pod mounting, data persistence
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

TEST_NS="k8s-feature-test-storage"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        sleep 2
    rlPhaseEnd

    rlPhaseStartTest "Verify local-path-provisioner is running"
        sc_output=$(k8sKubectl get storageclass 2>&1)
        rlAssertGrep "local-path" "$sc_output" "local-path StorageClass exists"
        
        lp_pods=$(k8sKubectl get pods -n kube-system -l app=local-path-provisioner --no-headers 2>&1)
        rlAssertGrep "Running" "$lp_pods" "local-path-provisioner pod is Running"
    rlPhaseEnd

    rlPhaseStartTest "Create PVC and verify binding"
        cat > /tmp/test-pvc.yaml << 'PVCEOF'
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
  namespace: PVCNS
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-path
PVCEOF
        sed -i "s/PVCNS/$TEST_NS/g" /tmp/test-pvc.yaml

        k8sKubectl apply -f /tmp/test-pvc.yaml 2>/dev/null
        # Wait for PVC to be bound
        for i in $(seq 1 30); do
            phase=$(k8sKubectl get pvc test-pvc -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$phase" = "Bound" ]; then
                break
            fi
            sleep 2
        done
        pvc_output=$(k8sKubectl get pvc test-pvc -n "$TEST_NS" --no-headers 2>&1)
        rlAssertGrep "Bound" "$pvc_output" "PVC test-pvc is Bound"
        rlLogInfo "PVC status: $pvc_output"
    rlPhaseEnd

    rlPhaseStartTest "Mount PVC to pod and write data"
        cat > /tmp/test-storage-pod.yaml << 'PODEOF'
apiVersion: v1
kind: Pod
metadata:
  name: storage-writer
  namespace: PODNS
spec:
  containers:
  - name: writer
    image: busybox:1.36.1
    command: ["sh", "-c", "echo 'k8s-storage-test-data' > /data/test.txt && sleep 3600"]
    volumeMounts:
    - name: data-vol
      mountPath: /data
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  volumes:
  - name: data-vol
    persistentVolumeClaim:
      claimName: test-pvc
  restartPolicy: Never
PODEOF
        sed -i "s/PODNS/$TEST_NS/g" /tmp/test-storage-pod.yaml

        k8sKubectl apply -f /tmp/test-storage-pod.yaml 2>/dev/null
        # Wait for pod to be Running
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod storage-writer -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        writer_output=$(k8sKubectl get pod storage-writer -n "$TEST_NS" --no-headers 2>&1)
        rlAssertGrep "Running" "$writer_output" "Storage writer pod is Running"
    rlPhaseEnd

    rlPhaseStartTest "Delete writer pod and verify data persistence"
        k8sKubectl delete pod storage-writer -n "$TEST_NS" --wait 2>/dev/null
        sleep 3
        
        # Create reader pod using same PVC
        cat > /tmp/test-reader-pod.yaml << 'READEREOF'
apiVersion: v1
kind: Pod
metadata:
  name: storage-reader
  namespace: PODNS
spec:
  containers:
  - name: reader
    image: busybox:1.36.1
    command: ["sh", "-c", "cat /data/test.txt && echo '---append---' >> /data/test.txt && sleep 10"]
    volumeMounts:
    - name: data-vol
      mountPath: /data
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  volumes:
  - name: data-vol
    persistentVolumeClaim:
      claimName: test-pvc
  restartPolicy: Never
READEREOF
        sed -i "s/PODNS/$TEST_NS/g" /tmp/test-reader-pod.yaml

        k8sKubectl apply -f /tmp/test-reader-pod.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod storage-reader -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        
        # Check pod logs for the original data
        log_output=$(k8sKubectl logs storage-reader -n "$TEST_NS" 2>&1)
        rlLogInfo "Reader pod log: $log_output"
        rlAssertGrep "k8s-storage-test-data" "$log_output" "Data persisted after pod deletion (original data found)"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete pod storage-reader -n "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl delete pvc test-pvc -n "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/test-pvc.yaml /tmp/test-storage-pod.yaml /tmp/test-reader-pod.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
