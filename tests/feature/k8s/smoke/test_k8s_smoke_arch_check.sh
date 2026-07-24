#!/bin/bash
# ============================================================
# K8s Smoke: Verify all cluster nodes report riscv64 architecture.
# Equivalent to Sonobuoy RISC-V smoke plugin arch check.
# ============================================================

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
        k8sSetup
    rlPhaseEnd

    rlPhaseStartTest "Verify all nodes architecture is riscv64"
        arch_output=$(k8sKubectl get nodes -o jsonpath='{.items[*].status.nodeInfo.architecture}' 2>&1)
        rlRun "echo '$arch_output'" 0 "List node architectures"

        non_riscv=$(echo "$arch_output" | tr ' ' '\n' | grep -cv "riscv64" || true)
        if [ "$non_riscv" -eq 0 ]; then
            rlPass "All nodes report architecture = riscv64"
        else
            rlFail "Found $non_riscv node(s) with non-riscv64 architecture: $arch_output"
        fi
    rlPhaseEnd

    rlPhaseStartCleanup "Cleanup"
        # No resources created, nothing to clean
    rlPhaseEnd
rlJournalEnd
