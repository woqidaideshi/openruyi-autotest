#!/bin/bash
# Smoke test: filesystem - touch create file
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "touch 创建空文件"
        rlRun "touch empty.txt" 0 "touch 创建空文件"
        rlRun "test -f empty.txt" 0 "空文件存在"
        rlRun "test ! -s empty.txt" 0 "文件大小为0"
        rlRun "touch -t 202401010000 ref.txt" 0 "touch 设置时间戳"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd