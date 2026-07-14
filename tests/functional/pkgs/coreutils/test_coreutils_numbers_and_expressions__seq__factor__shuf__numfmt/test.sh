#!/bin/bash
# Functional test: coreutils - Numbers-and-expressions--seq--factor--shuf--numfmt
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "Environment setup"
    coreutilsSetup
    TmpDir=$(mktemp -d)
    rlRun "cd $TmpDir" 0 "Enter temporary test directory"
    rlPhaseEnd

    rlPhaseStartTest "Numbers-and-expressions--seq--factor--shuf--numfmt"
    rlRun "seq 1 5" 0 "seq generate sequence"
    rlRun "test $(seq 1 5 | wc -l) -eq 5" 0 "seq: 5 numbers"
    rlRun "seq -s, 1 3" 0 "seq -s custom separator"
    rlRun "factor 42" 0 "factor prime factorization"
    rlRun "factor 97" 0 "factor prime number"
    rlRun "echo -e \"a\nb\nc\nd\ne\" | shuf" 0 "shuf randomize lines"
    rlRun "test $(echo -e \"a\nb\nc\nd\ne\" | shuf | wc -l) -eq 5" 0 "shuf: same line count"
    rlRun "echo 1234567 | numfmt --to=si" 0 "numfmt to SI units"
    rlRun "echo 1M | numfmt --from=si" 0 "numfmt from SI units"
    rlRun "echo 1048576 | numfmt --to=iec" 0 "numfmt to IEC units"
    rlRun "expr 1 + 1" 0 "expr basic arithmetic"
    rlRun "test $(expr 3 \* 4) -eq 12" 0 "expr multiplication"
    rlRun "expr length \"hello\"" 0 "expr string length"
    rlPhaseEnd


    rlPhaseStartCleanup "Clean up test environment"
    rlRun "cd /" 0 "Leave test directory"
    if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
    rlRun "rm -rf $TmpDir" 0 "Clean up temporary test directory"
    fi
    # coreutils Package managed by lib.sh 's reference counting auto-uninstall
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
