#!/bin/bash
# Functional test: diffutils - 错误处理
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        diffutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "错误处理"
        rlRun "cmp --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "���� cmp ��Ч错误处理����"
        rlRun "diff --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "���� diff ��Ч错误处理����"
        rlRun "diff3 --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "���� diff3 ��Ч错误处理����"
        rlRun "sdiff --invalid-flag-xyz 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "���� sdiff ��Ч错误处理����"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # diffutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
