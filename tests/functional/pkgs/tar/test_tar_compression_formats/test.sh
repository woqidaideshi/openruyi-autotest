#!/bin/bash
# Functional test: tar - Compression-formats
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        tarSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Compression-formats"
        rlRun "tar -czf $TmpDir/test.tgz -C $TmpDir testdir" 0 "tar gzip 压缩"
        rlRun "tar -cJf $TmpDir/test.xz -C $TmpDir testdir" 0 "tar xz 压缩"
        rlRun "test -f $TmpDir/test.tgz" 0 "验证 tgz 文件"
        rlRun "test -f $TmpDir/test.xz" 0 "验证 xz 文件"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # tar 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
