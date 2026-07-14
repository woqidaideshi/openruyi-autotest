#!/bin/bash

# Smoke test: archive - tar -czf createtar.gz

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

 rlPhaseStartSetup "Environment setup"

 smokeArchiveSetup

 TmpDir=$(mktemp -d)

 rlRun "cd $TmpDir" 0 "Enter temporary test directory"

 rlRun "mkdir pkg" 0 "createsoftdirectory"

 rlRun "echo test > pkg/README" 0 "Create test file"



 rlPhaseEnd



 rlPhaseStartTest "tar -czf createtar.gz"

 rlRun 'tar -czf pkg.tar.gz pkg' 0 "tar -czf createtar.gz"

 rlRun 'test -f pkg.tar.gz' 0 "tar.gz file exists"

 rlRun "mkdir out" 0 "createdecompressdirectory"

 rlRun "cd out" 0 "enterdecompressdirectory"

 rlRun 'tar -xzf../pkg.tar.gz' 0 "tar -xzf decompresstar.gz"

 rlRun 'test -f pkg/README' 0 "decompresscontentexists"

 rlPhaseEnd



 rlPhaseStartCleanup "Clean up test environment"

 rlRun "cd /" 0 "Leave test directory"

 if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

 rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

 fi

 rlPhaseEnd



 rlJournalPrintText

rlJournalEnd