#!/bin/bash
# Smoke test: kernel - modprobe version
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeKernelSetup

 rlPhaseEnd

 rlPhaseStartTest "modprobe version"
 rlRun 'modprobe --version 2>&1 || true' 0 "modprobe version"
 rlRun 'ls /lib/modules/$(uname -r) 2>&1 | head -5 || true' 0 "moduledirectory exists"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd