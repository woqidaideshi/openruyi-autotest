#!/bin/bash
# Smoke test: archive - tar 创建归档
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeArchiveSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir src" 0 "创建源目录"
        rlRun "echo a > src/a.txt" 0 "创建源文件 a"
        rlRun "echo b > src/b.txt" 0 "创建源文件 b"
        rlRun "mkdir extract" 0 "创建解压目录"

    rlPhaseEnd

    rlPhaseStartTest "tar 创建归档"
        rlRun 'tar -cf test.tar src' 0 "tar 创建归档"
        rlRun 'test -f test.tar' 0 "tar 文件已创建"
        rlRun 'tar -tf test.tar | grep a.txt' 0 "tar -t 列出内容"
        rlRun "cd extract" 0 "进入解压目录"
        rlRun 'tar -xf ../test.tar' 0 "tar -x 解压"
        rlRun 'test -f src/a.txt' 0 "解压文件存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd