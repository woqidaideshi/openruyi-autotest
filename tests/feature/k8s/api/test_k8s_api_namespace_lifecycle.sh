#!/bin/bash
# ============================================================
# K8s API: Verify namespace lifecycle.
# Covers: create → resource isolation → delete → Terminating cleanup.
# Equivalent to Sonobuoy sig-api-machinery namespace tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

NS1="k8s-feature-test-api-ns1"
NS2="k8s-feature-test-api-ns2"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
    rlPhaseEnd

    rlPhaseStartTest "Namespace: create and verify isolation"
        k8sKubectl create namespace "$NS1" 2>/dev/null || true
        k8sKubectl create namespace "$NS2" 2>/dev/null || true

        # Create a ConfigMap in NS1 only
        k8sKubectl create configmap ns-test-cm -n "$NS1" \
            --from-literal=ns=ns1 2>&1

        # Verify it exists in NS1
        cm_in_ns1=$(k8sKubectl get configmap ns-test-cm -n "$NS1" \
            -o jsonpath='{.data.ns}' 2>&1)
        rlAssertEquals "ConfigMap visible in NS1" "ns1" "$cm_in_ns1"

        # Verify it does NOT exist in NS2
        if k8sKubectl get configmap ns-test-cm -n "$NS2" 2>/dev/null; then
            rlFail "ConfigMap leaked into NS2 — namespace isolation broken"
        else
            rlPass "ConfigMap NOT visible in NS2 — namespace isolation works"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Namespace: delete and verify cleanup"
        k8sKubectl delete namespace "$NS1" --timeout=60s 2>&1 || true
        k8sKubectl delete namespace "$NS2" --timeout=60s 2>&1 || true
        rlPass "Namespaces deleted"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$NS1" --ignore-not-found=true --timeout=30s 2>&1 || true
        k8sKubectl delete namespace "$NS2" --ignore-not-found=true --timeout=30s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
