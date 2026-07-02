#!/bin/bash
# Performance: iozone - 安装与可用性验证
. /usr/share/beakerlib/beakerlib.sh || exit 1
. "$(dirname "$0")/../lib.sh"

rlJournalStart
    rlPhaseStartSetup "环境准备"
        iozoneSetup
        TmpDir=$(mktemp -d)
        rlRun "cd $TmpDir" 0 "进入临时目录"
    rlPhaseEnd

    rlPhaseStartTest "安装验证"
        rlRun "which iozone" 0 "iozone 命令可用"
        rlRun "file $(which iozone) | grep -i elf" 0 "ELF 可执行文件"
        # 版本信息
        iozone -v 2>&1 | tee /tmp/iozone_version.txt
        grep -qi "iozone\|version" /tmp/iozone_version.txt && rlPass "版本信息正常"
        rlRun "cat /tmp/iozone_version.txt" 0 "版本详情"
    rlPhaseEnd

    rlPhaseStartTest "帮助信息"
        iozone -h 2>&1 | tee /tmp/iozone_help.txt
        # 验证关键参数文档化
        grep -q '\-a' /tmp/iozone_help.txt && rlPass "-a (auto mode) 文档化"
        grep -q '\-s' /tmp/iozone_help.txt && rlPass "-s (file size) 文档化"
        grep -q '\-r' /tmp/iozone_help.txt && rlPass "-r (record size) 文档化"
        grep -q '\-I' /tmp/iozone_help.txt && rlPass "-I (direct I/O) 文档化"
    rlPhaseEnd

    rlPhaseStartTest "最小功能验证"
        # 用极小文件快速验证基本运行
        rlRun "iozone -s 1m -r 4k -i 0 -f $TmpDir/test_iozone.dat 2>&1 | tee /tmp/iozone_mini.txt" 0 "最小文件测试"
        # 输出应包含 kB reclen write rewrite 等表头
        grep -q "kB\|reclen\|write" /tmp/iozone_mini.txt && rlPass "输出包含标准表头"
        # 应有数据行
        grep -qE '^\s+[0-9]+\s+[0-9]+' /tmp/iozone_mini.txt && rlPass "输出包含数据行"

        echo "=== IOzone 输出 ==="
        cat /tmp/iozone_mini.txt
        echo "=== 输出结束 ==="
    rlPhaseEnd

    rlPhaseStartCleanup "清理"
        rlRun "cd /" 0 ""; [ -n "$TmpDir" ] && rlRun "rm -rf $TmpDir" 0 ""
        rm -f /tmp/iozone_{version,help,mini}.txt
    rlPhaseEnd
    rlJournalPrintText
rlJournalEnd
