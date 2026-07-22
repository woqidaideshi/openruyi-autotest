#!/bin/bash
# ============================================================
# Feature test: K8s - Quick cluster health verification
# ============================================================
# Purpose: Fast smoke test to verify K8s cluster basic health.
#          This is the FIRST test to run to ensure cluster is working.
# Expected environment: 2 nodes (1 master + 1 worker), RISC-V QEMU VMs
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        rlLogInfo "Starting K8s quick health check..."
    rlPhaseEnd

    rlPhaseStartTest "Verify kubectl is available"
        output=$(k8sKubectl version --client -o json 2>&1)
        rlAssertGrep "clientVersion" "$output" "kubectl client is installed"
        rlLogInfo "kubectl version info: $(echo \"$output\" | head -5)"
    rlPhaseEnd

    rlPhaseStartTest "Verify K8s cluster nodes status"
        output=$(k8sKubectl get nodes --no-headers 2>&1)
        rlRun "echo '$output'" 0 "List cluster nodes"
        
        # Check all nodes are Ready
        not_ready=$(echo "$output" | grep -v "Ready" | wc -l)
        if [ "$not_ready" -eq 0 ]; then
            rlPass "All nodes are in Ready state"
        else
            rlFail "Found $not_ready node(s) not in Ready state"
        fi
        
        # Check we have at least 2 nodes
        node_count=$(echo "$output" | wc -l)
        if [ "$node_count" -ge 2 ]; then
            rlPass "Cluster has $node_count nodes (>= 2)"
        else
            rlFail "Cluster has only $node_count node(s), expected >= 2"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify kube-system pods are running"
        output=$(k8sKubectl get pods -n kube-system --no-headers 2>&1)
        rlRun "echo '$output'" 0 "List kube-system pods"
        
        running=$(echo "$output" | grep -c "Running" || true)
        total=$(echo "$output" | wc -l)
        rlLogInfo "Running pods: $running / $total in kube-system"
        
        if [ "$running" -ge 5 ]; then
            rlPass "At least $running kube-system pods are Running"
        else
            rlFail "Only $running kube-system pods Running, expected >= 5"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify Calico CNI status"
        # Check Calico pods
        calico_pods=$(k8sKubectl get pods -n kube-system -l k8s-app=calico-node --no-headers 2>&1)
        calico_ready=$(echo "$calico_pods" | grep -c "Running" || true)
        rlLogInfo "Calico node pods running: $calico_ready"
        
        # Check Calico Ds
        calico_ds=$(k8sKubectl get ds -n kube-system calico-node --no-headers 2>&1)
        rlAssertNotGrep "0" "$(echo \"$calico_ds\" | awk '{print \$2}')" "Calico DaemonSet has ready pods"
    rlPhaseEnd

    rlPhaseStartTest "Verify CoreDNS is running"
        dns_pods=$(k8sKubectl get pods -n kube-system -l k8s-app=kube-dns --no-headers 2>&1)
        dns_ready=$(echo "$dns_pods" | grep -c "Running" || true)
        if [ "$dns_ready" -ge 1 ]; then
            rlPass "CoreDNS has $dns_ready Running pod(s)"
        else
            rlFail "CoreDNS pods not Running (expected >= 1)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"
        rlLogInfo "Quick health check completed"
        # No resources to clean up
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
