#!/bin/bash
# Functional test: openssl - ��ϣ����
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

    rlPhaseStartTest "��ϣ����"
        rlRun "TmpDir=$(mktemp -d)" 0 "������ʱĿ¼"
        rlRun "cd $TmpDir" 0 "�������Ŀ¼"
        rlRun "echo \"test data\" > testfile" 0 "���������ļ�"
        rlRun "openssl dgst -md5 testfile" 0 "MD5 ժҪ"
        rlRun "openssl dgst -sha256 testfile" 0 "SHA256 ժҪ"
        rlRun "openssl dgst -sha512 testfile" 0 "SHA512 ժҪ"
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
