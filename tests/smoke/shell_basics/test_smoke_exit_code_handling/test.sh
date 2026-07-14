#!/bin/bash

# Smoke test: shell_basics - && logical AND

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeShellBasicsSetup

    rlRun "true; test $? -eq 0" 0 "Prepare environment"

    rlRun "false; test $? -ne 0" 0 "Prepare environment"



    rlPhaseEnd



    rlPhaseStartTest "&& logical AND"

    rlRun 'true && echo yes' 0 "&& logical AND"

    rlRun 'false || echo no' 0 "|| or"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd