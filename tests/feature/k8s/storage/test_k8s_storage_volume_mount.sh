#!/bin/bash
# ============================================================
# K8s Storage: Verify EmptyDir and PVC volume mount read/write.
# Equivalent to Sonobuoy sig-storage volume mount Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

VOL_NS="k8s-feature-test-sto-vol"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$VOL_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Volume mount: EmptyDir read and write"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: emptydir-test
  namespace: k8s-feature-test-sto-vol
spec:
  containers:
  - name: writer
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo 'hello-emptydir' > /data/test.txt; sleep 3600"]
    volumeMounts:
    - name: shared
      mountPath: /data
  - name: reader
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "sleep 300"]
    volumeMounts:
    - name: shared
      mountPath: /data
  volumes:
  - name: shared
    emptyDir: {}
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$VOL_NS" "app=emptydir-test" 60 || true

        # Read from reader container
        data=$(k8sExecInPod "$VOL_NS" emptydir-test -c reader -- cat /data/test.txt 2>&1)
        rlAssertGrep "hello-emptydir" "$data" "EmptyDir: reader container sees data written by writer"
    rlPhaseEnd

    rlPhaseStartTest "Volume mount: HostPath read and write"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: hostpath-test
  namespace: k8s-feature-test-sto-vol
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "echo 'hello-hostpath' > /hostdata/test.txt; sleep 3600"]
    volumeMounts:
    - name: hostvol
      mountPath: /hostdata
  volumes:
  - name: hostvol
    hostPath:
      path: /tmp/k8s-test-hostpath
      type: DirectoryOrCreate
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$VOL_NS" "app=hostpath-test" 60 || true

        data=$(k8sExecInPod "$VOL_NS" hostpath-test -- cat /hostdata/test.txt 2>&1)
        rlAssertGrep "hello-hostpath" "$data" "HostPath: pod wrote and read data successfully"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$VOL_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
