#!/bin/bash
# Functional test: rpm - rpm ��ѯ
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        rpmSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "rpm ��ѯ"
rlRun() { eval "$1" 2>&1; return $?; }
        rlRun "rpm --help 2>&1 | head -10" 0 "rpm ����"
        rlRun "rpm -qa 2>&1 | head -10" 0 "�г����а�"
        rlRun "rpm -qi rpm 2>&1 | head -10" 0 "��ѯ����Ϣ"
        rlRun "rpm -ql rpm 2>&1 | head -10" 0 "�г����ļ�"
        rlRun "rpm -qc rpm 2>&1" 0 "�г������ļ�"
        rlRun "rpm -qd rpm 2>&1 | head -5" 0 "�г��ĵ�"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # rpm 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
