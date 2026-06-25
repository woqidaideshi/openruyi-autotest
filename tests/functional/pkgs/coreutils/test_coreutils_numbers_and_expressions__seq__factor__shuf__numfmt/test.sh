#!/bin/bash
# Functional test: coreutils - Numbers-and-expressions--seq--factor--shuf--numfmt
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
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


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
