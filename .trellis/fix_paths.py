"""Update path in main.fmf files to match renamed directories."""
import os

BASE = 'tests/functional'
updated = 0

for pkg_dir in os.listdir(BASE):
    pkg_path = os.path.join(BASE, pkg_dir)
    if not os.path.isdir(pkg_path): continue
    
    for case_dir in os.listdir(pkg_path):
        if not case_dir.startswith('test_'): continue
        fmf_path = os.path.join(pkg_path, case_dir, 'main.fmf')
        if not os.path.isfile(fmf_path): continue
        
        with open(fmf_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        new_path = f'/tests/functional/{pkg_dir}/{case_dir}'
        old_path = f'path: /tests/functional/{pkg_dir}/'
        
        if old_path in content:
            content = content.replace(
                f'path: /tests/functional/{pkg_dir}/',
                f'path: {new_path}\n'
            )
            with open(fmf_path, 'w', encoding='utf-8') as f:
                f.write(content)
            updated += 1

print(f'Updated {updated} main.fmf files')
