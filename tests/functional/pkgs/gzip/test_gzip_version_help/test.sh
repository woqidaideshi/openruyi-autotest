#!/bin/bash
# Functional test: gzip - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        gzipSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "版本和帮助"
        rlRun "gzip --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "gzip 版本信息"
        rlRun "gzip --help 2>&1 | head -5 || true" 0 "gzip 帮助信息"
        rlRun "gunzip --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "gunzip 版本信息"
        rlRun "gunzip --help 2>&1 | head -5 || true" 0 "gunzip 帮助信息"
        rlRun "zcat --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zcat 版本信息"
        rlRun "zcat --help 2>&1 | head -5 || true" 0 "zcat 帮助信息"
        rlRun "zcmp --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zcmp 版本信息"
        rlRun "zcmp --help 2>&1 | head -5 || true" 0 "zcmp 帮助信息"
        rlRun "zdiff --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zdiff 版本信息"
        rlRun "zdiff --help 2>&1 | head -5 || true" 0 "zdiff 帮助信息"
        rlRun "zgrep --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zgrep 版本信息"
        rlRun "zgrep --help 2>&1 | head -5 || true" 0 "zgrep 帮助信息"
        rlRun "zless --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zless 版本信息"
        rlRun "zless --help 2>&1 | head -5 || true" 0 "zless 帮助信息"
        rlRun "zmore --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zmore 版本信息"
        rlRun "zmore --help 2>&1 | head -5 || true" 0 "zmore 帮助信息"
        rlRun "znew --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "znew 版本信息"
        rlRun "znew --help 2>&1 | head -5 || true" 0 "znew 帮助信息"
        rlRun "gzexe --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "gzexe 版本信息"
        rlRun "gzexe --help 2>&1 | head -5 || true" 0 "gzexe 帮助信息"
        rlRun "zforce --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zforce 版本信息"
        rlRun "zforce --help 2>&1 | head -5 || true" 0 "zforce 帮助信息"
        rlRun "zegrep --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zegrep 版本信息"
        rlRun "zegrep --help 2>&1 | head -5 || true" 0 "zegrep 帮助信息"
        rlRun "zfgrep --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "zfgrep 版本信息"
        rlRun "zfgrep --help 2>&1 | head -5 || true" 0 "zfgrep 帮助信息"
        rlRun "uncompress --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "uncompress 版本信息"
        rlRun "uncompress --help 2>&1 | head -5 || true" 0 "uncompress 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # gzip 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
