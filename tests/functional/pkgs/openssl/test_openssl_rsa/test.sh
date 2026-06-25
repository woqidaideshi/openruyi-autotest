#!/bin/bash
# Functional test: openssl - RSA
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

    rlPhaseStartTest "RSA"
        rlRun "TmpDir=$(mktemp -d)" 0 "������ʱĿ¼"
        rlRun "cd $TmpDir" 0 "�������Ŀ¼"
        rlRun "openssl genrsa -out key.pem 2048" 0 "����RSA˽Կ"
        rlRun "test -f key.pem" 0 "��֤˽Կ�ļ�����"
        rlRun "openssl rsa -in key.pem -pubout -out pub.pem" 0 "��ȡ��Կ"
        rlRun "test -f pub.pem" 0 "��֤��Կ�ļ�����"
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
