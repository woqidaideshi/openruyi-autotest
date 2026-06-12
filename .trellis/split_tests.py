"""Split test.sh into individual test case directories per section."""
import os, re, shutil

BASE = 'tests/functional'

packages = sorted([d for d in os.listdir(BASE)
                   if os.path.isdir(os.path.join(BASE, d)) and
                   os.path.isfile(os.path.join(BASE, d, 'test.sh'))])

stats = {'total_cases': 0, 'packages': 0}

for pkg in packages:
    pkg_dir = os.path.join(BASE, pkg)
    test_file = os.path.join(pkg_dir, 'test.sh')
    
    with open(test_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract shebang, rlRun, and shared setup
    lines = content.split('\n')
    header = []     # shebang + rlRun function
    setup = []      # commands between header and first section
    sections = []
    current_section = []
    in_section = False
    in_setup = False
    
    for line in lines:
        if re.match(r'echo\s+"=== (Test|测试)\s+\d+', line):
            if current_section and in_section:
                sections.append(current_section)
            current_section = [line]
            in_section = True
            in_setup = False  # stop collecting setup
        elif in_section:
            current_section.append(line)
        elif not in_section:
            if '#!/' in line or '# Functional test' in line or '# Version:' in line:
                header.append(line)
            elif 'rlRun()' in line and '{' in line:
                header.append(line)
                in_setup = True  # start collecting setup after rlRun def
            elif in_setup and line.strip():
                if not line.strip().startswith('#'):
                    setup.append(line)
    
    # Add last section
    if current_section:
        sections.append(current_section)
    
    if len(sections) <= 1:
        print(f'  SKIP {pkg}: only {len(sections)} section(s), keeping as-is')
        continue

    
    # Build header + setup strings
    header_str = '\n'.join(header).strip()
    setup_str = '\n'.join(setup).strip()
    
    # Save original
    backup_dir = os.path.join(pkg_dir, '_original')
    os.makedirs(backup_dir, exist_ok=True)
    shutil.copy2(test_file, os.path.join(backup_dir, 'test.sh'))
    shutil.copy2(os.path.join(pkg_dir, 'main.fmf'), os.path.join(backup_dir, 'main.fmf'))
    
    # Create sub-directories
    case_names = []
    for i, section in enumerate(sections):
        # Generate case name from section title
        section_text = '\n'.join(section)
        title_match = re.search(r'echo\s+"===\s*(?:Test|测试)\s+\d+:?\s*(.+?)(?:\s*===)?"', section_text)
        if title_match:
            case_name = re.sub(r'[^a-zA-Z0-9\u4e00-\u9fff_-]', '-', title_match.group(1).strip()).strip('-')[:50]
        else:
            case_name = f'case-{i+1:02d}'
        
        # Deduplicate
        orig = case_name
        n = 1
        while case_name in case_names:
            case_name = f'{orig}-{n}'
            n += 1
        case_names.append(case_name)
        
        case_dir = os.path.join(pkg_dir, case_name)
        os.makedirs(case_dir, exist_ok=True)
        
        # Don't duplicate TmpDir setup if already in setup
        needs_tmp = 'mktemp' not in setup_str
        tmp_setup = '\nTmpDir=$(mktemp -d)\ncd $TmpDir' if needs_tmp else ''
        tmp_clean = '\ncd /\nrm -rf $TmpDir' if needs_tmp else ''
        
        final_content = f'''#!/bin/sh -eux
# Functional test: {pkg} - {case_name}

rlRun() {{ eval "$1" 2>&1; return $?; }}
{setup_str}{tmp_setup}

{section_text}{tmp_clean}

echo ""
echo "All {pkg} {case_name} tests passed!"
'''
        with open(os.path.join(case_dir, 'test.sh'), 'w', encoding='utf-8') as f:
            f.write(final_content)
        
        # Write main.fmf
        with open(os.path.join(case_dir, 'main.fmf'), 'w', encoding='utf-8') as f:
            f.write(f'''summary: 功能测试 - {pkg} - {title_match.group(1).strip() if title_match else case_name}
test: ./test.sh
tag:
  - functional
  - {pkg}
duration: 2m
tier: 1
path: /tests/functional/{pkg}/{case_name}
require:
  - {pkg}
''')
    
    stats['total_cases'] += len(sections)
    stats['packages'] += 1
    print(f'  SPLIT {pkg}: {len(sections)} cases -> {case_names[:3]}...')

print(f'\nSummary: {stats["packages"]} packages split, {stats["total_cases"]} total cases')
