# library-prefix = cis_benchmark
#
# Security CIS Benchmark suite-level shared library
# Uses flag-file + reference counting for suite-level setup/cleanup.
#
# CIS Benchmark result determination:
#   - profile_list: checks available CIS profiles
#   - eval: runs oscap xccdf eval against CIS profile, checks XML result
#   - pass_count: counts pass/fail/notapplicable rules
#   - fail_list: lists failed rules with details
#   - fix_generate: generates fix script for failed rules
#
# Usage in each test file:
#   . "$(dirname "$0")/../lib.sh"    # from test_cis_*/ subdirectories

CIS_DS="/usr/share/xml/scap/ssg/content/ssg-openruyi-ds.xml"
CIS_PROFILE="xccdf_org.ssgproject.content_profile_standard"
CIS_FLAG="/tmp/.beakerlib_cis_benchmark_suite"

# Verify CIS profile is available in the data stream.
# Usage: _cisProfileList
_cisProfileList() {
    local out="/tmp/cis_out_$$"

    if [ ! -f "$CIS_DS" ]; then
        rlFail "CIS data stream file not found ($CIS_DS)"
        return 1
    fi

    oscap info "$CIS_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ]; then
        rlFail "oscap info 执行失败 (exit=$rc)"
        rm -f "$out"
        return 1
    fi

    # Count available profiles
    local profile_count
    profile_count=$(grep -c 'Id: xccdf_org.ssgproject.content_profile_' "$out" 2>/dev/null || echo 0)
    if [ "$profile_count" -eq 0 ]; then
        rlFail "未找到任何 CIS profile"
        rm -f "$out"
        return 1
    fi

    # Verify target profile exists
    if ! grep -q "$CIS_PROFILE" "$out"; then
        rlFail "目标 CIS profile 不存在: $CIS_PROFILE"
        rm -f "$out"
        return 1
    fi

    rlPass "CIS profile 验证通过（共 $profile_count 个 profile）"
    rm -f "$out"
    return 0
}

# Run CIS benchmark evaluation and check result counts.
# Usage: _cisEval
_cisEval() {
    local out="/tmp/cis_eval_$$"
    local result_xml="/tmp/cis_result_$$.xml"
    local report_html="/tmp/cis_report_$$.html"

    if [ ! -f "$CIS_DS" ]; then
        rlFail "CIS data stream file not found"
        return 1
    fi

    timeout --signal=KILL --kill-after=10 600 \
        oscap xccdf eval --profile "$CIS_PROFILE" \
            --results-arf "$result_xml" \
            --report "$report_html" \
            "$CIS_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -eq 137 ]; then
        rlFail "CIS eval 执行超时"
        rm -f "$out" "$result_xml" "$report_html"
        return 1
    fi

    if [ "$rc" -ne 0 ]; then
        rlFail "CIS eval 执行失败 (exit=$rc)"
        rm -f "$out" "$result_xml" "$report_html"
        return 1
    fi

    if [ ! -f "$result_xml" ]; then
        rlFail "CIS eval 未生成结果文件"
        rm -f "$out" "$report_html"
        return 1
    fi

    if [ ! -f "$report_html" ] || [ ! -s "$report_html" ]; then
        rlFail "CIS eval 未生成有效报告"
        rm -f "$out" "$result_xml"
        return 1
    fi

    rlPass "CIS 合规评估完成"
    rm -f "$out" "$result_xml" "$report_html"
    return 0
}

# Run CIS evaluation and count pass/fail/notapplicable results.
# Usage: _cisResultCount
_cisResultCount() {
    local out="/tmp/cis_count_$$"
    local result_xml="/tmp/cis_count_result_$$.xml"

    if [ ! -f "$CIS_DS" ]; then
        rlFail "CIS data stream file not found"
        return 1
    fi

    timeout --signal=KILL --kill-after=10 600 \
        oscap xccdf eval --profile "$CIS_PROFILE" \
            --results "$result_xml" \
            "$CIS_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ] || [ ! -f "$result_xml" ]; then
        rlFail "CIS eval 失败"
        rm -f "$out" "$result_xml"
        return 1
    fi

    local pass fail notappl error unknown
    pass=$(grep -c '<result>pass</result>' "$result_xml" 2>/dev/null || echo 0)
    fail=$(grep -c '<result>fail</result>' "$result_xml" 2>/dev/null || echo 0)
    notappl=$(grep -c '<result>notapplicable</result>' "$result_xml" 2>/dev/null || echo 0)
    error=$(grep -c '<result>error</result>' "$result_xml" 2>/dev/null || echo 0)
    unknown=$(grep -c '<result>unknown</result>' "$result_xml" 2>/dev/null || echo 0)

    if [ "$error" -gt 0 ] || [ "$unknown" -gt 0 ]; then
        rlLogWarning "CIS 结果存在 error=$error, unknown=$unknown"
    fi

    rlPass "CIS 结果统计: pass=$pass, fail=$fail, notapplicable=$notappl"
    rm -f "$out" "$result_xml"
    return 0
}

# Run CIS evaluation and list all failed rules with their titles.
# Usage: _cisFailList
_cisFailList() {
    local out="/tmp/cis_fail_$$"
    local result_xml="/tmp/cis_fail_result_$$.xml"

    if [ ! -f "$CIS_DS" ]; then
        rlFail "CIS data stream file not found"
        return 1
    fi

    timeout --signal=KILL --kill-after=10 600 \
        oscap xccdf eval --profile "$CIS_PROFILE" \
            --results "$result_xml" \
            "$CIS_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ] || [ ! -f "$result_xml" ]; then
        rlFail "CIS eval 失败"
        rm -f "$out" "$result_xml"
        return 1
    fi

    local fail_count
    fail_count=$(grep -c '<result>fail</result>' "$result_xml" 2>/dev/null || echo 0)

    if [ "$fail_count" -eq 0 ]; then
        rlPass "CIS 失败规则列表: 0 项失败（系统完全合规）"
    else
        rlLogWarning "CIS 失败规则共 $fail_count 项:"
        # Extract rule IDs and titles for failed rules
        grep -B3 '<result>fail</result>' "$result_xml" | grep 'idref=' | while IFS= read -r line; do
            local rule_id
            rule_id=$(echo "$line" | grep -oP 'idref="\K[^"]+')
            rlLogInfo "  失败规则: $rule_id"
        done
        rlFail "CIS 失败规则列表: $fail_count 项未通过"
    fi

    rm -f "$out" "$result_xml"
    return 0
}

# Run CIS evaluation and generate a fix script for failed rules.
# Usage: _cisFixGenerate
_cisFixGenerate() {
    local out="/tmp/cis_fix_$$"
    local result_xml="/tmp/cis_fix_result_$$.xml"
    local fix_sh="/tmp/cis_fix_$$.sh"

    if [ ! -f "$CIS_DS" ]; then
        rlFail "CIS data stream file not found"
        return 1
    fi

    timeout --signal=KILL --kill-after=10 300 \
        oscap xccdf eval --profile "$CIS_PROFILE" \
            --results "$result_xml" \
            "$CIS_DS" 2>&1 | tee "$out"
    local rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ] || [ ! -f "$result_xml" ]; then
        rlFail "CIS eval 失败"
        rm -f "$out" "$result_xml"
        return 1
    fi

    local result_id
    result_id=$(grep -oP 'id="\K[^"]+' "$result_xml" | head -1)
    if [ -z "$result_id" ]; then
        rlFail "无法提取 TestResult id"
        rm -f "$out" "$result_xml"
        return 1
    fi

    oscap xccdf generate fix --fix-type bash \
        --result-id "$result_id" \
        --output "$fix_sh" \
        "$result_xml" 2>&1 | tee -a "$out"
    rc=${PIPESTATUS[0]}

    if [ "$rc" -ne 0 ]; then
        rlFail "CIS fix 生成失败 (exit=$rc)"
        rm -f "$out" "$result_xml" "$fix_sh"
        return 1
    fi

    if [ ! -f "$fix_sh" ] || [ ! -s "$fix_sh" ]; then
        rlLogWarning "无需生成修复脚本（系统已合规）"
        rlPass "CIS 修复脚本生成完成（0 项需修复）"
    else
        local lines
        lines=$(wc -l < "$fix_sh")
        # Validate fix script syntax
        if bash -n "$fix_sh" 2>/dev/null; then
            rlPass "CIS 修复脚本生成完成（$lines 行，语法检查通过）"
        else
            rlFail "CIS 修复脚本语法错误"
        fi
    fi

    rm -f "$out" "$result_xml" "$fix_sh"
    return 0
}

cisBenchmarkSetup() {
    if [ ! -f "$CIS_FLAG" ]; then
        if [ ! -f "$CIS_DS" ]; then
            echo openruyi | sudo -S dnf install -y scap-security-guide 2>/dev/null
            if [ ! -f "$CIS_DS" ]; then
                rlLogWarning "scap-security-guide 安装失败"
                echo "installed=0" > "$CIS_FLAG"
            else
                echo "installed=1" > "$CIS_FLAG"
                rlLogInfo "已安装 scap-security-guide"
            fi
        else
            echo "installed=0" > "$CIS_FLAG"
            rlLogInfo "scap-security-guide 已存在"
        fi
        echo "ref=1" >> "$CIS_FLAG"
    else
        local ref
        ref=$(grep "^ref=" "$CIS_FLAG" | cut -d= -f2)
        ref=$((ref + 1))
        sed -i "s/^ref=.*/ref=$ref/" "$CIS_FLAG"
        rlLogInfo "CIS benchmark 引用计数: $ref"
    fi
    rlCleanupAppend "cisBenchmarkCleanup"
}

cisBenchmarkCleanup() {
    if [ ! -f "$CIS_FLAG" ]; then return 0; fi
    local ref
    ref=$(grep "^ref=" "$CIS_FLAG" | cut -d= -f2)
    ref=$((ref - 1))
    if [ "$ref" -le 0 ]; then
        rm -f "$CIS_FLAG"
        rlLogInfo "CIS benchmark 测试套清理完成"
    else
        sed -i "s/^ref=.*/ref=$ref/" "$CIS_FLAG"
        rlLogInfo "CIS benchmark 保留（还有 $ref 个测试）"
    fi
}