#!/bin/bash
# Functional test: grep - Fixed-strings---F
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        grepSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Fixed-strings---F"
        rlRun "grep -F \"Special chars: *.[]^$\" test1.txt" 0 "Fixed string with special chars"
        rlRun "grep -F \"*.[]\" test1.txt" 0 "Fixed string: no regex meta-char interpretation"
        rlRun "fgrep \"Special chars\" test1.txt" 0 "fgrep equivalent to grep -F"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # grep 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
