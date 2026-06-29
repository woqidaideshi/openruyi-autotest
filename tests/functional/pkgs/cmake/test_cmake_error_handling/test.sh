#!/bin/bash
# Functional test: cmake - Error-handling
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        cmakeSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Error-handling"
        rlRun "cmake /nonexistent/path 2>&1" 1 "cmake 对不存在的路径应报错"
        rlRun "cmake --build /nonexistent/build 2>&1" 1 "cmake --build 对不存在目录应报错"
        rlRun "cmake -E true" 0 "cmake -E true 返回成功"
        rlRun "cmake -E false 2>&1" 1 "cmake -E false 返回失败"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # cmake 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
