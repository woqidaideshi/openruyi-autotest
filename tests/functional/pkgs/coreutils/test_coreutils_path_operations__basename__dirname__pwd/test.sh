#!/bin/bash
# Functional test: coreutils - Path-operations--basename--dirname--pwd
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

    rlPhaseStartTest "Path-operations--basename--dirname--pwd"
        rlRun "test \"$(basename /usr/bin/grep)\" = \"grep\"" 0 "basename extract filename"
        rlRun "test \"$(basename /path/to/file.txt .txt)\" = \"file\"" 0 "basename strip suffix"
        rlRun "test \"$(dirname /usr/bin/grep)\" = \"/usr/bin\"" 0 "dirname extract directory"
        rlRun "test \"$(dirname /path/to/file.txt)\" = \"/path/to\"" 0 "dirname path extraction"
        rlRun "pwd" 0 "pwd print working directory"
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
