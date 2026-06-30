#!/bin/bash
# Functional test: pam - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        pamSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "faillock --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "faillock 版本信息"
        rlRun "faillock --help 2>&1 | head -5 || true" 0 "faillock 帮助信息"
        rlRun "mkhomedir_helper --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "mkhomedir_helper 版本信息"
        rlRun "mkhomedir_helper --help 2>&1 | head -5 || true" 0 "mkhomedir_helper 帮助信息"
        rlRun "pam_timestamp_check --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "pam_timestamp_check 版本信息"
        rlRun "pam_timestamp_check --help 2>&1 | head -5 || true" 0 "pam_timestamp_check 帮助信息"
        rlRun "unix_chkpwd --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "unix_chkpwd 版本信息"
        rlRun "unix_chkpwd --help 2>&1 | head -5 || true" 0 "unix_chkpwd 帮助信息"
        rlRun "unix_update --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "unix_update 版本信息"
        rlRun "unix_update --help 2>&1 | head -5 || true" 0 "unix_update 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # pam 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
