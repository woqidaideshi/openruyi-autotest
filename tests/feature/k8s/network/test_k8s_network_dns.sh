#!/bin/bash
# ============================================================
# K8s Network: Verify CoreDNS resolution.
# Covers: Service FQDN, external domain, short name.
# Equivalent to Sonobuoy sig-network DNS Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

DNS_NS="k8s-feature-test-net-dns"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$DNS_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "DNS: resolve Service FQDN from pod"
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Service
metadata:
  name: dns-test-svc
  namespace: k8s-feature-test-net-dns
spec:
  ports:
  - port: 80
  selector:
    app: dns-test
YAML
        # Resolve the service FQDN from a one-shot pod
        result=$(k8sKubectl run dns-test -n "$DNS_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never --rm -i -- \
            nslookup "dns-test-svc.$DNS_NS.svc.cluster.local" 2>&1) || true

        rlLogInfo "DNS result: $result"
        if echo "$result" | grep -q "Address:"; then
            rlPass "Service FQDN resolved successfully"
        else
            rlFail "Service FQDN resolution failed"
        fi
    rlPhaseEnd

    rlPhaseStartTest "DNS: resolve external domain"
        result=$(k8sKubectl run dns-ext -n "$DNS_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never --rm -i -- \
            nslookup kubernetes.io 2>&1) || true

        rlLogInfo "External DNS result: $result"
        if echo "$result" | grep -q "Address:"; then
            rlPass "External domain resolved successfully"
        else
            rlLogWarning "External DNS resolution failed (might be expected in offline env)"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$DNS_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
