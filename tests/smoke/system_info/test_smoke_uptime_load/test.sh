#!/bin/bash
# Smoke test: system_info - /proc/uptime runtime
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSystemInfoSetup

 rlPhaseEnd

 rlPhaseStartTest "/proc/uptime runtime"
 rlRun 'cat /proc/uptime' 0 "/proc/uptime runtime"
 rlRun 'cat /proc/loadavg' 0 "/proc/loadavg systemload"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd