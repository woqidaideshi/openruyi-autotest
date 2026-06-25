#!/bin/bash
# Smoke test: security - umask 当前掩码
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeSecuritySetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "umask 022; touch umask_test" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "umask 当前掩码"
        rlRun 'umask' 0 "umask 当前掩码"
        rlRun 'ls -l umask_test' 0 "umask 影响新文件权限"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd