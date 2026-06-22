#!/bin/bash
# Smoke test: permissions - chmod -R 递归
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePermissionsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir -p sub/nested; touch sub/nested/file.txt" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "chmod -R 递归"
        rlRun 'chmod -R 755 sub' 0 "chmod -R 递归"
        rlRun 'test -r sub/nested/file.txt' 0 "递归后文件可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd