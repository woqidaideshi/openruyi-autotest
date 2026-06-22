#!/bin/bash
# Functional test: coreutils - Special-utilities--stty--pathchk--tsort--ptx--dirc
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

    rlPhaseStartTest "Special-utilities--stty--pathchk--tsort--ptx--dirc"
        rlRun "stty -a" 0 "stty -a show all terminal settings"
        rlRun "pathchk /tmp" 0 "pathchk validate path"
        rlRun "pathchk -p /tmp" 0 "pathchk -p POSIX check"
        rlRun "echo -e \"a b\nb c\" | tsort" 0 "tsort topological sort"
        rlRun "ptx fruits.txt" 0 "ptx permuted index"
        rlRun "dircolors -p" 0 "dircolors -p print database"
        rlRun "dircolors" 0 "dircolors output LS_COLORS"
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
