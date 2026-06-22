#!/bin/bash
# Smoke test: filesystem - ln hardlink and symlink
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeFSSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "echo 'link test' > target.txt" 0 "创建目标文件"
    rlPhaseEnd

    rlPhaseStartTest "ln 创建硬链接和符号链接"
        rlRun "ln target.txt hardlink.txt" 0 "ln 创建硬链接"
        rlRun "ln -s target.txt symlink.txt" 0 "ln -s 创建符号链接"
        rlRun "test -f hardlink.txt" 0 "硬链接存在"
        rlRun "test -L symlink.txt" 0 "符号链接存在"
        rlRun "cat hardlink.txt" 0 "硬链接可读"
        rlRun "cat symlink.txt" 0 "符号链接可读"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd