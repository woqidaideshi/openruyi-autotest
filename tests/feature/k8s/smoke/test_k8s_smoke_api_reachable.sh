#!/bin/bash
# ============================================================
# K8s Smoke: Verify API Server /version endpoint reachable from
# a pod using the ServiceAccount token.
# Equivalent to Sonobuoy RISC-V smoke plugin API check.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

API_NS="k8s-feature-test-smoke-api"
API_POD="api-test"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$API_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "Verify API Server reachable via Service DNS + SA token"
        api_output=$(k8sKubectl run "$API_POD" -n "$API_NS" \
            --image=docker.io/library/busybox:1.36.1 \
            --restart=Never \
            --rm -i -- \
            sh -c 'wget -qO- --timeout=10 --no-check-certificate \
              --header "Authorization: Bearer $(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
              https://kubernetes.default.svc.cluster.local/version' 2>&1) || true

        rlLogInfo "API Server version output: $api_output"

        if echo "$api_output" | grep -q '"major"'; then
            version_info=$(echo "$api_output" | grep -o '"gitVersion":"[^"]*"' | head -1)
            rlPass "API Server /version returned valid JSON: $version_info"
        else
            rlFail "API Server /version did not return expected JSON with 'major' field"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$API_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
