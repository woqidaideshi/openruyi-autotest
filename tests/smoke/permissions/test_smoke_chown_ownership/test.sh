#!/bin/bash
# Smoke test: permissions - chown 设置所有者
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokePermissionsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "touch own.txt" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "chown 设置所有者"
        rlRun 'chown $(whoami) own.txt' 0 "chown 设置所有者"
        rlRun 'test -O own.txt' 0 "文件属于当前用户"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd