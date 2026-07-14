#!/bin/bash
# Smoke test: process - nproc CPU corecount
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
 rlPhaseStartSetup "Environment setup"
 smokeProcessSetup

 rlPhaseEnd

 rlPhaseStartTest "nproc CPU corecount"
 rlRun 'nproc' 0 "nproc CPU corecount"
 rlRun 'nproc --all' 0 "nproc --all allhandle"
 rlPhaseEnd

 rlPhaseStartCleanup "Clean up test environment"

 rlPhaseEnd

 rlJournalPrintText
rlJournalEnd