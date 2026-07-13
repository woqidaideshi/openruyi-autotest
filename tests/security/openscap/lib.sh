# library-prefix = openscap
#
# Security OpenSCAP suite-level shared library
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# OpenSCAP result determination:
#   - oscap info: checks document type and profiles exist
#   - oscap eval: checks XML result for pass/fail/notapplicable counts
#   - oscap generate fix: checks fix script generation
#   - report: checks HTML report generation
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_openscap_*/ subdirectories

OPENSCAP_DS="/usr/share/xml/scap/ssg/content/ssg-openruyi-ds.xml"
OPENSCAP_PROFILE="xccdf_org.ssgproject.content_profile_standard"
OPENSCAP_FLAG="/tmp/.beakerlib_openscap_suite"

# Run oscap info and verify the data stream file is valid.
# Usage: _openscapInfo
_openscapInfo() {
    local out="/tmp/openscap_out_$$"

    if [ ! -f "$OPENSCAP_DS" ]; then
        rlFail "Data stream file not found ($OPENSCAP_DS)"
        return 1
    fi

    oscap info "$OPENSCAP_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ]; then
        rlFail "oscap info 执行失败 (exit=$rc)"
        rm -f "$out"
        return 1
    fi

    # Verify expected content
    if ! grep -q "Document type: Source Data Stream" "$out"; then
        rlFail "oscap info 输出不完整（缺少 Document type）"
        rm -f "$out"
        return 1
    fi

    if ! grep -q "$OPENSCAP_PROFILE" "$out"; then
        rlFail "oscap info 未找到预期的 profile: $OPENSCAP_PROFILE"
        rm -f "$out"
        return 1
    fi

    rlPass "oscap info 数据流验证通过"
    rm -f "$out"
    return 0
}

# Run oscap xccdf eval and check results.
# Usage: _openscapEval
_openscapEval() {
    local out="/tmp/openscap_eval_$$"
    local result_xml="/tmp/openscap_result_$$.xml"
    local report_html="/tmp/openscap_report_$$.html"

    if [ ! -f "$OPENSCAP_DS" ]; then
        rlFail "Data stream file not found ($OPENSCAP_DS)"
        return 1
    fi

    timeout --signal=KILL --kill-after=10 600 \
        oscap xccdf eval --profile "$OPENSCAP_PROFILE" \
            --results-arf "$result_xml" \
            --report "$report_html" \
            "$OPENSCAP_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -eq 137 ]; then
        rlFail "oscap eval 执行超时"
        rm -f "$out" "$result_xml" "$report_html"
        return 1
    fi

    if [ "$rc" -ne 0 ]; then
        rlFail "oscap eval 执行失败 (exit=$rc)"
        rm -f "$out" "$result_xml" "$report_html"
        return 1
    fi

    # Check that result files were generated
    if [ ! -f "$result_xml" ]; then
        rlFail "oscap eval 未生成 ARF 结果文件"
        rm -f "$out" "$report_html"
        return 1
    fi

    if [ ! -f "$report_html" ]; then
        rlFail "oscap eval 未生成 HTML 报告文件"
        rm -f "$out" "$result_xml"
        return 1
    fi

    # Parse result counts from XML
    local pass fail notappl error
    pass=$(grep -c '<result>pass</result>' "$result_xml" 2>/dev/null || echo 0)
    fail=$(grep -c '<result>fail</result>' "$result_xml" 2>/dev/null || echo 0)
    notappl=$(grep -c '<result>notapplicable</result>' "$result_xml" 2>/dev/null || echo 0)

    rlPass "oscap eval 完成 (pass=$pass, fail=$fail, notapplicable=$notappl)"
    rm -f "$out" "$result_xml" "$report_html"
    return 0
}

# Run oscap xccdf generate fix and verify fix script generation.
# Usage: _openscapGenerateFix
_openscapGenerateFix() {
    local out="/tmp/openscap_fix_$$"
    local result_xml="/tmp/openscap_fix_result_$$.xml"
    local fix_sh="/tmp/openscap_fix_$$.sh"

    if [ ! -f "$OPENSCAP_DS" ]; then
        rlFail "Data stream file not found ($OPENSCAP_DS)"
        return 1
    fi

    # First run eval to get results
    timeout --signal=KILL --kill-after=10 300 \
        oscap xccdf eval --profile "$OPENSCAP_PROFILE" \
            --results "$result_xml" \
            "$OPENSCAP_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ] || [ ! -f "$result_xml" ]; then
        rlFail "oscap eval 失败，无法生成修复脚本"
        rm -f "$out" "$result_xml"
        return 1
    fi

    # Extract result-id from the eval output
    local result_id
    result_id=$(grep -oP 'TestResult.*?id="\K[^"]+' "$result_xml" | head -1)
    if [ -z "$result_id" ]; then
        rlFail "无法从结果中提取 TestResult id"
        rm -f "$out" "$result_xml"
        return 1
    fi

    # Generate fix script
    oscap xccdf generate fix --fix-type bash \
        --result-id "$result_id" \
        --output "$fix_sh" \
        "$result_xml" 2>&1 | tee -a "$out"
    rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ]; then
        rlFail "oscap generate fix 执行失败 (exit=$rc)"
        rm -f "$out" "$result_xml" "$fix_sh"
        return 1
    fi

    if [ ! -f "$fix_sh" ] || [ ! -s "$fix_sh" ]; then
        rlLogWarning "oscap generate fix 生成的修复脚本为空（系统已合规）"
        rlPass "oscap generate fix 完成（无需修复）"
    else
        local lines
        lines=$(wc -l < "$fix_sh")
        rlPass "oscap generate fix 完成（生成 $lines 行修复脚本）"
    fi

    rm -f "$out" "$result_xml" "$fix_sh"
    return 0
}

openscapSetup() {
    if [ ! -f "$OPENSCAP_FLAG" ]; then
        if [ ! -f "$OPENSCAP_DS" ]; then
            echo "${TEST_SERVER_1_PASSWORD:-openruyi}" | sudo -S dnf install -y scap-security-guide 2>/dev/null
            if [ ! -f "$OPENSCAP_DS" ]; then
                rlLogWarning "scap-security-guide 安装失败，测试将被跳过"
                echo "installed=0" > "$OPENSCAP_FLAG"
            else
                echo "installed=1" > "$OPENSCAP_FLAG"
                rlLogInfo "已安装 scap-security-guide（首次）"
            fi
        else
            echo "installed=0" > "$OPENSCAP_FLAG"
            rlLogInfo "scap-security-guide 已存在"
        fi
        echo "ref=1" >> "$OPENSCAP_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$OPENSCAP_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$OPENSCAP_FLAG"
        rlLogInfo "openscap 已安装，引用计数: $ref"
    fi

    rlCleanupAppend "openscapCleanup"
}

openscapCleanup() {
    if [ ! -f "$OPENSCAP_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$OPENSCAP_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$OPENSCAP_FLAG"
        rlLogInfo "openscap 测试套清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$OPENSCAP_FLAG"
        rlLogInfo "openscap 保留（还有 $ref 个测试未完成）"
    fi
}