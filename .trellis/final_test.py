import paramiko, os, time

SERVER = '10.20.237.192'
PORT = 12055
USER = 'openruyi'
PASS = 'openruyi'
BASE = 'e:/code/openruyi-autotest/tests/functional'

packages = sorted([d for d in os.listdir(BASE)
                   if os.path.isdir(os.path.join(BASE, d)) and
                   os.path.isfile(os.path.join(BASE, d, 'test.sh'))])
print(f'Found {len(packages)} test packages')

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=15)

# Upload all
for pkg in packages:
    sftp = ssh.open_sftp()
    sftp.put(os.path.join(BASE, pkg, 'test.sh'), f'/home/openruyi/{pkg}_test.sh')
    sftp.chmod(f'/home/openruyi/{pkg}_test.sh', 0o755)
    sftp.close()
ssh.exec_command('rm -f /home/openruyi/*_result.log')
print('Uploaded all\n')

results = {}
batch_size = 5
total_batches = (len(packages) + batch_size - 1) // batch_size

for i in range(0, len(packages), batch_size):
    batch = packages[i:i+batch_size]
    n = i // batch_size + 1
    print(f'Batch {n}/{total_batches}: {", ".join(batch)}')
    
    for pkg in batch:
        ssh.exec_command(f'chmod +x /home/openruyi/{pkg}_test.sh; nohup timeout 240 bash /home/openruyi/{pkg}_test.sh > /home/openruyi/{pkg}_result.log 2>&1 &')
    
    time.sleep(120)
    
    for pkg in batch:
        stdin, stdout, stderr = ssh.exec_command(f'grep -c "tests passed" /home/openruyi/{pkg}_result.log 2>/dev/null || echo 0')
        text = stdout.read().decode().strip().split('\n')[0]
        results[pkg] = 'PASS' if text == '1' else 'FAIL'
    
    passed = sum(1 for p in batch if results.get(p) == 'PASS')
    print(f'  -> {passed}/{len(batch)} passed\n')

ssh.close()

# Final table
print('=' * 72)
print(f'{"Package":<26} {"Status":<8} {"Category"}')
print('-' * 72)

categories = {
    'gcc': 'Compiler', 'gxx': 'Compiler', 'clang': 'Compiler', 'cmake': 'Compiler', 'make': 'Compiler',
    'systemd': 'System', 'systemd-timesyncd': 'System',
    'coreutils': 'File', 'tar': 'File', 'grep': 'File', 'acl': 'File',
    'procps-ng': 'Process', 'psmisc': 'Process',
    'iputils': 'Network', 'wget': 'Network', 'wget2': 'Network',
    'podman': 'Container', 'podmansh': 'Container',
    'openssh': 'SSH', 'openssh-clients': 'SSH',
    'vim': 'Editor', 'git': 'VCS',
    'pciutils': 'Hardware', 'rpmbuild': 'Build',
    'sddm': 'Display', 'weston': 'Display', 'labwc': 'Display',
    'dnf5-plugins': 'Package', 'tmux': 'Utility', 'cloud-utils-growpart': 'Utility',
}

for pkg in packages:
    status = results.get(pkg, '?')
    cat = categories.get(pkg, 'Other')
    icon = 'PASS' if status == 'PASS' else 'FAIL'
    print(f'{pkg:<26} {icon:<8} {cat}')

passed = sum(1 for v in results.values() if v == 'PASS')
print('-' * 72)
print(f'Total: {passed}/{len(packages)} passed')
