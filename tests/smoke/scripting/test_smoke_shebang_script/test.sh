#!/bin/bash
# Smoke test: scripting - shebang 脚本执行
# Beakerlib-based test with lifecycle management

. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        smokeScriptingSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时测试目录"
        rlRun "cat > myscript.sh << 'EOF'" 0 "创建测试数据"
        rlRun "echo "script ran successfully"" 0 "创建测试数据"
        rlRun "EOF" 0 "创建测试数据"
        rlRun "chmod +x myscript.sh" 0 "创建测试数据"

    rlPhaseEnd

    rlPhaseStartTest "shebang 脚本执行"
        rlRun './myscript.sh' 0 "shebang 脚本执行"
    rlPhaseEnd

    rlPhaseStartCleanup "清理测试环境"
        rlRun "cd /" 0 "离开测试目录"
        if [ -n "$TmpDir" ] && [ -d "$TmpDir" ]; then
            rlRun "rm -rf $TmpDir" 0 "清理临时测试目录"
        fi
    rlPhaseEnd

    rlJournalPrintText
rlJournalEnd