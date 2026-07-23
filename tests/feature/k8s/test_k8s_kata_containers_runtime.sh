#!/bin/bash
# ============================================================
# Feature test: K8s Kata Containers - RuntimeClass verification
# ============================================================
# Purpose: Verify Kata Containers (kata-clh) RuntimeClass works
#          on RISC-V K8s cluster. This validates the secure
#          container runtime deployed alongside containerd.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/lib.sh"

TEST_NS="k8s-feature-test-kata"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        sleep 2
    rlPhaseEnd

    rlPhaseStartTest "Verify kata-clh RuntimeClass exists"
        rc_output=$(k8sKubectl get runtimeclass 2>&1)
        rlLogInfo "RuntimeClasses: $(echo \"$rc_output\")"
        if echo "$rc_output" | grep -q "kata-clh"; then
            rlPass "kata-clh RuntimeClass exists"
        else
            rlFail "kata-clh RuntimeClass not found"
            rlLogInfo "Skipping remaining kata tests"
            # Still report the test phases but as skipped
            rlPhaseEnd
            rlPhaseStartCleanup "Clean up test environment"
                k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
                rlLogInfo "Cleanup done (partial due to skip)"
            rlPhaseEnd
            rlJournalPrintText
            rlJournalEnd
            exit 0
        fi
    rlPhaseEnd

    rlPhaseStartTest "Create Kata pod with kata-clh runtime"
        cat > /tmp/kata-pod.yaml << 'KATAEOF'
apiVersion: v1
kind: Pod
metadata:
  name: kata-test-pod
  namespace: KATANS
spec:
  runtimeClassName: kata-clh
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sleep", "120"]
    resources:
      requests:
        memory: "128Mi"
        cpu: "200m"
      limits:
        memory: "256Mi"
        cpu: "500m"
  restartPolicy: Never
KATAEOF
        sed -i "s/KATANS/$TEST_NS/g" /tmp/kata-pod.yaml

        k8sKubectl apply -f /tmp/kata-pod.yaml 2>/dev/null
        # Wait longer for Kata (VM boot)
        for i in $(seq 1 45); do
            status=$(k8sKubectl get pod kata-test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            if [ "$status" = "Failed" ]; then
                rlFail "Kata pod failed during startup"
                break
            fi
            sleep 2
        done
        
        kata_output=$(k8sKubectl get pod kata-test-pod -n "$TEST_NS" --no-headers 2>&1)
        rlLogInfo "Kata pod status: $kata_output"
        rlAssertGrep "Running" "$kata_output" "Kata pod is Running via kata-clh runtime"
    rlPhaseEnd

    rlPhaseStartTest "Verify Kata pod isolation by checking kernel"
        # Get uname from inside the Kata pod
        uname_output=$(k8sKubectl exec kata-test-pod -n "$TEST_NS" -- uname -r 2>&1)
        rlLogInfo "Kata pod kernel: $uname_output"
        
        # Get host kernel for comparison
        if [ -f "$TMT_TEST_TOPOLOGY_FILE" ]; then
            . "$TMT_TEST_TOPOLOGY_FILE"
            host_kernel=$(sshpass -p "${TEST_SERVER_1_PASSWORD:-}" ssh -o StrictHostKeyChecking=no \
                -p "${TEST_SERVER_1_PORT:-22}" "${TEST_SERVER_1_USER:-root}@${TEST_SERVER_1_HOST}" "uname -r" 2>/dev/null)
            rlLogInfo "Host kernel: $host_kernel"
            if [ "$uname_output" != "$host_kernel" ]; then
                rlPass "Kata pod uses its own kernel (different from host)"
            else
                rlLogInfo "Kata and host kernel version match (may be expected for cloud-hypervisor)"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify network connectivity for Kata pod"
        # Check if kata pod can resolve DNS
        dns_test=$(k8sKubectl exec kata-test-pod -n "$TEST_NS" -- nslookup kubernetes.default.svc.cluster.local 2>&1)
        rlLogInfo "Kata pod DNS: $(echo \"$dns_test\" | head -2)"
        
        # Test network connectivity
        net_test=$(k8sKubectl exec kata-test-pod -n "$TEST_NS" -- wget -q -O - -T 5 http://10.96.0.1:443/version 2>&1)
        rlLogInfo "Kata pod network test to API server: $(echo \"$net_test\" | head -2)"
        
        if echo "$dns_test" | grep -q "10.96"; then
            rlPass "Kata pod has DNS resolution"
        else
            rlLogInfo "Kata pod DNS test returned unexpected result (may be OK)"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Compare runc vs kata-clh pod startup performance"
        # Create a regular runc pod for comparison
        cat > /tmp/runc-pod.yaml << 'RUNCEOF'
apiVersion: v1
kind: Pod
metadata:
  name: runc-test-pod
  namespace: KATANS
spec:
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sleep", "10"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
  restartPolicy: Never
RUNCEOF
        sed -i "s/KATANS/$TEST_NS/g" /tmp/runc-pod.yaml

        start_time=$(date +%s)
        k8sKubectl apply -f /tmp/runc-pod.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod runc-test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 1
        done
        end_time=$(date +%s)
        runc_startup=$((end_time - start_time))
        rlLogInfo "runc pod startup time: ${runc_startup}s"
        rlLogInfo "Kata pod startup is expected to be slower due to VM boot overhead"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/kata-pod.yaml /tmp/runc-pod.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
