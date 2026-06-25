#!/bin/bash
# Smoke test: dev_tools - make 版本
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeDevToolsSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        cat > Makefile << 'EOF'
        hello: hello.c
        $(CC) -o hello hello.c
        EOF
        echo 'int main(){return 0;}' > hello.c

    rlPhaseEnd

    rlPhaseStartTest "make 版本"
        rlRun 'make --version' 0 "make 版本"
        rlRun 'make CC=gcc hello' 0 "make 构建"
        rlRun 'test -f hello' 0 "make 输出存在"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd