#!/bin/bash
# Functional test: openssl - ��������
# Beakerlib-based test with lifecycle management
# Shared suite setup/cleanup via ../lib.sh (install once, uninstall once)

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        opensslSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
    rlPhaseEnd

    rlPhaseStartTest "��������"
        rlRun "openssl version" 0 "�鿴�汾"
        rlRun "openssl help 2>&1 | head -20" 0 "�鿴����"
        rlRun "openssl list -standard-commands 2>&1 | head -10" 0 "�г���׼����"
        rlRun "openssl list -cipher-commands 2>&1 | head -10" 0 "�г���������"
        rlRun "openssl list -digest-commands 2>&1 | head -10" 0 "�г�ժҪ����"
    rlPhaseEnd


    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
        # openssl 软件包由 lib.sh 的引用计数机制自动管理卸载
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd
