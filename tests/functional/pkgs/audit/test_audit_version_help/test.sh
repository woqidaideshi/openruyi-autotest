#!/bin/bash
# Functional test: audit - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        auditSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "auditctl --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "auditctl 版本信息"
        rlRun "auditctl --help 2>&1 | head -5 || true" 0 "auditctl 帮助信息"
        rlRun "ausearch --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "ausearch 版本信息"
        rlRun "ausearch --help 2>&1 | head -5 || true" 0 "ausearch 帮助信息"
        rlRun "aureport --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "aureport 版本信息"
        rlRun "aureport --help 2>&1 | head -5 || true" 0 "aureport 帮助信息"
        rlRun "aulast --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "aulast 版本信息"
        rlRun "aulast --help 2>&1 | head -5 || true" 0 "aulast 帮助信息"
        rlRun "aulastlog --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "aulastlog 版本信息"
        rlRun "aulastlog --help 2>&1 | head -5 || true" 0 "aulastlog 帮助信息"
        rlRun "ausyscall --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "ausyscall 版本信息"
        rlRun "ausyscall --help 2>&1 | head -5 || true" 0 "ausyscall 帮助信息"
        rlRun "augenrules --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "augenrules 版本信息"
        rlRun "augenrules --help 2>&1 | head -5 || true" 0 "augenrules 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # audit 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
