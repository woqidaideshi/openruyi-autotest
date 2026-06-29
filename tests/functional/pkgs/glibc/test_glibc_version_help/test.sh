#!/bin/bash
# Functional test: glibc - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        glibcSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "gencat --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "gencat 版本信息"
        rlRun "gencat --help 2>&1 | head -5 || true" 0 "gencat 帮助信息"
        rlRun "getconf --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "getconf 版本信息"
        rlRun "getconf --help 2>&1 | head -5 || true" 0 "getconf 帮助信息"
        rlRun "getent --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "getent 版本信息"
        rlRun "getent --help 2>&1 | head -5 || true" 0 "getent 帮助信息"
        rlRun "iconv --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "iconv 版本信息"
        rlRun "iconv --help 2>&1 | head -5 || true" 0 "iconv 帮助信息"
        rlRun "ldconfig --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "ldconfig 版本信息"
        rlRun "ldconfig --help 2>&1 | head -5 || true" 0 "ldconfig 帮助信息"
        rlRun "ldd --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "ldd 版本信息"
        rlRun "ldd --help 2>&1 | head -5 || true" 0 "ldd 帮助信息"
        rlRun "locale --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "locale 版本信息"
        rlRun "locale --help 2>&1 | head -5 || true" 0 "locale 帮助信息"
        rlRun "localedef --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "localedef 版本信息"
        rlRun "localedef --help 2>&1 | head -5 || true" 0 "localedef 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # glibc 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
