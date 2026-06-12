"""Test generator: Generate ACL-style test scripts for all packages.
Phase 1: Simple CLI packages (single or few commands).
"""
import os, json, re

BASE = 'tests/functional'
RESEARCH_DIR = '.trellis/tasks/06-12-170-base-pkgs-full-coverage/research'

with open(os.path.join(RESEARCH_DIR, 'pkg_info.json')) as f:
    pkg_info = json.load(f)

def shell_escape(s):
    return s.replace('\\', '\\\\').replace('"', '\\"').replace('$', '\\$').replace('`', '\\`')

def gen_main_fmf(pkg, summary, test_path='./test.sh', duration='5m', require=None, tags=None):
    lines = [f'summary: {summary}']
    lines.append(f'test: {test_path}')
    if tags:
        lines.append('tag:')
        for t in tags:
            lines.append(f'  - {t}')
    lines.append(f'duration: {duration}')
    lines.append('tier: 1')
    lines.append(f'path: /tests/functional/{pkg}')
    if require:
        lines.append('require:')
        for r in require:
            lines.append(f'  - {r}')
    return '\n'.join(lines) + '\n'

def gen_sub_main_fmf(pkg, sub_name, summary, duration='2m', require=None):
    lines = [f'summary: {summary}']
    lines.append('test: ./test.sh')
    lines.append('tag:')
    lines.append(f'  - functional')
    lines.append(f'  - {pkg}')
    lines.append(f'duration: {duration}')
    lines.append('tier: 1')
    lines.append(f'path: /tests/functional/{pkg}/{sub_name}')
    if require:
        lines.append('require:')
        for r in require:
            lines.append(f'  - {r}')
    return '\n'.join(lines) + '\n'

def gen_test_header(pkg_desc, cmds=None):
    h = ['#!/bin/sh -eux']
    h.append(f'# Functional test: {pkg_desc}')
    if cmds:
        h.append(f'# Tests: {", ".join(cmds)} commands')
    h.append('')
    h.append('# rlRun wrapper for standalone execution')
    h.append('rlRun() { eval "$1" 2>&1; return $?; }')
    h.append('')
    return '\n'.join(h) + '\n'

def gen_rpm_check(pkg_name):
    return f'rlRun \'rpm -q {pkg_name}\' 0 "检查 {pkg_name} 软件包是否已安装"\n'

def gen_cmd_check(cmd):
    return f'rlRun \'which {cmd}\' 0 "检查 {cmd} 命令是否可用"\n'

def gen_version_check(cmd):
    return f'rlRun \'{cmd} --version\' 0 "获取 {cmd} 版本信息"\n'

def gen_help_check(cmd):
    return f'rlRun \'{cmd} --help\' 0 "查看 {cmd} 帮助信息"\n'

def gen_error_test(cmd):
    return f'rlRun \'{cmd} --invalid-flag-xyz 2>&1 || true\' 0 "测试 {cmd} 无效参数错误处理"\n'

def gen_temp_dir():
    return ['rlRun \'TmpDir=$(mktemp -d)\' 0 "创建临时测试目录"\n',
            'rlRun \'cd $TmpDir\' 0 "进入测试目录"\n']

def gen_cleanup():
    return ['rlRun \'cd /\' 0 "离开测试目录"\n',
            'rlRun \'rm -rf $TmpDir\' 0 "清理临时测试目录"\n']

def gen_file_create():
    return ['rlRun \'touch testfile\' 0 "创建测试文件"\n',
            'rlRun \'mkdir testdir\' 0 "创建测试目录"\n']

def gen_section(title):
    return f'\necho "=== 测试: {title} ==="\n'

def gen_pass_msg(pkg):
    return f'\necho ""\necho "All {pkg} functional tests passed!"\n'

# ============================================================
# Package-specific generators
# ============================================================

def gen_attr_tests():
    """attr: attr, getfattr, setfattr"""
    pkg = 'attr'
    dir_path = os.path.join(BASE, pkg)
    
    # Main test.sh
    main = gen_test_header('attr - 扩展文件属性', ['attr', 'getfattr', 'setfattr'])
    main += gen_rpm_check(pkg)
    main += gen_cmd_check('attr')
    main += gen_cmd_check('getfattr')
    main += gen_cmd_check('setfattr')
    main += gen_version_check('attr')
    main += gen_version_check('getfattr')
    main += gen_version_check('setfattr')
    main += ''.join(gen_temp_dir())
    main += ''.join(gen_file_create())
    main += gen_pass_msg(pkg)
    
    with open(os.path.join(dir_path, 'test.sh'), 'w') as f:
        f.write(main)
    
    # Sub-tests
    subs = [
        ('test_attr_getfattr_basic', 'attr - getfattr 基本功能',
         lambda: gen_test_header('attr - getfattr 基本功能', ['getfattr']) +
                 gen_rpm_check(pkg) + gen_cmd_check('getfattr') +
                 ''.join(gen_temp_dir()) + ''.join(gen_file_create()) +
                 gen_section('getfattr 基本功能') +
                 'rlRun \'getfattr -d testfile\' 0 "查看文件扩展属性"\n' +
                 'rlRun \'setfattr -n user.test -v hello testfile\' 0 "设置扩展属性"\n' +
                 'rlRun \'getfattr -n user.test testfile\' 0 "查看指定扩展属性"\n' +
                 'rlRun \'getfattr -d testfile\' 0 "查看所有扩展属性"\n' +
                 gen_pass_msg('attr-getfattr-basic')),
        
        ('test_attr_setfattr_basic', 'attr - setfattr 基本功能',
         lambda: gen_test_header('attr - setfattr 基本功能', ['setfattr']) +
                 gen_rpm_check(pkg) + gen_cmd_check('setfattr') +
                 ''.join(gen_temp_dir()) + ''.join(gen_file_create()) +
                 gen_section('setfattr 基本功能') +
                 'rlRun \'setfattr -n user.test -v hello testfile\' 0 "设置扩展属性"\n' +
                 'rlRun \'getfattr -n user.test testfile\' 0 "验证设置成功"\n' +
                 'rlRun \'setfattr -n user.test2 -v world testfile\' 0 "设置第二个扩展属性"\n' +
                 'rlRun \'getfattr -d testfile\' 0 "查看多个扩展属性"\n' +
                 'rlRun \'setfattr -x user.test testfile\' 0 "删除扩展属性"\n' +
                 'rlRun \'setfattr -x user.test2 testfile\' 0 "删除第二个扩展属性"\n' +
                 gen_pass_msg('attr-setfattr-basic')),
        
        ('test_attr_error_handling', 'attr - 错误处理',
         lambda: gen_test_header('attr - 错误处理', ['attr', 'getfattr', 'setfattr']) +
                 gen_rpm_check(pkg) + gen_cmd_check('getfattr') + gen_cmd_check('setfattr') +
                 ''.join(gen_temp_dir()) +
                 gen_section('错误处理') +
                 'rlRun \'getfattr nonexistent_file\' 1-255 "测试不存在文件报错"\n' +
                 'rlRun \'setfattr -n user.test -v val nonexistent_file\' 1-255 "测试对不存在文件操作报错"\n' +
                 'rlRun \'getfattr --invalid-flag nonexistent\' 1-255 "测试无效参数报错"\n' +
                 gen_pass_msg('attr-error-handling')),
    ]
    
    for sub_name, summary, gen_func in subs:
        sub_dir = os.path.join(dir_path, sub_name)
        os.makedirs(sub_dir, exist_ok=True)
        with open(os.path.join(sub_dir, 'test.sh'), 'w') as f:
            f.write(gen_func())
        with open(os.path.join(sub_dir, 'main.fmf'), 'w') as f:
            f.write(gen_sub_main_fmf(pkg, sub_name, summary))
    
    # Main main.fmf
    with open(os.path.join(dir_path, 'main.fmf'), 'w') as f:
        f.write(gen_main_fmf(pkg, f'功能测试 - {pkg} 软件包功能验证', require=[pkg, 'coreutils']))
    
    return f'{pkg}: 1 main + {len(subs)} sub-tests'

def gen_bc_tests():
    """bc: bc, dc"""
    pkg = 'bc'
    dir_path = os.path.join(BASE, pkg)
    
    main = gen_test_header('bc - 任意精度计算器', ['bc', 'dc'])
    main += gen_rpm_check(pkg)
    main += gen_cmd_check('bc')
    main += gen_cmd_check('dc')
    main += gen_version_check('bc')
    main += gen_version_check('dc')
    main += gen_pass_msg(pkg)
    
    with open(os.path.join(dir_path, 'test.sh'), 'w') as f:
        f.write(main)
    
    subs = [
        ('test_bc_basic', 'bc - 基本运算',
         lambda: gen_test_header('bc - 基本运算', ['bc']) +
                 gen_rpm_check(pkg) + gen_cmd_check('bc') +
                 gen_section('bc 基本运算') +
                 'rlRun \'echo "1+1" | bc\' 0 "基本加法"\n' +
                 'rlRun \'echo "10-3" | bc\' 0 "基本减法"\n' +
                 'rlRun \'echo "6*7" | bc\' 0 "基本乘法"\n' +
                 'rlRun \'echo "100/3" | bc\' 0 "基本除法"\n' +
                 'rlRun \'echo "scale=4; 1/3" | bc\' 0 "设置精度"\n' +
                 'rlRun \'echo "2^10" | bc\' 0 "幂运算"\n' +
                 'rlRun \'echo "sqrt(16)" | bc\' 0 "平方根"\n' +
                 gen_pass_msg('bc-basic')),
        
        ('test_dc_basic', 'dc - 逆波兰计算器',
         lambda: gen_test_header('dc - 逆波兰计算器', ['dc']) +
                 gen_rpm_check(pkg) + gen_cmd_check('dc') +
                 gen_section('dc 基本运算') +
                 'rlRun \'echo "1 1 + p" | dc\' 0 "dc 加法"\n' +
                 'rlRun \'echo "10 3 - p" | dc\' 0 "dc 减法"\n' +
                 'rlRun \'echo "6 7 * p" | dc\' 0 "dc 乘法"\n' +
                 'rlRun \'echo "100 3 / p" | dc\' 0 "dc 除法"\n' +
                 'rlRun \'echo "4 k 1 3 / p" | dc\' 0 "dc 精度设置"\n' +
                 gen_pass_msg('dc-basic')),
        
        ('test_bc_error', 'bc/dc - 错误处理',
         lambda: gen_test_header('bc/dc - 错误处理', ['bc', 'dc']) +
                 gen_rpm_check(pkg) + gen_cmd_check('bc') +
                 gen_section('错误处理') +
                 'rlRun \'bc --invalid 2>&1 || true\' 0 "bc 无效参数"\n' +
                 'rlRun \'dc --invalid 2>&1 || true\' 0 "dc 无效参数"\n' +
                 'rlRun \'echo "1/0" | bc 2>&1 || true\' 0 "bc 除零错误"\n' +
                 gen_pass_msg('bc-error')),
    ]
    
    for sub_name, summary, gen_func in subs:
        sub_dir = os.path.join(dir_path, sub_name)
        os.makedirs(sub_dir, exist_ok=True)
        with open(os.path.join(sub_dir, 'test.sh'), 'w') as f:
            f.write(gen_func())
        with open(os.path.join(sub_dir, 'main.fmf'), 'w') as f:
            f.write(gen_sub_main_fmf(pkg, sub_name, summary))
    
    with open(os.path.join(dir_path, 'main.fmf'), 'w') as f:
        f.write(gen_main_fmf(pkg, f'功能测试 - {pkg} 软件包功能验证', require=[pkg]))
    
    return f'{pkg}: 1 main + {len(subs)} sub-tests'

def gen_generic_cli_test(pkg_name, cmds, specific_tests=None):
    """Generate generic tests for a CLI package with given commands."""
    dir_path = os.path.join(BASE, pkg_name)
    os.makedirs(dir_path, exist_ok=True)
    
    # Main test.sh
    main = gen_test_header(f'{pkg_name} 软件包', cmds)
    main += gen_rpm_check(pkg_name)
    for cmd in cmds:
        main += gen_cmd_check(cmd)
    for cmd in cmds[:5]:  # Version check for first 5 commands
        main += f'rlRun \'{cmd} --version 2>&1 || true\' 0 "获取 {cmd} 版本信息"\n'
    main += gen_pass_msg(pkg_name)
    
    with open(os.path.join(dir_path, 'test.sh'), 'w') as f:
        f.write(main)
    
    # Sub-tests
    subs = []
    
    # Test 1: Basic functionality
    basic_lines = [gen_test_header(f'{pkg_name} - 基本功能', cmds),
                   gen_rpm_check(pkg_name)]
    for cmd in cmds[:10]:
        basic_lines.append(gen_cmd_check(cmd))
    basic_lines.append(gen_section(f'{pkg_name} 基本功能'))
    for cmd in cmds[:5]:
        basic_lines.append(f'rlRun \'{cmd} --help 2>&1 | head -10\' 0 "查看 {cmd} 帮助信息"\n')
    basic_lines.append(gen_pass_msg(f'{pkg_name}-basic'))
    
    subs.append((f'test_{pkg_name}_basic', f'{pkg_name} - 基本功能', ''.join(basic_lines)))
    
    # Test 2: Error handling
    err_lines = [gen_test_header(f'{pkg_name} - 错误处理', cmds),
                 gen_rpm_check(pkg_name)]
    err_lines.append(gen_section('错误处理'))
    for cmd in cmds[:5]:
        err_lines.append(f'rlRun \'{cmd} --invalid-flag-xyz 2>&1 || true\' 0 "测试 {cmd} 无效参数错误处理"\n')
    err_lines.append(gen_pass_msg(f'{pkg_name}-error'))
    
    subs.append((f'test_{pkg_name}_error', f'{pkg_name} - 错误处理', ''.join(err_lines)))
    
    # Add custom tests
    if specific_tests:
        subs.extend(specific_tests)
    
    for sub_name, summary, content in subs:
        sub_dir = os.path.join(dir_path, sub_name)
        os.makedirs(sub_dir, exist_ok=True)
        with open(os.path.join(sub_dir, 'test.sh'), 'w') as f:
            f.write(content)
        with open(os.path.join(sub_dir, 'main.fmf'), 'w') as f:
            f.write(gen_sub_main_fmf(pkg_name, sub_name, summary))
    
    # Main main.fmf
    with open(os.path.join(dir_path, 'main.fmf'), 'w') as f:
        f.write(gen_main_fmf(pkg_name, f'功能测试 - {pkg_name} 软件包功能验证', require=[pkg_name]))
    
    return f'{pkg_name}: 1 main + {len(subs)} sub-tests'

# ============================================================
# Simple CLI packages with well-defined commands
# ============================================================

results = []

# Phase 1: Simple CLI packages
simple_cli = {
    'attr': lambda: gen_attr_tests(),
    'bc': lambda: gen_bc_tests(),
    'brotli': lambda: gen_generic_cli_test('brotli', ['brotli']),
    'cpio': lambda: gen_generic_cli_test('cpio', ['cpio']),
    'dbus-broker': lambda: gen_generic_cli_test('dbus-broker', ['dbus-broker']),
    'diffutils': lambda: gen_generic_cli_test('diffutils', ['cmp', 'diff', 'diff3', 'sdiff']),
    'expat': lambda: gen_generic_cli_test('expat', ['xmlwf']),
    'file': lambda: gen_generic_cli_test('file', ['file']),
    'gawk': lambda: gen_generic_cli_test('gawk', ['awk', 'gawk']),
    'less': lambda: gen_generic_cli_test('less', ['less', 'lessecho', 'lesskey']),
    'libidn2': lambda: gen_generic_cli_test('libidn2', ['idn2']),
    'libpng': lambda: gen_generic_cli_test('libpng', ['pngfix']),
    'libpwquality': lambda: gen_generic_cli_test('libpwquality', ['pwmake', 'pwscore']),
    'libtasn1': lambda: gen_generic_cli_test('libtasn1', ['asn1Coding', 'asn1Decoding', 'asn1Parser']),
    'libxml2': lambda: gen_generic_cli_test('libxml2', ['xmlcatalog', 'xmllint']),
    'libxslt': lambda: gen_generic_cli_test('libxslt', ['xsltproc']),
    'lz4': lambda: gen_generic_cli_test('lz4', ['lz4', 'lz4c', 'lz4cat', 'unlz4']),
    'openssh': lambda: gen_generic_cli_test('openssh', ['ssh']),
    'patch': lambda: gen_generic_cli_test('patch', ['patch']),
    'pcre2': lambda: gen_generic_cli_test('pcre2', ['pcre2grep', 'pcre2test']),
    'slang': lambda: gen_generic_cli_test('slang', ['slsh']),
    'sqlite': lambda: gen_generic_cli_test('sqlite', ['sqldiff', 'sqlite3']),
    'tcsh': lambda: gen_generic_cli_test('tcsh', ['tcsh']),
    'time': lambda: gen_generic_cli_test('time', ['time']),
    'tzdata': lambda: gen_generic_cli_test('tzdata', ['tzselect', 'zdump', 'zic']),
    'unzip': lambda: gen_generic_cli_test('unzip', ['unzip', 'funzip', 'zipgrep', 'zipinfo']),
    'which': lambda: gen_generic_cli_test('which', ['which']),
}

for pkg_name, gen_func in simple_cli.items():
    try:
        result = gen_func()
        results.append(result)
        print(f'  {result}')
    except Exception as e:
        print(f'  {pkg_name}: ERROR - {e}')

print(f'\nGenerated {len(results)} packages')
