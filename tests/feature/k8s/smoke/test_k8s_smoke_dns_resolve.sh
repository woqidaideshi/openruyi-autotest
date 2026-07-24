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

        if ! k8sDNSAvailable; then
            rlSkip "CoreDNS not deployed in this cluster — skipping DNS tests"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Verify DNS resolves kubernetes.default.svc.cluster.local"
        # Run busybox pod for DNS lookup; exec/logs unavailable, verify via exit code
        k8sKubectl run "$DNS_POD" -n "$DNS_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never \
            -- nslookup kubernetes.default.svc.cluster.local 2>&1 || true

        # Wait for pod to complete (Succeeded) or timeout (30s)
        for i in $(seq 1 12); do
            phase=$(k8sKubectl get pod "$DNS_POD" -n "$DNS_NS" \
                -o jsonpath='{.status.phase}' 2>&1)
            if [ "$phase" = "Succeeded" ] || [ "$phase" = "Failed" ]; then
                break
            fi
            sleep 5
        done

        exit_code=$(k8sKubectl get pod "$DNS_POD" -n "$DNS_NS" \
            -o jsonpath='{.status.containerStatuses[0].state.terminated.exitCode}' 2>&1)

        if [ "$exit_code" = "0" ]; then
            rlPass "DNS resolved kubernetes.default.svc.cluster.local (exit code: 0)"
        else
            rlFail "DNS resolution failed for kubernetes.default.svc.cluster.local (exit code: ${exit_code:-unknown})"
        fi

        k8sKubectl delete pod "$DNS_POD" -n "$DNS_NS" --force --grace-period=0 2>&1 || true
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$DNS_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
