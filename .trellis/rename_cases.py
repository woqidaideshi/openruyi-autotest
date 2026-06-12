"""Rename test case dirs to test_{package}_{description} format."""
import os, re, shutil

BASE = 'tests/functional'

# Maps Chinese terms to English
CN2EN = {
    '版本和帮助': 'version-help', '错误处理': 'error-handling',
    '基本功能': 'basic', '高级功能': 'advanced',
    '基本替换': 'basic-substitution', '行操作': 'line-operations',
    '全局和正则': 'global-regex', '就地编辑': 'inplace-edit',
    '多表达式': 'multi-expression', '基本下载': 'basic-download',
    '输出选项': 'output-options', '详细模式和静默模式': 'verbose-quiet',
    '其他选项': 'other-options', '基本执行': 'basic-execution',
    '命令行选项': 'command-options', '脚本执行': 'script-execution',
    '模块导入': 'module-import', '基本脚本执行': 'basic-script',
    '变量和循环': 'variables-loops', '条件判断': 'conditionals',
    '管道和重定向': 'pipe-redirect', '函数': 'functions',
    '删除功能': 'remove', '符号链接处理': 'symlink',
    '递归功能': 'recursive', '命令功能': 'command',
    '权限验证': 'permission-verify', '继承测试': 'inheritance',
    '特殊场景': 'special-cases', '下载': 'download',
}

def to_english(name):
    """Convert mixed Chinese/English name to pure English."""
    # Already pure English?
    if all(ord(c) < 128 for c in name.replace('-', '')):
        return name.lower().replace(' ', '-')
    
    # Replace known Chinese terms
    for cn, en in sorted(CN2EN.items(), key=lambda x: -len(x[0])):
        name = name.replace(cn, en)
    
    # Remove remaining Chinese chars and special chars
    name = re.sub(r'[\u4e00-\u9fff]', '', name)
    name = re.sub(r'[^a-zA-Z0-9_-]', '-', name)
    name = re.sub(r'-{2,}', '-', name).strip('-')
    
    return name.lower() if name else 'test'

renamed = 0
for pkg_dir in sorted(os.listdir(BASE)):
    pkg_path = os.path.join(BASE, pkg_dir)
    if not os.path.isdir(pkg_path):
        continue
    
    for case_name in sorted(os.listdir(pkg_path)):
        case_path = os.path.join(pkg_path, case_name)
        if not os.path.isdir(case_path) or case_name.startswith('_'):
            continue
        
        # Build new name: test_{pkg}_{desc}
        eng_desc = to_english(case_name)
        new_name = f'test_{pkg_dir}_{eng_desc}'
        new_name = re.sub(r'_{2,}', '_', new_name)  # clean up double underscores
        new_name = new_name[:80]  # limit length
        
        if new_name != case_name:
            new_path = os.path.join(pkg_path, new_name)
            if os.path.exists(new_path):
                # Add suffix if duplicate
                n = 1
                while os.path.exists(f'{new_path}_{n}'):
                    n += 1
                new_path = f'{new_path}_{n}'
            shutil.move(case_path, new_path)
            renamed += 1
            print(f'  {pkg_dir}/{case_name} -> {new_name}')

print(f'\nRenamed {renamed} directories')
