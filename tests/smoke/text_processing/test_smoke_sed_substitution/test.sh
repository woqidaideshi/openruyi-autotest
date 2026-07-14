#!/bin/bash

# Smoke test: text_processing - sed replace

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeTextProcessingSetup

    rlRun "echo "hello world" | sed's/world/universe/' | grep universe" 0 "Prepare environment"



    rlPhaseEnd



    rlPhaseStartTest "sed replace"

    rlRun 'echo "hello" | sed "s/h/H/"' 0 "sed replace"

    rlRun 'echo "a b c" | sed "s/ /,/g"' 0 "sed replace"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd