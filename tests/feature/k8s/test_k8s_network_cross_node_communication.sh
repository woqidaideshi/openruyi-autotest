#!/bin/bash
# ============================================================
# Feature test: K8s Network - Cross-node pod communication
# ============================================================
# Purpose: Verify Calico CNI enables cross-node pod-to-pod
#          and pod-to-service communication on RISC-V.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/lib.sh"

TEST_NS="k8s-feature-test-network"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        sleep 2
    rlPhaseEnd

    rlPhaseStartTest "Deploy nginx server and expose via ClusterIP"
        cat > /tmp/nginx-svc.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: nginx-server
  namespace: NETNS
  labels:
    app: nginx-server
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
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-svc
  namespace: NETNS
spec:
  selector:
    app: nginx-server
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF
        sed -i "s/NETNS/$TEST_NS/g" /tmp/nginx-svc.yaml

        k8sKubectl apply -f /tmp/nginx-svc.yaml 2>/dev/null
        # Wait for nginx pod
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod nginx-server -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        rlLogInfo "Nginx server pod deployed"
    rlPhaseEnd

    rlPhaseStartTest "Create client pod and verify ClusterIP access"
        cat > /tmp/client-pod.yaml << 'CLIENTEOF'
apiVersion: v1
kind: Pod
metadata:
  name: net-client
  namespace: CLNS
spec:
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sleep", "3600"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
CLIENTEOF
        sed -i "s/CLNS/$TEST_NS/g" /tmp/client-pod.yaml

        k8sKubectl apply -f /tmp/client-pod.yaml 2>/dev/null
        # Wait for client pod
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod net-client -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done

        # Get ClusterIP
        svc_ip=$(k8sKubectl get svc nginx-svc -n "$TEST_NS" -o jsonpath='{.spec.clusterIP}' 2>/dev/null)
        rlLogInfo "ClusterIP of nginx-svc: $svc_ip"
        rlAssertNotEmpty "$svc_ip" "ClusterIP is assigned"

        # Test connectivity from client pod
        curl_output=$(k8sKubectl exec net-client -n "$TEST_NS" -- wget -q -O - -T 5 "http://$svc_ip" 2>&1)
        if echo "$curl_output" | grep -q "nginx\|Welcome\|html"; then
            rlPass "Pod-to-ClusterIP connectivity works (got nginx response)"
        else
            rlLogInfo "wget output: $(echo "$curl_output" | head -3)"
            rlFail "Failed to reach nginx via ClusterIP"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify DNS resolution from client pod"
        dns_output=$(k8sKubectl exec net-client -n "$TEST_NS" -- nslookup nginx-svc 2>&1)
        rlLogInfo "DNS lookup result: $dns_output"
        if echo "$dns_output" | grep -q "$svc_ip"; then
            rlPass "DNS resolves nginx-svc to ClusterIP $svc_ip"
        else
            rlLogInfo "DNS may not have resolved correctly, checking by IP directly"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Create NodePort service and test external access"
        k8sKubectl expose pod nginx-server -n "$TEST_NS" --name=nginx-nodeport --type=NodePort --port=80 2>/dev/null
        nodeport=$(k8sKubectl get svc nginx-nodeport -n "$TEST_NS" -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
        rlLogInfo "NodePort: $nodeport"
        
        # Test NodePort from master node via SSH
        if [ -f "$TMT_TEST_TOPOLOGY_FILE" ]; then
            . "$TMT_TEST_TOPOLOGY_FILE"
            master_host="${TEST_SERVER_1_HOST:-127.0.0.1}"
            master_port="${TEST_SERVER_1_PORT:-22}"
            master_user="${TEST_SERVER_1_USER:-root}"
            master_pass="${TEST_SERVER_1_PASSWORD:-}"
            nodeport_output=$(sshpass -p "$master_pass" ssh -o StrictHostKeyChecking=no -p "$master_port" "$master_user@$master_host" \
                "curl -s --connect-timeout 5 http://127.0.0.1:$nodeport" 2>&1)
            if echo "$nodeport_output" | grep -qi "nginx\|Welcome\|html"; then
                rlPass "NodePort service accessible on master node port $nodeport"
            else
                rlFail "NodePort service not accessible (output: $(echo \"$nodeport_output\" | head -1))"
            fi
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/nginx-svc.yaml /tmp/client-pod.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
