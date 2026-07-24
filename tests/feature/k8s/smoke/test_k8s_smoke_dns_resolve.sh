#!/bin/bash
# ============================================================
# K8s Smoke: Verify DNS resolution of kubernetes.default.svc.cluster.local.
# Equivalent to Sonobuoy RISC-V smoke plugin DNS check.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

DNS_NS="k8s-feature-test-smoke-dns"
DNS_POD="dns-test"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$DNS_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Verify DNS resolves kubernetes.default.svc.cluster.local"
        # Run a one-shot busybox pod for DNS check
        dns_output=$(k8sKubectl run "$DNS_POD" -n "$DNS_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never \
            --rm -i -- \
            nslookup kubernetes.default.svc.cluster.local 2>&1) || true

        rlLogInfo "DNS lookup output: $dns_output"

        if echo "$dns_output" | grep -q "Address:"; then
            resolved_ip=$(echo "$dns_output" | grep "Address:" | tail -1 | awk '{print $NF}' | tr -d '\r')
            rlPass "DNS resolved kubernetes.default.svc.cluster.local to $resolved_ip"
        else
            rlFail "DNS resolution failed for kubernetes.default.svc.cluster.local"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$DNS_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
