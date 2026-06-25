#!/bin/bash
# Functional test: coreutils - Directory--file-creation--temp-files--mkdir--touch
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        coreutilsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "Directory--file-creation--temp-files--mkdir--touch"
        rlRun "mkdir -p a/b/c" 0 "mkdir -p nested directories"
        rlRun "test -d a/b/c" 0 "mkdir -p: verify nested dir"
        rlRun "mkdir -m 755 mode_dir" 0 "mkdir -m set mode"
        rlRun "touch newfile.txt" 0 "touch create file"
        rlRun "test -f newfile.txt" 0 "touch: file exists"
        rlRun "touch -t 202001010000 newfile.txt" 0 "touch -t set timestamp"
        rlRun "touch -a newfile.txt" 0 "touch -a access time only"
        rlRun "mktemp" 0 "mktemp create temp file"
        rlRun "test -f $mktemp_f" 0 "mktemp: temp file exists"
        rlRun "mktemp -d" 0 "mktemp -d create temp directory"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # coreutils 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
