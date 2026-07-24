#!/bin/bash
# ============================================================
# K8s Network: Verify NodePort Service creation and port allocation.
# Equivalent to Sonobuoy sig-network NodePort tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

NP_NS="k8s-feature-test-net-np"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$NP_NS" 2>/dev/null || true
    rlPhaseEnd

    rlPhaseStartTest "NodePort Service: create and verify port allocation"
        k8sApplyYAML <<'YAML'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: np-backend
  namespace: k8s-feature-test-net-np
spec:
  replicas: 1
  selector:
    matchLabels:
      app: np-backend
  template:
    metadata:
      labels:
        app: np-backend
    spec:
      containers:
      - name: main
        image: docker.io/library/busybox:1.36.1
        command: ["sleep", "3600"]
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: np-svc
  namespace: k8s-feature-test-net-np
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: np-backend
YAML
        k8sWaitForPodReady "$NP_NS" "app=np-backend" 120

        nodeport=$(k8sKubectl get svc np-svc -n "$NP_NS" \
            -o jsonpath='{.spec.ports[0].nodePort}' 2>&1)
        rlLogInfo "NodePort allocated: $nodeport"

        # Verify nodePort is in valid range 30000-32767
        if [ "$nodeport" -ge 30000 ] && [ "$nodeport" -le 32767 ]; then
            rlPass "NodePort $nodeport is in valid range (30000-32767)"
        else
            rlFail "NodePort $nodeport is outside valid range"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$NP_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
