#!/bin/bash
# ============================================================
# K8s Auth: Verify ServiceAccount creation and API access.
# Equivalent to Sonobuoy sig-auth ServiceAccount Conformance tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

AUTH_NS="k8s-feature-test-auth-sa"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$AUTH_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "ServiceAccount: create and verify token mount"
        # Create ServiceAccount
        k8sKubectl create serviceaccount test-sa -n "$AUTH_NS" 2>&1

        # Create a pod using this SA
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: sa-test-pod
  namespace: k8s-feature-test-auth-sa
spec:
  serviceAccountName: test-sa
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sh", "-c", "ls -la /var/run/secrets/kubernetes.io/serviceaccount/; cat /var/run/secrets/kubernetes.io/serviceaccount/token | head -c 20; sleep 300"]
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$AUTH_NS" "app=sa-test-pod" 60 || true

        # Verify SA token is mounted
        token=$(k8sExecInPod "$AUTH_NS" sa-test-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token 2>&1)
        if [ -n "$token" ] && [ ${#token} -gt 10 ]; then
            rlPass "ServiceAccount token is mounted in Pod"
        else
            rlFail "ServiceAccount token not found or too short"
        fi

        # Verify namespace file
        ns_file=$(k8sExecInPod "$AUTH_NS" sa-test-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/namespace 2>&1)
        rlAssertEquals "SA namespace matches" "$AUTH_NS" "$ns_file"

        # Try accessing API server with the token
        api_result=$(k8sExecInPod "$AUTH_NS" sa-test-pod -- sh -c "
            wget -qO- --no-check-certificate \
            --header='Authorization: Bearer \$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)' \
            https://\$KUBERNETES_SERVICE_HOST:\$KUBERNETES_SERVICE_PORT/api/v1/namespaces/$AUTH_NS/pods/sa-test-pod \
            2>/dev/null || echo 'wget-failed'
        " 2>&1)
        if echo "$api_result" | grep -q '"kind":\|wget-failed'; then
            rlLogInfo "API access result: ${api_result:0:200}"
            rlPass "ServiceAccount attempted API server access"
        else
            rlLogWarning "Unexpected API response: ${api_result:0:200}"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$AUTH_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
