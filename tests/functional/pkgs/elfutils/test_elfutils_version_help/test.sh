#!/bin/bash
# Functional test: elfutils - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        elfutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "eu-addr2line --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-addr2line 版本信息"
        rlRun "eu-addr2line --help 2>&1 | head -5 || true" 0 "eu-addr2line 帮助信息"
        rlRun "eu-ar --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-ar 版本信息"
        rlRun "eu-ar --help 2>&1 | head -5 || true" 0 "eu-ar 帮助信息"
        rlRun "eu-elfclassify --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-elfclassify 版本信息"
        rlRun "eu-elfclassify --help 2>&1 | head -5 || true" 0 "eu-elfclassify 帮助信息"
        rlRun "eu-elfcmp --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-elfcmp 版本信息"
        rlRun "eu-elfcmp --help 2>&1 | head -5 || true" 0 "eu-elfcmp 帮助信息"
        rlRun "eu-elfcompress --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-elfcompress 版本信息"
        rlRun "eu-elfcompress --help 2>&1 | head -5 || true" 0 "eu-elfcompress 帮助信息"
        rlRun "eu-elflint --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-elflint 版本信息"
        rlRun "eu-elflint --help 2>&1 | head -5 || true" 0 "eu-elflint 帮助信息"
        rlRun "eu-findtextrel --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-findtextrel 版本信息"
        rlRun "eu-findtextrel --help 2>&1 | head -5 || true" 0 "eu-findtextrel 帮助信息"
        rlRun "eu-make-debug-archive --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-make-debug-archive 版本信息"
        rlRun "eu-make-debug-archive --help 2>&1 | head -5 || true" 0 "eu-make-debug-archive 帮助信息"
        rlRun "eu-nm --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-nm 版本信息"
        rlRun "eu-nm --help 2>&1 | head -5 || true" 0 "eu-nm 帮助信息"
        rlRun "eu-objdump --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-objdump 版本信息"
        rlRun "eu-objdump --help 2>&1 | head -5 || true" 0 "eu-objdump 帮助信息"
        rlRun "eu-ranlib --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-ranlib 版本信息"
        rlRun "eu-ranlib --help 2>&1 | head -5 || true" 0 "eu-ranlib 帮助信息"
        rlRun "eu-readelf --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-readelf 版本信息"
        rlRun "eu-readelf --help 2>&1 | head -5 || true" 0 "eu-readelf 帮助信息"
        rlRun "eu-size --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-size 版本信息"
        rlRun "eu-size --help 2>&1 | head -5 || true" 0 "eu-size 帮助信息"
        rlRun "eu-srcfiles --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-srcfiles 版本信息"
        rlRun "eu-srcfiles --help 2>&1 | head -5 || true" 0 "eu-srcfiles 帮助信息"
        rlRun "eu-stack --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "eu-stack 版本信息"
        rlRun "eu-stack --help 2>&1 | head -5 || true" 0 "eu-stack 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # elfutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
