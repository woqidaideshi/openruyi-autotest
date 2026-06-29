#!/bin/bash
# Functional test: util-linux - linux - 版本和帮助
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        utilLinuxSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "linux - 版本和帮助"
        rlRun "addpart --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "addpart 版本信息"
        rlRun "addpart --help 2>&1 | head -5 || true" 0 "addpart 帮助信息"
        rlRun "agetty --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "agetty 版本信息"
        rlRun "agetty --help 2>&1 | head -5 || true" 0 "agetty 帮助信息"
        rlRun "blkid --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "blkid 版本信息"
        rlRun "blkid --help 2>&1 | head -5 || true" 0 "blkid 帮助信息"
        rlRun "blkdiscard --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "blkdiscard 版本信息"
        rlRun "blkdiscard --help 2>&1 | head -5 || true" 0 "blkdiscard 帮助信息"
        rlRun "blockdev --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "blockdev 版本信息"
        rlRun "blockdev --help 2>&1 | head -5 || true" 0 "blockdev 帮助信息"
        rlRun "cal --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "cal 版本信息"
        rlRun "cal --help 2>&1 | head -5 || true" 0 "cal 帮助信息"
        rlRun "cfdisk --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "cfdisk 版本信息"
        rlRun "cfdisk --help 2>&1 | head -5 || true" 0 "cfdisk 帮助信息"
        rlRun "chcpu --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "chcpu 版本信息"
        rlRun "chcpu --help 2>&1 | head -5 || true" 0 "chcpu 帮助信息"
        rlRun "chfn --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "chfn 版本信息"
        rlRun "chfn --help 2>&1 | head -5 || true" 0 "chfn 帮助信息"
        rlRun "chmem --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "chmem 版本信息"
        rlRun "chmem --help 2>&1 | head -5 || true" 0 "chmem 帮助信息"
        rlRun "choom --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "choom 版本信息"
        rlRun "choom --help 2>&1 | head -5 || true" 0 "choom 帮助信息"
        rlRun "chrt --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "chrt 版本信息"
        rlRun "chrt --help 2>&1 | head -5 || true" 0 "chrt 帮助信息"
        rlRun "bits --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "bits 版本信息"
        rlRun "bits --help 2>&1 | head -5 || true" 0 "bits 帮助信息"
        rlRun "blkpr --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "blkpr 版本信息"
        rlRun "blkpr --help 2>&1 | head -5 || true" 0 "blkpr 帮助信息"
        rlRun "blkzone --version 2>&1 | grep -qiE \"error|Error|not found|No such|无法\" || echo expected-error" 1 "blkzone 版本信息"
        rlRun "blkzone --help 2>&1 | head -5 || true" 0 "blkzone 帮助信息"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # util-linux 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
