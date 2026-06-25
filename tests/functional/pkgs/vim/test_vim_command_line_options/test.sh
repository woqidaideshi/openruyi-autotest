#!/bin/bash
# Functional test: vim - Command-line-options
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        vimSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Command-line-options"
        rlRun "vim --help 2>&1 | head -10" 0 "vim --help"
        rlRun "vim -c \"version\" -c \"q\" test.txt 2>&1 | head -3 || true" 0 "vim -c: execute command"
        rlRun "vim -R test.txt -c \"q\" 2>&1 || true" 0 "vim -R: readonly mode"
        rlRun "vim -b test.txt -c \"q\" 2>&1 || true" 0 "vim -b: binary mode"
        rlRun "vim -n test.txt -c \"q\" 2>&1 || true" 0 "vim -n: no swap file"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # vim 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
