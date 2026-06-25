#!/bin/bash
# Functional test: openssl - �ӽ���
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

    rlPhaseStartTest "�ӽ���"
        rlRun "TmpDir=$(mktemp -d)" 0 "������ʱĿ¼"
        rlRun "cd $TmpDir" 0 "�������Ŀ¼"
        rlRun "echo \"secret message\" > plain.txt" 0 "���������ļ�"
        rlRun "openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out encrypted.bin -pass pass:test123" 0 "AES����"
        rlRun "test -f encrypted.bin" 0 "��֤�����ļ�����"
        rlRun "openssl enc -aes-256-cbc -d -pbkdf2 -in encrypted.bin -out decrypted.txt -pass pass:test123" 0 "AES����"
        rlRun "diff plain.txt decrypted.txt" 0 "��֤���ܽ��һ��"
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
