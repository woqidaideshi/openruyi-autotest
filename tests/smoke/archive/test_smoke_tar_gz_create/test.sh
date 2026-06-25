#!/bin/bash
# Smoke test: archive - tar -czf 创建tar.gz
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeArchiveSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "mkdir pkg" 0 "创建软件包目录"
        rlRun "echo test > pkg/README" 0 "创建测试文件"

    rlPhaseEnd

    rlPhaseStartTest "tar -czf 创建tar.gz"
        rlRun 'tar -czf pkg.tar.gz pkg' 0 "tar -czf 创建tar.gz"
        rlRun 'test -f pkg.tar.gz' 0 "tar.gz 文件存在"
        rlRun "mkdir out" 0 "创建解压目录"
        rlRun "cd out" 0 "进入解压目录"
        rlRun 'tar -xzf ../pkg.tar.gz' 0 "tar -xzf 解压tar.gz"
        rlRun 'test -f pkg/README' 0 "解压内容存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd