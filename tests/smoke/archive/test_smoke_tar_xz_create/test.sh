#!/bin/bash
# Smoke test: archive - tar -cJf 创建tar.xz
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeArchiveSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir data" 0 "创建数据目录"
        rlRun "echo content > data/file.txt" 0 "创建测试文件"

    rlPhaseEnd

    rlPhaseStartTest "tar -cJf 创建tar.xz"
        rlRun 'tar -cJf data.tar.xz data' 0 "tar -cJf 创建tar.xz"
        rlRun 'test -f data.tar.xz' 0 "tar.xz 文件存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd