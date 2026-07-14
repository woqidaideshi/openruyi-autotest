#!/bin/bash

# Smoke test: text_processing - tr case conversion

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeTextProcessingSetup



    rlPhaseEnd



    rlPhaseStartTest "tr case conversion"

    rlRun 'echo "HELLO" | tr "A-Z" "a-z"' 0 "tr case conversion"

    rlRun 'echo "a b c" | tr -d " "' 0 "tr -d deletespaces"

    rlRun 'echo "a b c" | tr -s " "' 0 "tr -s compressspaces"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd