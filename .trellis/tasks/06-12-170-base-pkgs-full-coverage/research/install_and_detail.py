"""Phase 2 research: Install missing pkgs + collect detailed command help for CLI pkgs."""
import paramiko, json, time

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'

# Load existing research
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_info.json') as f:
    pkg_info = json.load(f)

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

# 1. Install missing packages
missing = [k for k, v in pkg_info.items() if v['type'] == 'not_installed']
print(f'Installing {len(missing)} missing packages...')
if missing:
    batch = ' '.join(missing)
    cmd = f'echo openruyi | sudo -S dnf install -y {batch} 2>&1 | tail -20'
    stdin, stdout, stderr = ssh.exec_command(cmd, timeout=300)
    print(stdout.read().decode()[-500:])

# 2. Update pkg_info for newly installed packages
for pkg in missing:
    stdin, stdout, stderr = ssh.exec_command(f'rpm -ql {pkg} 2>/dev/null || echo NOT_FOUND', timeout=15)
    files = stdout.read().decode().strip()
    if 'NOT_FOUND' in files:
        continue
    
    info = pkg_info[pkg]
    info['type'] = 'unknown'
    info['cmds'] = []
    info['libs'] = []
    info['all_bins'] = []
    
    for line in files.split('\n'):
        line = line.strip()
        if not line: continue
        if '/bin/' in line or '/sbin/' in line:
            cmd = line.split('/')[-1]
            if cmd and cmd not in info['cmds']:
                info['cmds'].append(cmd)
                info['all_bins'].append(line)
        elif line.endswith('.so') or '.so.' in line:
            lib = line.split('/')[-1]
            if lib not in info['libs']:
                info['libs'].append(lib)
    
    if info['cmds']:
        info['type'] = 'cli'
    elif info['libs']:
        info['type'] = 'library'
    else:
        info['type'] = 'config/data'
    print(f'  {pkg}: type={info["type"]}, cmds={len(info["cmds"])}')

# 3. Collect --help for all CLI commands
cli_pkgs = [(k, v) for k, v in pkg_info.items() if v['type'] == 'cli']
print(f'\nCollecting --help for {len(cli_pkgs)} CLI packages...')

detail_info = {}
for pkg_name, info in cli_pkgs:
    pkg_detail = {'name': pkg_name, 'cmds': {}}
    
    for cmd in info['cmds'][:20]:  # Max 20 commands per package
        # Get --help
        stdin, stdout, stderr = ssh.exec_command(f'{cmd} --help 2>&1 | head -40', timeout=10)
        help_text = stdout.read().decode().strip()
        
        # Get version
        stdin, stdout, stderr = ssh.exec_command(f'{cmd} --version 2>&1 | head -3', timeout=10)
        ver_text = stdout.read().decode().strip()
        
        pkg_detail['cmds'][cmd] = {
            'help': help_text[:2000],
            'version': ver_text[:500]
        }
        print(f'  {pkg_name}/{cmd}: help={len(help_text)} chars')
    
    detail_info[pkg_name] = pkg_detail

# 4. Collect pkg-config and header info for library packages
lib_pkgs = [(k, v) for k, v in pkg_info.items() if v['type'] == 'library']
print(f'\nCollecting library info for {len(lib_pkgs)} library packages...')

for pkg_name, info in lib_pkgs:
    if pkg_name not in detail_info:
        detail_info[pkg_name] = {'name': pkg_name, 'cmds': {}}
    
    # Check pkg-config
    stdin, stdout, stderr = ssh.exec_command(f'pkg-config --list-all 2>/dev/null | grep -i {pkg_name} | head -5', timeout=10)
    pc_info = stdout.read().decode().strip()
    if pc_info:
        detail_info[pkg_name]['pkgconfig'] = pc_info
    
    # Check headers
    stdin, stdout, stderr = ssh.exec_command(f'rpm -ql {pkg_name}-devel 2>/dev/null | grep "include/" | head -10', timeout=10)
    hdrs = stdout.read().decode().strip()
    if hdrs:
        detail_info[pkg_name]['devel_headers'] = hdrs
    
    print(f'  {pkg_name}: pkgconfig={bool(pc_info)}, devel={bool(hdrs)}')

# Save detailed info
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_detail.json', 'w') as f:
    json.dump(detail_info, f, indent=2)

# Save updated pkg_info
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_info.json', 'w') as f:
    json.dump(pkg_info, f, indent=2)

ssh.close()

# Final summary
cli_count = sum(1 for v in pkg_info.values() if v['type']=='cli')
lib_count = sum(1 for v in pkg_info.values() if v['type']=='library')
cfg_count = sum(1 for v in pkg_info.values() if v['type']=='config/data')
nf_count = sum(1 for v in pkg_info.values() if v['type']=='not_installed')
print(f'\nFinal Summary: CLI={cli_count}, Library={lib_count}, Config={cfg_count}, StillMissing={nf_count}')
print(f'Total: {len(pkg_info)}')
