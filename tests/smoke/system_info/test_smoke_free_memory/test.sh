#!/bin/bash

# Smoke test: system_info - free memoryuse

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeSystemInfoSetup



    rlPhaseEnd



    rlPhaseStartTest "free memoryuse"

    rlRun 'free' 0 "free memoryuse"

    rlRun 'free -h' 0 "free -h human-readable"

    rlRun 'free -t' 0 "free -t lines"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd