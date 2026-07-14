#!/bin/bash

# Smoke test: system_info - du -sh directorysize

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeSystemInfoSetup



 rlPhaseEnd



 rlPhaseStartTest "du -sh directorysize"

 rlRun 'du -sh /etc' 0 "du -sh directorysize"

 rlRun 'du -h /bin | head -5' 0 "du listexportfilesize"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"



 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd