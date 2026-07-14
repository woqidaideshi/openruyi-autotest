#!/bin/bash
# Smoke test: kernel - /proc/sys directory exists
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeKernelSetup

 rlPhaseEnd

 rlPhaseStartTest "/proc/sys directory exists"
 rlRun 'test -d /proc/sys' 0 "/proc/sys directory exists"
 rlRun 'cat /proc/sys/kernel/hostname' 0 "/proc/sys readable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd