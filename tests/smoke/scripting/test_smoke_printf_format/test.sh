#!/bin/bash

# Smoke test: scripting - printf basic output

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeScriptingSetup



 rlPhaseEnd



 rlPhaseStartTest "printf basic output"

 rlRun 'printf "hello"' 0 "printf basic output"

 rlRun 'printf "%d\n" 42' 0 "printf format-izenumber"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd