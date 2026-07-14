#!/bin/bash

# Smoke test: archive - tar createarchive

# Beakerlib-based test with lifecycle management



. /usr/share/beakerlib/beakerlib.sh || exit 1

. "$(dirname "$0")/../lib.sh"



rlJournalStart

    rlPhaseStartSetup "Environment setup"

    smokeArchiveSetup

    TmpDir=$(mktemp -d)

    rlRun "cd $TmpDir" 0 "Enter temporary test directory"

    rlRun "mkdir src" 0 "createsourcedirectory"

    rlRun "echo a > src/a.txt" 0 "createsource file a"

    rlRun "echo b > src/b.txt" 0 "createsource file b"

    rlRun "mkdir extract" 0 "createdecompressdirectory"



    rlPhaseEnd



    rlPhaseStartTest "tar createarchive"

    rlRun 'tar -cf test.tar src' 0 "tar createarchive"

    rlRun 'test -f test.tar' 0 "tar filealreadycreate"

    rlRun 'tar -tf test.tar | grep a.txt' 0 "tar -t listexportcontent"

    rlRun "cd extract" 0 "enterdecompressdirectory"

    rlRun 'tar -xf../test.tar' 0 "tar -x decompress"

    rlRun 'test -f src/a.txt' 0 "decompressfile exists"

    rlPhaseEnd



    rlPhaseStartCleanup "Clean up test environment"

    rlRun "cd /" 0 "Leave test directory"

    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then

    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"

    fi

    rlPhaseEnd



    rlJournalPrintText

rlJournalEnd