#!/bin/bash
# Smoke test: system_info - hostname displayhostname
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeSystemInfoSetup

 rlPhaseEnd

 rlPhaseStartTest "hostname displayhostname"
 rlRun 'hostname' 0 "hostname displayhostname"
 rlRun 'cat /etc/hostname' 0 "hostname filereadable"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd