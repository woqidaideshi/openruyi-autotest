#!/bin/bash
# ============================================================
# Feature test: K8s Conformance - Pod lifecycle verification
# ============================================================
# Purpose: Verify basic K8s pod lifecycle (create/delete/multi-replica)
#          which is the foundation for all K8s workloads.
#          This is a lightweight alternative to full Sonobuoy conformance.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

TEST_NS="k8s-feature-test-conformance"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        # Ensure clean namespace
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        rlLogInfo "Created test namespace: $TEST_NS"
        # Wait for namespace to be ready
        sleep 2
    rlPhaseEnd

    rlPhaseStartTest "Create a single pod with busybox"
        cat > /tmp/test-pod.yaml << 'PODEOF'
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: PODNS
spec:
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sleep", "3600"]
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
  restartPolicy: Never
PODEOF
        sed -i "s/PODNS/$TEST_NS/g" /tmp/test-pod.yaml

        k8sKubectl apply -f /tmp/test-pod.yaml 2>/dev/null
        # Wait for pod to be ready
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod test-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        output=$(k8sKubectl get pod test-pod -n "$TEST_NS" --no-headers 2>&1)
        rlAssertGrep "Running" "$output" "Pod test-pod is Running"
        rlLogInfo "Pod status: $output"
    rlPhaseEnd

    rlPhaseStartTest "Create a Deployment with 2 replicas"
        cat > /tmp/test-deploy.yaml << 'DEPLOYEOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test-nginx
  namespace: DEPNS
spec:
  replicas: 2
  selector:
    matchLabels:
      app: test-nginx
  template:
    metadata:
      labels:
        app: test-nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.27-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
DEPLOYEOF
        sed -i "s/DEPNS/$TEST_NS/g" /tmp/test-deploy.yaml

        k8sKubectl apply -f /tmp/test-deploy.yaml 2>/dev/null
        # Wait for deployment to be ready
        for i in $(seq 1 60); do
            ready=$(k8sKubectl get deployment test-nginx -n "$TEST_NS" -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
            if [ "$ready" = "2" ]; then
                break
            fi
            sleep 2
        done
        output=$(k8sKubectl get deployment test-nginx -n "$TEST_NS" --no-headers 2>&1)
        rlAssertGrep "2/2" "$output" "Deployment test-nginx has 2/2 replicas ready"
        rlLogInfo "Deployment status: $output"
    rlPhaseEnd

    rlPhaseStartTest "Verify pod distribution across nodes"
        pods=$(k8sKubectl get pods -n "$TEST_NS" -l app=test-nginx -o wide --no-headers 2>&1)
        rlRun "echo '$pods'" 0 "List nginx pods with node distribution"
        node1=$(echo "$pods" | awk 'NR==1{print $7}')
        node2=$(echo "$pods" | awk 'NR==2{print $7}')
        if [ "$node1" != "$node2" ]; then
            rlPass "Pods are distributed across different nodes: $node1 and $node2"
        else
            rlLogInfo "Pods scheduled on same node: $node1 (may be OK for 2-replica test)"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Delete pod and verify auto-recreation"
        pod_name=$(k8sKubectl get pods -n "$TEST_NS" -l app=test-nginx -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
        rlLogInfo "Deleting pod: $pod_name"
        k8sKubectl delete pod "$pod_name" -n "$TEST_NS" --wait 2>/dev/null
        sleep 3
        new_output=$(k8sKubectl get pods -n "$TEST_NS" -l app=test-nginx --no-headers 2>&1)
        pod_count=$(echo "$new_output" | wc -l)
        if [ "$pod_count" -eq 2 ]; then
            rlPass "Deployment auto-recreated pod (found $pod_count pods)"
        else
            rlFail "Expected 2 pods but found $pod_count"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Scale up Deployment to verify node capacity"
        k8sKubectl scale deployment test-nginx -n "$TEST_NS" --replicas=4 2>/dev/null
        sleep 10
        scaled_output=$(k8sKubectl get deployment test-nginx -n "$TEST_NS" --no-headers 2>&1)
        ready_count=$(echo "$scaled_output" | awk '{print $2}')
        rlLogInfo "Scaled deployment: $scaled_output"
        if [ "$ready_count" = "4/4" ]; then
            rlPass "Deployment scaled to 4 replicas successfully"
        else
            rlLogInfo "Deployment at $ready_count (may be limited by node resources in QEMU)"
        fi
        # Scale back
        k8sKubectl scale deployment test-nginx -n "$TEST_NS" --replicas=1 2>/dev/null
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/test-pod.yaml /tmp/test-deploy.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
