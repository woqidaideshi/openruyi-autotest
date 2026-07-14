#!/bin/bash

# Smoke test: shell_basics - export variable

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeShellBasicsSetup

    rlRun "X=hello; test "$X" = "hello"" 0 "Prepare environment"



    rlPhaseEnd



    rlPhaseStartTest "export variable"

    rlRun 'export Y=world' 0 "export variable"

    rlRun 'echo $HOME | grep /' 0 "\$HOME environment variables"

    rlRun 'echo ${#HOME}' 0 "\${#VAR} "

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"



    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd