#!/bin/bash
# ============================================================
# Feature test: K8s Scheduling - Anti-affinity and nodeSelector
# ============================================================
# Purpose: Verify K8s scheduler correctly distributes pods
#          using anti-affinity rules on RISC-V nodes.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

TEST_NS="k8s-feature-test-scheduling"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        k8sKubectl create namespace "$TEST_NS" 2>/dev/null
        sleep 2

        # Get node count
        NODE_COUNT=$(k8sKubectl get nodes --no-headers 2>/dev/null | grep -c "Ready" || echo 0)
        rlLogInfo "Available nodes: $NODE_COUNT"
    rlPhaseEnd

    rlPhaseStartTest "Create anti-affinity deployment"
        cat > /tmp/anti-affinity-deploy.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: anti-affinity-test
  namespace: SCHNS
spec:
  replicas: 2
  selector:
    matchLabels:
      app: anti-affinity-test
  template:
    metadata:
      labels:
        app: anti-affinity-test
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: app
                operator: In
                values:
                - anti-affinity-test
            topologyKey: "kubernetes.io/hostname"
      containers:
      - name: busybox
        image: busybox:1.36.1
        command: ["sleep", "600"]
        resources:
          requests:
            memory: "32Mi"
            cpu: "50m"
EOF
        sed -i "s/SCHNS/$TEST_NS/g" /tmp/anti-affinity-deploy.yaml

        k8sKubectl apply -f /tmp/anti-affinity-deploy.yaml 2>/dev/null
        
        for i in $(seq 1 30); do
            ready=$(k8sKubectl get deployment anti-affinity-test -n "$TEST_NS" -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
            if [ "$ready" = "2" ]; then
                break
            fi
            sleep 2
        done
        
        pods_output=$(k8sKubectl get pods -n "$TEST_NS" -l app=anti-affinity-test -o wide --no-headers 2>&1)
        rlRun "echo '$pods_output'" 0 "List anti-affinity pods"
        
        if [ "$NODE_COUNT" -ge 2 ]; then
            node1=$(echo "$pods_output" | awk 'NR==1{print $7}')
            node2=$(echo "$pods_output" | awk 'NR==2{print $7}')
            if [ "$node1" != "$node2" ]; then
                rlPass "Anti-affinity working: pods on different nodes ($node1 vs $node2)"
            else
                rlFail "Anti-affinity failed: both pods on same node $node1"
            fi
        else
            rlLogInfo "Only $NODE_COUNT node(s), skipping anti-affinity check"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Create nodeSelector deployment"
        # Get any node name
        target_node=$(k8sKubectl get nodes -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
        rlLogInfo "Target node for nodeSelector: $target_node"
        
        cat > /tmp/nodeselector-test.yaml << 'NSEOF'
apiVersion: v1
kind: Pod
metadata:
  name: nodeselector-pod
  namespace: SCHNS
spec:
  nodeSelector:
    kubernetes.io/hostname: "NODE_NAME"
  containers:
  - name: busybox
    image: busybox:1.36.1
    command: ["sleep", "300"]
    resources:
      requests:
        memory: "32Mi"
        cpu: "50m"
NSEOF
        sed -i "s/SCHNS/$TEST_NS/g" /tmp/nodeselector-test.yaml
        sed -i "s/NODE_NAME/$target_node/g" /tmp/nodeselector-test.yaml

        k8sKubectl apply -f /tmp/nodeselector-test.yaml 2>/dev/null
        for i in $(seq 1 30); do
            status=$(k8sKubectl get pod nodeselector-pod -n "$TEST_NS" -o jsonpath='{.status.phase}' 2>/dev/null)
            if [ "$status" = "Running" ]; then
                break
            fi
            sleep 2
        done
        scheduled_node=$(k8sKubectl get pod nodeselector-pod -n "$TEST_NS" -o jsonpath='{.spec.nodeName}' 2>/dev/null)
        if [ "$scheduled_node" = "$target_node" ]; then
            rlPass "nodeSelector works: pod scheduled to $target_node"
        else
            rlFail "nodeSelector failed: expected $target_node but got $scheduled_node"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify resource quota limits"
        cat > /tmp/rq-test.yaml << 'RQEOF'
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: SCHNS
spec:
  hard:
    pods: "10"
    requests.cpu: "4"
    requests.memory: "4Gi"
    limits.cpu: "8"
    limits.memory: "8Gi"
RQEOF
        sed -i "s/SCHNS/$TEST_NS/g" /tmp/rq-test.yaml

        k8sKubectl apply -f /tmp/rq-test.yaml 2>/dev/null
        rq_output=$(k8sKubectl get resourcequota compute-quota -n "$TEST_NS" --no-headers 2>&1)
        rlAssertNotGrep "not found\|Error" "$rq_output" "ResourceQuota is created"
        rlLogInfo "ResourceQuota: $(echo \"$rq_output\" | head -1)"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        k8sKubectl delete namespace "$TEST_NS" --ignore-not-found --wait 2>/dev/null
        rm -f /tmp/anti-affinity-deploy.yaml /tmp/nodeselector-test.yaml /tmp/rq-test.yaml
        rlLogInfo "Test namespace $TEST_NS cleaned up"
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
