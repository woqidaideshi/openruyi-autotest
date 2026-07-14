#!/bin/bash

# Smoke test: text_processing - wc -l countlinescount

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeTextProcessingSetup



    rlPhaseEnd



    rlPhaseStartTest "wc -l countlinescount"

    rlRun 'wc -l /etc/os-release' 0 "wc -l countlinescount"

    rlRun 'wc -c /etc/hostname' 0 "wc -c countcount"

    rlRun 'wc -w /etc/os-release' 0 "wc -w countsinglecount"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd