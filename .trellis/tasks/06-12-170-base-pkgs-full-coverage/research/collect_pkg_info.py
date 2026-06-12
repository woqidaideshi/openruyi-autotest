"""Research all packages on server - collect commands, libs, services, headers."""
import paramiko, json

SERVER='10.20.237.192'; PORT=12055; USER='openruyi'; PASS='openruyi'

pkgs = [
    'sqlite','libpng','popt','lz4','bzip2','unzip','gdbm','openssl',
    'slang','p11-kit','libffi','ncurses','cracklib','pcre2','libsepol',
    'python-rpm-macros','kbd','libpwquality','gnutls','rpm','dbus',
    'expat','libgcrypt','file','which','patch','nghttp2','libunistring',
    'libeconf','libcap','libcap-ng','json-c','jitterentropy','cpio',
    'publicsuffix-list','openruyi-release','libidn2','readline','tzdata',
    'libxml2','dbus-broker','authselect','python-srpm-macros','unbound',
    'gcc16','binutils','gawk','diffutils','libarchive','attr','libtool',
    'libxcrypt','chkconfig','setup','libgpg-error','automake','lvm2',
    'libpsl','libtasn1','libevent','python-pip','perl-rpm-packaging',
    'perl','autoconf','bash-completion','gdb','perl-Locale-gettext',
    'help2man','groff','systemtap','texinfo','flex','bison','meson',
    'ninja','re2c','beakerlib','kyua','kmod','pyproject-rpm-macros',
    'python-rpm-generators','config','rsync','cmocka','brotli','atf',
    'ed','gpm','fdupes','libsodium','libedit','swig','dejagnu','xxhash',
    'iso-codes','libmicrohttpd','boost','source-highlight','glib','xmlto',
    'libssh','git','bc','nfs-utils','iproute2','vim','chrpath','expect',
    'lzip','icu4c','python-packaging','libxslt','tcsh','perl-Error',
    'time','tcl','lutok','libbpf','libmnl','python-setuptools',
    'python-flit-core','iptables','scdoc','python-lxml','e2fsprogs',
    'libnftnl','libpcap','libnetfilter_conntrack','libnl','libnfnetlink',
    'libtirpc','krb5','keyutils','less','openssh','python-wheel',
    'dos2unix','pam_wrapper','uid_wrapper','nss_wrapper',
    'socket_wrapper','gobject-introspection','libseccomp',
    'python-pyelftools','nss','libaio'
]

print(f'Connecting to {SERVER}:{PORT}...')
ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect(SERVER, port=PORT, username=USER, password=PASS, timeout=60)
print('Connected.')

results = {}
for pkg in sorted(pkgs):
    info = {'name': pkg, 'type': 'unknown', 'cmds': [], 'libs': [], 'services': [], 'headers': [], 'all_bins': []}
    
    # Get package files
    stdin, stdout, stderr = ssh.exec_command(f'rpm -ql {pkg} 2>/dev/null || echo NOT_FOUND', timeout=15)
    files = stdout.read().decode().strip()
    if 'NOT_FOUND' in files:
        info['type'] = 'not_installed'
        results[pkg] = info
        print(f'  {pkg}: NOT INSTALLED')
        continue
    
    # Analyze files
    for line in files.split('\n'):
        line = line.strip()
        if not line:
            continue
        if '/bin/' in line or '/sbin/' in line:
            cmd = line.split('/')[-1]
            if cmd and cmd not in info['cmds']:
                info['cmds'].append(cmd)
                info['all_bins'].append(line)
        elif line.endswith('.so') or '.so.' in line:
            lib = line.split('/')[-1]
            if lib not in info['libs']:
                info['libs'].append(lib)
        elif '/include/' in line and line.endswith('.h'):
            hdr = '/'.join(line.split('/include/')[-1:])
            info['headers'].append(hdr)
    
    # Check for systemd services
    stdin, stdout, stderr = ssh.exec_command(f'rpm -ql {pkg} 2>/dev/null | grep -E "\\.service|\\.socket|\\.target" | head -10', timeout=10)
    svcs = stdout.read().decode().strip()
    if svcs:
        info['services'] = [s.split('/')[-1] for s in svcs.split('\n') if s.strip()]
    
    # Determine type
    if info['cmds']:
        info['type'] = 'cli'
    elif info['libs']:
        info['type'] = 'library'
    elif info['services']:
        info['type'] = 'service'
    else:
        info['type'] = 'config/data'
    
    results[pkg] = info
    print(f'  {pkg}: type={info["type"]}, cmds={len(info["cmds"])}, libs={len(info["libs"])}, svcs={len(info["services"])}')

ssh.close()

# Save results
outpath = '.trellis/tasks/06-12-170-base-pkgs-full-coverage/research/pkg_info.json'
with open(outpath, 'w') as f:
    json.dump(results, f, indent=2)

# Summary
cli_count = sum(1 for v in results.values() if v['type']=='cli')
lib_count = sum(1 for v in results.values() if v['type']=='library')
svc_count = sum(1 for v in results.values() if v['type']=='service')
cfg_count = sum(1 for v in results.values() if v['type']=='config/data')
nf_count = sum(1 for v in results.values() if v['type']=='not_installed')
print(f'\nSummary: CLI={cli_count}, Library={lib_count}, Service={svc_count}, Config={cfg_count}, NotInstalled={nf_count}')
print(f'Total: {len(results)}')
print(f'Output: {outpath}')
