#!/bin/bash
# Smoke test: system_info - /proc/cpuinfo CPU info
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    smokeSystemInfoSetup

    rlPhaseEnd

    rlPhaseStartTest "/proc/cpuinfo CPU info"
    rlRun 'cat /proc/cpuinfo | head -5' 0 "/proc/cpuinfo CPU info"
    rlRun 'cat /proc/meminfo | head -5' 0 "/proc/meminfo memoryinfo"
    rlPhaseEnd

    rlPhaseStartCleanup "Clean up test environment"

    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd