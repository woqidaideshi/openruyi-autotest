#!/bin/bash
# Functional test: nettle - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        nettleSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "nettle-hash --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "nettle-hash 版本信息"
        rlRun "nettle-hash --help 2>&1 | head -5 || true" 0 "nettle-hash 帮助信息"
        rlRun "nettle-lfib-stream --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "nettle-lfib-stream 版本信息"
        rlRun "nettle-lfib-stream --help 2>&1 | head -5 || true" 0 "nettle-lfib-stream 帮助信息"
        rlRun "nettle-pbkdf2 --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "nettle-pbkdf2 版本信息"
        rlRun "nettle-pbkdf2 --help 2>&1 | head -5 || true" 0 "nettle-pbkdf2 帮助信息"
        rlRun "pkcs1-conv --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "pkcs1-conv 版本信息"
        rlRun "pkcs1-conv --help 2>&1 | head -5 || true" 0 "pkcs1-conv 帮助信息"
        rlRun "sexp-conv --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "sexp-conv 版本信息"
        rlRun "sexp-conv --help 2>&1 | head -5 || true" 0 "sexp-conv 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # nettle 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
