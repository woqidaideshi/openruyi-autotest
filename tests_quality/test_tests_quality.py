"""
单元测试：验证 tests/ 目录下测试用例的质量和规范。

运行方式：
    python -m unittest discover -s unittest -p "test_*.py" -v
    python -m unittest unittest.test_tests_quality -v
"""

import os
import re
import stat
import subprocess
import unittest

# 项目根目录（unittest 的父目录）
PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TESTS_DIR = os.path.join(PROJECT_ROOT, "tests")


def _collect_files(root_dir, pattern="*"):
    """递归收集 root_dir 下的所有文件，返回绝对路径列表。"""
    result = []
    for dirpath, dirnames, filenames in os.walk(root_dir):
        # 跳过隐藏目录
        dirnames[:] = [d for d in dirnames if not d.startswith(".")]
        for fn in filenames:
            if fn.startswith("."):
                continue
            result.append(os.path.join(dirpath, fn))
    return result


def _is_binary(filepath):
    """快速检测文件是否为二进制文件。"""
    try:
        with open(filepath, "rb") as f:
            chunk = f.read(1024)
        # 如果包含空字节，视为二进制
        return b"\x00" in chunk
    except Exception:
        return True


def _read_file(filepath):
    """以 UTF-8 读取文件内容，失败时返回原始 bytes。"""
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            return f.read()
    except UnicodeDecodeError:
        with open(filepath, "rb") as f:
            return f.read()


def _git_show(filepath):
    """通过 git show 读取 Git 中已提交的文件内容（避开 autocrlf 转换）。

    返回原始 bytes，或 None 表示文件不在 git 中。
    """
    rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")
    try:
        result = subprocess.run(
            ["git", "show", f":{rel_path}"],
            capture_output=True, cwd=PROJECT_ROOT,
            timeout=10,
        )
        if result.returncode != 0:
            return None
        return result.stdout
    except Exception:
        return None


def _get_git_tracked_files(root_dir):
    """通过 git ls-files 获取仓库中跟踪的所有文件（绝对路径）。"""
    try:
        result = subprocess.run(
            ["git", "ls-files", "--cached", root_dir],
            capture_output=True, text=True, cwd=PROJECT_ROOT,
            timeout=30,
        )
        if result.returncode != 0:
            return set()
        return {os.path.join(PROJECT_ROOT, f) for f in result.stdout.strip().split("\n") if f}
    except Exception:
        return set()


def _get_git_executable_files():
    """获取 git 中标记为可执行的文件（100755 模式）。

    只扫描 .sh 文件以提高速度并减少输出。
    """
    try:
        result = subprocess.run(
            ["git", "ls-files", "--stage", "tests/", "--", "*.sh"],
            capture_output=True, text=True, cwd=PROJECT_ROOT,
            timeout=60,
        )
        if result.returncode != 0:
            return set()
        executables = set()
        for line in result.stdout.strip().split("\n"):
            if not line:
                continue
            # 格式: 100755 <hash> 0\t<path>
            parts = line.split("\t")
            if len(parts) >= 2:
                mode_info = parts[0].split()
                if mode_info and mode_info[0] == "100755":
                    # 规范化路径（git 返回正斜杠，os.path.join 也保持正斜杠）
                    executables.add(parts[1].replace("\\", "/"))
        return executables
    except Exception:
        return set()


class TestNoChinese(unittest.TestCase):
    """检查 tests/ 目录下所有文件不含中文字符。"""

    # 中文字符 Unicode 范围（使用 \U 语法处理超过4位的码点）
    CHINESE_RE = re.compile(
        r"[\u4e00-\u9fff\u3400-\u4dbf\uf900-\ufaff"
        r"\U0002f800-\U0002fa1f\u3000-\u303f\uff00-\uffef"
        r"\u2e80-\u2eff\u31c0-\u31ef\u2ff0-\u2fff"
        r"\u3100-\u312f\u31a0-\u31bf]"
    )

    # 允许包含中文的文件（如文档、README）
    ALLOWED_PATTERNS = [
        "README.md",
        ".trellis/",
    ]

    def test_no_chinese_in_tests(self):
        """验证 tests/ 目录下所有文件不含中文字符。"""
        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            # 跳过二进制文件
            if _is_binary(filepath):
                continue

            content = _read_file(filepath)
            if content is None:
                continue

            # 检查是否在允许列表中
            rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")
            if any(rel_path.startswith(p) or p in rel_path for p in self.ALLOWED_PATTERNS):
                continue

            matches = self.CHINESE_RE.findall(str(content))
            if matches:
                # 只报告前 5 个匹配
                unique = list(dict.fromkeys(matches))[:5]
                violations.append(f"{rel_path}: {unique}")

        if violations:
            self.fail(
                f"发现 {len(violations)} 个文件包含中文字符:\n"
                + "\n".join(f"  - {v}" for v in violations[:20])
            )


class TestNoMojibake(unittest.TestCase):
    """检查 tests/ 目录下所有文件无乱码。"""

    # 常见的乱码特征（UTF-8 字节序列被错误地以 Latin-1 解释后产生的字符组合）
    # 例如 "é" (C3 A9 in UTF-8) 被 Latin-1 误读后会变成 "Ã©"
    MOJIBAKE_PATTERNS = [
        # "Ã©" — 最常见的 Latin-1 mojibake (é → Ã©)
        re.compile(rb"\xc3\xa9"),
        # "Ã¨" — è → Ã¨
        re.compile(rb"\xc3\xa8"),
        # "Ã§" — ç → Ã§
        re.compile(rb"\xc3\xa7"),
        # "Ã" + 高位字节 (通用的 UTF-8 双字节误读为 Latin-1)
        re.compile(rb"\xc3[\x80-\xbf]"),
        # 连续的 UTF-8 替换字符 U+FFFD（3个以上表示大面积解码失败）
        re.compile(rb"\xef\xbf\xbd{3,}"),
    ]

    # 已知可能触发误报的文件
    EXCLUDED_FILES = []

    def test_no_mojibake_in_tests(self):
        """验证 tests/ 目录下所有文件无乱码特征。"""
        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")

            if rel_path in self.EXCLUDED_FILES:
                continue

            # 跳过二进制文件
            if _is_binary(filepath):
                continue

            try:
                with open(filepath, "rb") as f:
                    raw = f.read()
            except Exception:
                continue

            # 核心检测：如果能成功以 UTF-8 解码，则认为内容正常（非乱码）
            # BOM 头也算正常 UTF-8
            check_raw = raw[3:] if raw.startswith(b"\xef\xbb\xbf") else raw
            try:
                check_raw.decode("utf-8")
                continue  # UTF-8 解码成功，内容正常
            except UnicodeDecodeError:
                pass  # UTF-8 解码失败，进一步检查

            # UTF-8 解码失败：检查是否有 Latin-1 mojibake 特征
            for pattern in self.MOJIBAKE_PATTERNS:
                matches = pattern.findall(raw)
                if matches:
                    samples = [m[:20] for m in matches[:3]]
                    violations.append(f"{rel_path}: pattern={pattern.pattern}, samples={samples}")
                    break
            else:
                # 没有 mojibake 特征，但仍然不是 UTF-8 — 可能是 GBK/GB18030 编码
                try:
                    raw.decode("gb18030")
                    violations.append(f"{rel_path}: 文件编码为 GBK/GB18030（非 UTF-8），可能含中文")
                except Exception:
                    violations.append(f"{rel_path}: 无法以 UTF-8 或 GB18030 解码，文件可能已损坏")

        if violations:
            self.fail(
                f"发现 {len(violations)} 个文件可能存在编码问题:\n"
                + "\n".join(f"  - {v}" for v in violations[:20])
            )


class TestShTmtCompliance(unittest.TestCase):
    """检查 tests/ 目录下所有 .sh 文件符合 tmt 测试框架规范。"""

    def _check_test_sh(self, filepath):
        """检查 test.sh 文件（Git 提交版本）是否符合规范。"""
        errors = []
        raw = _git_show(filepath)
        if raw is None:
            return errors  # 未跟踪的文件跳过

        # 跳过 UTF-8 BOM
        if raw.startswith(b"\xef\xbb\xbf"):
            content = raw[3:].decode("utf-8")
        else:
            try:
                content = raw.decode("utf-8")
            except UnicodeDecodeError:
                errors.append("文件编码不是 UTF-8")
                return errors

        # 1. 检查 shebang（允许 BOM 后的 shebang）
        if not content.startswith("#!/bin/bash") and not content.startswith("#!/usr/bin/env bash"):
            errors.append("缺少 shebang (#!/bin/bash)")

        # 2. 检查是否 source beakerlib.sh
        if "beakerlib.sh" not in content:
            errors.append('未引用 beakerlib.sh')

        # 3. 检查 rlJournalStart
        if "rlJournalStart" not in content:
            errors.append("缺少 rlJournalStart")

        # 4. 检查 rlJournalEnd
        if "rlJournalEnd" not in content:
            errors.append("缺少 rlJournalEnd")

        # 5. 检查没有 CRLF
        if "\r" in content:
            errors.append("包含 Windows 换行符 (CRLF)，应使用 LF")

        return errors

    def _check_lib_sh(self, filepath):
        """检查 lib.sh 文件（Git 提交版本）是否符合规范。"""
        errors = []
        raw = _git_show(filepath)
        if raw is None:
            return errors  # 未跟踪的文件跳过

        # 跳过 UTF-8 BOM
        if raw.startswith(b"\xef\xbb\xbf"):
            content = raw[3:].decode("utf-8")
        else:
            try:
                content = raw.decode("utf-8")
            except UnicodeDecodeError:
                errors.append("文件编码不是 UTF-8")
                return errors

        # 1. 检查 library-prefix 注释
        if "library-prefix" not in content:
            errors.append('缺少 library-prefix 注释')

        # 2. 检查没有 CRLF
        if "\r" in content:
            errors.append("包含 Windows 换行符 (CRLF)，应使用 LF")

        return errors

    def _check_other_sh(self, filepath):
        """检查其他 .sh 文件（如 hw_check.sh）。"""
        errors = []
        try:
            with open(filepath, "rb") as f:
                raw = f.read()
        except Exception:
            errors.append("无法读取文件")
            return errors

        # 跳过 UTF-8 BOM
        if raw.startswith(b"\xef\xbb\xbf"):
            content = raw[3:].decode("utf-8")
        else:
            try:
                content = raw.decode("utf-8")
            except UnicodeDecodeError:
                errors.append("文件编码不是 UTF-8")
                return errors

        # 检查没有 CRLF
        if "\r" in content:
            errors.append("包含 Windows 换行符 (CRLF)，应使用 LF")

        return errors

    def test_test_sh_compliance(self):
        """验证所有 test.sh 符合 tmt 测试框架规范。"""
        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            filename = os.path.basename(filepath)
            if filename != "test.sh":
                continue

            errors = self._check_test_sh(filepath)
            if errors:
                rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")
                violations.append(f"{rel_path}: {'; '.join(errors)}")

        if violations:
            self.fail(
                f"发现 {len(violations)} 个 test.sh 不符合规范:\n"
                + "\n".join(f"  - {v}" for v in violations[:30])
            )

    def test_lib_sh_compliance(self):
        """验证所有 lib.sh 符合规范。"""
        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            filename = os.path.basename(filepath)
            if filename != "lib.sh":
                continue

            errors = self._check_lib_sh(filepath)
            if errors:
                rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")
                violations.append(f"{rel_path}: {'; '.join(errors)}")

        if violations:
            self.fail(
                f"发现 {len(violations)} 个 lib.sh 不符合规范:\n"
                + "\n".join(f"  - {v}" for v in violations[:20])
            )

    def test_no_crlf_in_sh_files(self):
        """验证所有 .sh 文件（Git 提交版本）不含 CRLF 换行符。"""
        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            if not filepath.endswith(".sh"):
                continue

            # 通过 git show 读取已提交内容（避开 autocrlf 转换）
            raw = _git_show(filepath)
            if raw is None:
                continue

            if b"\r\n" in raw or b"\r" in raw:
                rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")
                violations.append(rel_path)

        if violations:
            self.fail(
                f"发现 {len(violations)} 个 .sh 文件包含 CRLF/CR:\n"
                + "\n".join(f"  - {v}" for v in violations[:30])
            )

    def test_main_fmf_yaml_valid(self):
        """验证所有 main.fmf 文件为合法 YAML 且不包含废弃字段。"""
        import yaml as yaml_module

        all_files = _collect_files(TESTS_DIR)
        violations = []

        for filepath in all_files:
            if os.path.basename(filepath) != "main.fmf":
                continue

            rel_path = os.path.relpath(filepath, PROJECT_ROOT).replace("\\", "/")

            # 读取原始内容
            try:
                with open(filepath, "r", encoding="utf-8") as f:
                    raw_content = f.read()
            except Exception:
                violations.append(f"{rel_path}: 无法读取文件")
                continue

            # 检查废弃的 hardware-require 字段
            if "hardware-require" in raw_content and "extra-hardware-require" not in raw_content:
                # 精确检查：排除 extra-hardware-require 包含的情况
                if re.search(r'^hardware-require\s*:', raw_content, re.MULTILINE):
                    violations.append(f"{rel_path}: 使用了废弃的 hardware-require，应为 extra-hardware-require")

            # 检查 test: 后有空格
            for match in re.finditer(r'^test:\s*(\S)', raw_content, re.MULTILINE):
                if match.group(0).startswith("test:."):
                    violations.append(f"{rel_path}: 'test:' 后缺少空格")

            # 验证 YAML 合法性
            try:
                yaml_module.safe_load(raw_content)
            except yaml_module.YAMLError as e:
                violations.append(f"{rel_path}: YAML 解析错误 - {e}")

        if violations:
            self.fail(
                f"发现 {len(violations)} 个 main.fmf 存在问题:\n"
                + "\n".join(f"  - {v}" for v in violations[:30])
            )


class TestShExecutable(unittest.TestCase):
    """检查 tests/ 目录下所有 .sh 文件具有可执行权限。"""

    def test_sh_files_executable_in_git(self):
        """验证所有 .sh 文件在 git 中标记为可执行（100755）。"""
        all_files = _collect_files(TESTS_DIR)
        sh_files = {os.path.relpath(f, PROJECT_ROOT).replace("\\", "/") for f in all_files if f.endswith(".sh")}

        executables = _get_git_executable_files()
        non_executable = []

        for f in sorted(sh_files):
            if f not in executables:
                non_executable.append(f)

        if non_executable:
            self.fail(
                f"发现 {len(non_executable)} 个 .sh 文件在 git 中未标记为可执行 (100755):\n"
                + "\n".join(f"  - {v}" for v in non_executable[:30])
                + "\n\n修复方法: git update-index --chmod=+x <file>"
            )

    def test_no_non_sh_executable_in_tests(self):
        """验证 tests/ 目录下除 .sh 外没有其他可执行文件。"""
        all_files = _collect_files(TESTS_DIR)
        non_sh_files = {os.path.relpath(f, PROJECT_ROOT).replace("\\", "/") for f in all_files if not f.endswith(".sh")}

        executables = _get_git_executable_files()
        unexpected = []

        for f in sorted(non_sh_files):
            if f in executables:
                unexpected.append(f)

        if unexpected:
            self.fail(
                f"发现 {len(unexpected)} 个非 .sh 文件被标记为可执行:\n"
                + "\n".join(f"  - {v}" for v in unexpected)
            )


if __name__ == "__main__":
    unittest.main()
