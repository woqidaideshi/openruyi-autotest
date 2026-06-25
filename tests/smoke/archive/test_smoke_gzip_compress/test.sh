#!/bin/bash
# Smoke test: archive - gzip 压缩
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeArchiveSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "dd if=/dev/zero of=big.txt bs=1k count=10 2>/dev/null" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "gzip 压缩"
        rlRun 'gzip big.txt' 0 "gzip 压缩"
        rlRun 'test -f big.txt.gz' 0 "压缩文件存在"
        rlRun 'gunzip big.txt.gz' 0 "gunzip 解压"
        rlRun 'test -f big.txt' 0 "解压文件恢复"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd