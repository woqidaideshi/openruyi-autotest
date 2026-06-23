#!/bin/bash
# Smoke test: filesystem - file type detect
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'text' > t.txt" 0 "创建测试文件"
    rlPhaseEnd

    rlPhaseStartTest "file 检测文件类型"
        rlRun "file t.txt | grep -i text" 0 "file 识别文本文件"
        rlRun "file /bin/sh | grep -i elf" 0 "file 识别 ELF 二进制"
        rlRun "file /" 0 "file 识别目录"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd