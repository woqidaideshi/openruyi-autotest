"""Phase 2 research v2: Install + collect command help with timeouts."""
import paramiko, json, time, socket

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'

with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_info.json') as f:
    pkg_info = json.load(f)

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)

# 1. Install missing packages (excluding source-only ones)
source_only = {'gdbm', 'python-rpm-generators'}
missing = [k for k, v in pkg_info.items() if v['type'] == 'not_installed' and k not in source_only]
print(f'Installing {len(missing)} missing packages (excluding source-only)...')
if missing:
    batch = ' '.join(missing)
    cmd = f'echo openruyi | sudo -S dnf install -y {batch} 2>&1 | tail -30'
    try:
        stdin, stdout, stderr = ssh.exec_command(cmd, timeout=600)
        out = stdout.read().decode()
        err = stderr.read().decode()
        print(out[-500:])
        if err:
            print(f'STDERR: {err[-300:]}')
    except Exception as e:
        print(f'Install error: {e}')

# 2. Update pkg_info for newly installed
for pkg in missing:
    try:
        stdin, stdout, stderr = ssh.exec_command(f'rpm -ql {pkg} 2>/dev/null || echo NOT_FOUND', timeout=15)
        files = stdout.read().decode().strip()
        if 'NOT_FOUND' in files:
            continue
        
        info = pkg_info[pkg]
        info['type'] = 'unknown'; info['cmds'] = []; info['libs'] = []; info['all_bins'] = []
        
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
        
        if info['cmds']: info['type'] = 'cli'
        elif info['libs']: info['type'] = 'library'
        else: info['type'] = 'config/data'
        print(f'  {pkg}: type={info["type"]}')
    except Exception as e:
        print(f'  {pkg}: error - {e}')

# 3. Collect --help for CLI commands (with channel timeout)
def exec_cmd_timeout(ssh, cmd, timeout=10):
    """Execute command with timeout."""
    try:
        stdin, stdout, stderr = ssh.exec_command(cmd, timeout=timeout)
        # Set channel timeout
        stdout.channel.settimeout(timeout)
        stderr.channel.settimeout(timeout)
        out = stdout.read().decode(errors='replace').strip()
        err = stderr.read().decode(errors='replace').strip()
        return out, err
    except Exception as e:
        return f'TIMEOUT/ERROR: {e}', ''

cli_pkgs = [(k, v) for k, v in pkg_info.items() if v['type'] == 'cli']
print(f'\nCollecting --help for {len(cli_pkgs)} CLI packages...')

detail_info = {}
for pkg_name, info in cli_pkgs:
    pkg_detail = {'name': pkg_name, 'cmds': {}}
    
    for cmd in info['cmds'][:25]:
        help_out, _ = exec_cmd_timeout(ssh, f'{cmd} --help 2>&1 | head -30', timeout=8)
        ver_out, _ = exec_cmd_timeout(ssh, f'{cmd} --version 2>&1 | head -3', timeout=5)
        
        pkg_detail['cmds'][cmd] = {
            'help': help_out[:1500] if help_out else '',
            'version': ver_out[:300] if ver_out else ''
        }
    
    detail_info[pkg_name] = pkg_detail
    total_cmds = len([c for c in pkg_detail['cmds'] if pkg_detail['cmds'][c]['help']])
    print(f'  {pkg_name}: {total_cmds}/{len(info["cmds"])} cmds with help')

# 4. Library info
lib_pkgs = [(k, v) for k, v in pkg_info.items() if v['type'] == 'library']
print(f'\nCollecting library info for {len(lib_pkgs)} packages...')

for pkg_name, info in lib_pkgs:
    if pkg_name not in detail_info:
        detail_info[pkg_name] = {'name': pkg_name, 'cmds': {}}
    
    pc_out, _ = exec_cmd_timeout(ssh, f'pkg-config --list-all 2>/dev/null | grep -i {pkg_name} | head -5', timeout=10)
    if pc_out:
        detail_info[pkg_name]['pkgconfig'] = pc_out
    
    hdr_out, _ = exec_cmd_timeout(ssh, f'rpm -ql {pkg_name}-devel 2>/dev/null | grep "include/" | head -10', timeout=10)
    if hdr_out:
        detail_info[pkg_name]['devel_headers'] = hdr_out
    
    print(f'  {pkg_name}: pc={bool(pc_out)}, devel={bool(hdr_out)}')

# 5. Config/data packages
cfg_pkgs = [(k, v) for k, v in pkg_info.items() if v['type'] == 'config/data']
print(f'\nCollecting config info for {len(cfg_pkgs)} packages...')
for pkg_name, info in cfg_pkgs:
    if pkg_name not in detail_info:
        detail_info[pkg_name] = {'name': pkg_name, 'cmds': {}}
    
    files_out, _ = exec_cmd_timeout(ssh, f'rpm -ql {pkg_name} 2>/dev/null | head -20', timeout=10)
    detail_info[pkg_name]['files'] = files_out[:1000]
    print(f'  {pkg_name}: ok')

# Save
with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_detail.json', 'w') as f:
    json.dump(detail_info, f, indent=2, ensure_ascii=False)

with open('.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_info.json', 'w') as f:
    json.dump(pkg_info, f, indent=2)

ssh.close()

cli_count = sum(1 for v in pkg_info.values() if v['type']=='cli')
lib_count = sum(1 for v in pkg_info.values() if v['type']=='library')
cfg_count = sum(1 for v in pkg_info.values() if v['type']=='config/data')
nf_count = sum(1 for v in pkg_info.values() if v['type']=='not_installed')
print(f'\nFinal: CLI={cli_count}, Library={lib_count}, Config={cfg_count}, Missing={nf_count}')
