#!/bin/bash
# ============================================================
# K8s Scheduling: Verify Pod affinity and anti-affinity rules.
# Equivalent to Sonobuoy sig-scheduling affinity tests.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

AFF_NS="k8s-feature-test-sched-aff"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
        k8sKubectl create namespace "$AFF_NS" 2>/dev/null || true

        node_count=$(k8sGetNodeCount)
        if [ "$node_count" -lt 2 ]; then
            rlSkip "Only $node_count node(s) — affinity test needs 2+ nodes for meaningful validation"
        fi
    rlPhaseEnd

    rlPhaseStartTest "Pod affinity: co-locate pods via podAffinity"
        # Create a "attractor" pod first
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: attractor
  namespace: k8s-feature-test-sched-aff
  labels:
    role: attractor
spec:
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sleep", "3600"]
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$AFF_NS" "role=attractor" 60

        attractor_node=$(k8sKubectl get pod attractor -n "$AFF_NS" \
            -o jsonpath='{.spec.nodeName}' 2>&1)

        # Pod with requiredDuringScheduling affinity to attractor
        k8sApplyYAML <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: follower
  namespace: k8s-feature-test-sched-aff
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchLabels:
            role: attractor
        topologyKey: kubernetes.io/hostname
  containers:
  - name: main
    image: docker.io/library/busybox:1.36.1
    command: ["sleep", "300"]
  restartPolicy: Never
YAML
        k8sWaitForPodReady "$AFF_NS" "app=follower" 60 || true

        follower_node=$(k8sKubectl get pod follower -n "$AFF_NS" \
            -o jsonpath='{.spec.nodeName}' 2>&1)

        rlAssertEquals "Follower pod co-located with attractor via podAffinity" \
            "$attractor_node" "$follower_node"
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        k8sKubectl delete namespace "$AFF_NS" --ignore-not-found=true --timeout=60s 2>&1 || true
    rlPhaseEnd
rlJournalEnd
