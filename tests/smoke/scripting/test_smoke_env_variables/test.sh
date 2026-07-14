#!/bin/bash

# Smoke test: scripting - env listexportenvironment variables

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeScriptingSetup



    rlPhaseEnd



    rlPhaseStartTest "env listexportenvironment variables"

    rlRun 'env | head -5' 0 "env listexportenvironment variables"

    rlRun 'echo $PATH | grep /bin' 0 "\$PATH contains /bin"

    rlRun 'echo $SHELL' 0 "\$SHELL defaultshell"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd