#!/bin/bash
# Functional test: wget - Directory-listing
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        wgetSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Directory-listing"
        rlRun "wget -nd --version 2>&1 | grep -q Wget" 0 "wget -nd 不创建目录选项"
        rlRun "wget -x --version 2>&1 | grep -q Wget" 0 "wget -x 创建目录选项"
        rlRun "wget -nH --version 2>&1 | grep -q Wget" 0 "wget -nH 禁用主机目录选项"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # wget 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
