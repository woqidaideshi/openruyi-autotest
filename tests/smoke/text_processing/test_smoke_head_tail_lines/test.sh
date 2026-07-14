#!/bin/bash

# Smoke test: text_processing - head before3lines

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeTextProcessingSetup



 rlPhaseEnd



 rlPhaseStartTest "head before3lines"

 rlRun 'head -3 /etc/os-release' 0 "head before3lines"

 rlRun 'tail -3 /etc/os-release' 0 "tail post3lines"

 rlRun 'head -c 10 /etc/hostname' 0 "head before10"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd