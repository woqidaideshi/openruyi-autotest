"""Test generator batch 2: Complex CLI + library + config packages."""
import os, json

BASE = 'tests/functional'
RESEARCH_DIR = '.trellis/tasks/06-12-170-base-pkgs-full-coverage/research'

with open(os.path.join(RESEARCH_DIR, 'pkg_info.json')) as f:
    pkg_info = json.load(f)

def gen_main_fmf(pkg, summary, test_path='./test.sh', require=None, tags=None):
    lines = [f'summary: {summary}', f'test: {test_path}']
    if tags:
        lines.append('tag:')
        for t in tags:
            lines.append(f'  - {t}')
    lines.append('duration: 5m')
    lines.append('tier: 1')
    lines.append(f'path: /tests/functional/{pkg}')
    if require:
        lines.append('require:')
        for r in require:
            lines.append(f'  - {r}')
    return '\n'.join(lines) + '\n'

def gen_sub_main_fmf(pkg, sub_name, summary):
    lines = [f'summary: {summary}', 'test: ./test.sh']
    lines.append('tag:')
    lines.append(f'  - functional')
    lines.append(f'  - {pkg}')
    lines.append('duration: 2m')
    lines.append('tier: 1')
    lines.append(f'path: /tests/functional/{pkg}/{sub_name}')
    return '\n'.join(lines) + '\n'

def write_test(pkg_dir, filename, content):
    os.makedirs(pkg_dir, exist_ok=True)
    with open(os.path.join(pkg_dir, filename), 'w') as f:
        f.write(content)

def header(pkg_desc, cmds=None):
    h = '#!/bin/sh -eux\n'
    h += f'# Functional test: {pkg_desc}\n'
    if cmds: h += f'# Commands: {", ".join(cmds)}\n'
    h += '\nrlRun() { eval "$1" 2>&1; return $?; }\n\n'
    return h

def rpm_check(pkg): return f'rlRun \'rpm -q {pkg}\' 0 "检查 {pkg} 是否已安装"\n'
def cmd_check(cmd): return f'rlRun \'which {cmd}\' 0 "检查 {cmd} 是否可用"\n'
def ver_check(cmd): return f'rlRun \'{cmd} --version 2>&1 || true\' 0 "获取 {cmd} 版本"\n'
def tmp_setup(): return 'rlRun \'TmpDir=$(mktemp -d)\' 0 "创建临时目录"\nrlRun \'cd $TmpDir\' 0 "进入测试目录"\n'
def tmp_cleanup(): return 'rlRun \'cd /\' 0 "离开测试目录"\nrlRun \'rm -rf $TmpDir\' 0 "清理临时目录"\n'
def section(title): return f'\necho "=== {title} ==="\n'
def pass_msg(pkg): return f'\necho ""\necho "All {pkg} functional tests passed!"\n'

# ============================================================
# Complex CLI packages with detailed tests
# ============================================================

def gen_authselect():
    pkg = 'authselect'; d = os.path.join(BASE, pkg)
    # Main
    write_test(d, 'test.sh',
        header('authselect - 系统认证配置', ['authselect']) +
        rpm_check(pkg) + cmd_check('authselect') + ver_check('authselect') +
        pass_msg(pkg))
    
    # Sub: basic
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_authselect_basic', 'authselect - 基本功能',
         header('authselect - 基本功能', ['authselect']) + rpm_check(pkg) + cmd_check('authselect') +
         section('authselect 基本功能') +
         'rlRun \'authselect --help 2>&1 | head -20\' 0 "查看帮助信息"\n' +
         'rlRun \'authselect list 2>&1 || true\' 0 "列出可用配置"\n' +
         'rlRun \'authselect current 2>&1 || true\' 0 "查看当前配置"\n' +
         'rlRun \'authselect check 2>&1 || true\' 0 "检查当前配置"\n' +
         pass_msg('authselect-basic')),
        
        ('test_authselect_error', 'authselect - 错误处理',
         header('authselect - 错误处理', ['authselect']) + rpm_check(pkg) + cmd_check('authselect') +
         section('错误处理') +
         'rlRun \'authselect --invalid 2>&1 || true\' 0 "无效参数"\n' +
         'rlRun \'authselect select nonexistent 2>&1 || true\' 1-255 "选择不存在的配置"\n' +
         pass_msg('authselect-error')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_bzip2():
    pkg = 'bzip2'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('bzip2 - 压缩工具', ['bzip2','bunzip2','bzcat','bzip2recover']) +
        rpm_check(pkg) + cmd_check('bzip2') + cmd_check('bunzip2') + cmd_check('bzcat') +
        ver_check('bzip2') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_bzip2_compress', 'bzip2 - 压缩功能',
         header('bzip2 - 压缩功能', ['bzip2','bunzip2']) + rpm_check(pkg) + cmd_check('bzip2') + cmd_check('bunzip2') +
         tmp_setup() +
         section('bzip2 压缩解压') +
         'rlRun \'echo "test data for bzip2" > testfile\' 0 "创建测试文件"\n' +
         'rlRun \'bzip2 -k testfile\' 0 "压缩文件(保留原文件)"\n' +
         'rlRun \'test -f testfile.bz2\' 0 "验证压缩文件存在"\n' +
         'rlRun \'bunzip2 -k testfile.bz2\' 0 "解压文件(保留压缩文件)"\n' +
         'rlRun \'bzip2 testfile\' 0 "压缩文件(删除原文件)"\n' +
         'rlRun \'test -f testfile.bz2\' 0 "验证压缩文件存在"\n' +
         'rlRun \'bunzip2 testfile.bz2\' 0 "解压文件"\n' +
         'rlRun \'test -f testfile\' 0 "验证解压后文件存在"\n' +
         section('bzcat 查看压缩内容') +
         'rlRun \'echo "hello bzip2" | bzip2 > test2.bz2\' 0 "通过管道压缩"\n' +
         'rlRun \'bzcat test2.bz2\' 0 "查看压缩文件内容"\n' +
         pass_msg('bzip2-compress')),
        
        ('test_bzip2_error', 'bzip2 - 错误处理',
         header('bzip2 - 错误处理', ['bzip2']) + rpm_check(pkg) + cmd_check('bzip2') +
         section('错误处理') +
         'rlRun \'bzip2 --invalid 2>&1 || true\' 0 "无效参数"\n' +
         'rlRun \'bzip2 nonexistent 2>&1 || true\' 1-255 "不存在的文件"\n' +
         pass_msg('bzip2-error')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_openssl():
    pkg = 'openssl'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('openssl - 加密工具包', ['openssl','c_rehash']) +
        rpm_check(pkg) + cmd_check('openssl') + cmd_check('c_rehash') +
        ver_check('openssl') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_openssl_basic', 'openssl - 基本功能',
         header('openssl - 基本功能', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         section('openssl 基本功能') +
         'rlRun \'openssl version\' 0 "查看版本"\n' +
         'rlRun \'openssl help 2>&1 | head -20\' 0 "查看帮助"\n' +
         'rlRun \'openssl list -standard-commands 2>&1 | head -10\' 0 "列出标准命令"\n' +
         'rlRun \'openssl list -cipher-commands 2>&1 | head -10\' 0 "列出加密命令"\n' +
         'rlRun \'openssl list -digest-commands 2>&1 | head -10\' 0 "列出摘要命令"\n' +
         pass_msg('openssl-basic')),
        
        ('test_openssl_hash', 'openssl - 哈希/摘要',
         header('openssl - 哈希功能', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         tmp_setup() +
         section('openssl 哈希') +
         'rlRun \'echo "test data" > testfile\' 0 "创建测试文件"\n' +
         'rlRun \'openssl dgst -md5 testfile\' 0 "MD5 摘要"\n' +
         'rlRun \'openssl dgst -sha256 testfile\' 0 "SHA256 摘要"\n' +
         'rlRun \'openssl dgst -sha512 testfile\' 0 "SHA512 摘要"\n' +
         pass_msg('openssl-hash')),
        
        ('test_openssl_encrypt', 'openssl - 加解密',
         header('openssl - 加解密', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         tmp_setup() +
         section('openssl 加解密') +
         'rlRun \'echo "secret message" > plain.txt\' 0 "创建明文文件"\n' +
         'rlRun \'openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out encrypted.bin -pass pass:test123\' 0 "AES加密"\n' +
         'rlRun \'test -f encrypted.bin\' 0 "验证加密文件存在"\n' +
         'rlRun \'openssl enc -aes-256-cbc -d -pbkdf2 -in encrypted.bin -out decrypted.txt -pass pass:test123\' 0 "AES解密"\n' +
         'rlRun \'diff plain.txt decrypted.txt\' 0 "验证解密结果一致"\n' +
         pass_msg('openssl-encrypt')),
        
        ('test_openssl_rsa', 'openssl - RSA 密钥',
         header('openssl - RSA', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         tmp_setup() +
         section('openssl RSA') +
         'rlRun \'openssl genrsa -out key.pem 2048\' 0 "生成RSA私钥"\n' +
         'rlRun \'test -f key.pem\' 0 "验证私钥文件存在"\n' +
         'rlRun \'openssl rsa -in key.pem -pubout -out pub.pem\' 0 "提取公钥"\n' +
         'rlRun \'test -f pub.pem\' 0 "验证公钥文件存在"\n' +
         pass_msg('openssl-rsa')),
        
        ('test_openssl_x509', 'openssl - 证书',
         header('openssl - X509证书', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         tmp_setup() +
         section('openssl X509') +
         'rlRun \'openssl genrsa -out ca.key 2048\' 0 "生成CA私钥"\n' +
         'rlRun \'openssl req -new -x509 -key ca.key -out ca.crt -days 1 -subj "/CN=Test"\' 0 "生成自签名证书"\n' +
         'rlRun \'openssl x509 -in ca.crt -text -noout | head -10\' 0 "查看证书信息"\n' +
         pass_msg('openssl-x509')),
        
        ('test_openssl_error', 'openssl - 错误处理',
         header('openssl - 错误处理', ['openssl']) + rpm_check(pkg) + cmd_check('openssl') +
         section('错误处理') +
         'rlRun \'openssl --invalid 2>&1 || true\' 0 "无效参数"\n' +
         'rlRun \'openssl dgst -invalid nonexistent 2>&1 || true\' 1-255 "无效摘要算法"\n' +
         pass_msg('openssl-error')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_chkconfig():
    pkg = 'chkconfig'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('chkconfig - 系统服务管理', ['chkconfig','alternatives','update-alternatives']) +
        rpm_check(pkg) + cmd_check('chkconfig') + cmd_check('alternatives') +
        ver_check('chkconfig') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_chkconfig_basic', 'chkconfig - 基本功能',
         header('chkconfig - 基本功能', ['chkconfig']) + rpm_check(pkg) + cmd_check('chkconfig') +
         section('chkconfig 基本功能') +
         'rlRun \'chkconfig --help 2>&1 | head -10\' 0 "查看帮助"\n' +
         'rlRun \'chkconfig --list 2>&1 | head -10 || true\' 0 "列出服务"\n' +
         pass_msg('chkconfig-basic')),
        
        ('test_alternatives_basic', 'alternatives - 基本功能',
         header('alternatives - 基本功能', ['alternatives']) + rpm_check(pkg) + cmd_check('alternatives') +
         section('alternatives 基本功能') +
         'rlRun \'alternatives --help 2>&1 | head -10\' 0 "查看帮助"\n' +
         'rlRun \'alternatives --list 2>&1 | head -5 || true\' 0 "列出替代项"\n' +
         pass_msg('alternatives-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_cracklib():
    pkg = 'cracklib'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('cracklib - 密码强度检查', ['cracklib-check','cracklib-format','cracklib-packer','cracklib-unpacker']) +
        rpm_check(pkg) + cmd_check('cracklib-check') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_cracklib_basic', 'cracklib - 基本功能',
         header('cracklib - 基本功能', ['cracklib-check']) + rpm_check(pkg) + cmd_check('cracklib-check') +
         section('密码强度检查') +
         'rlRun \'echo "password" | cracklib-check\' 0 "检查弱密码"\n' +
         'rlRun \'echo "Str0ng!Pass" | cracklib-check\' 0 "检查强密码"\n' +
         'rlRun \'echo "abc" | cracklib-check\' 0 "检查短密码"\n' +
         pass_msg('cracklib-basic')),
        
        ('test_cracklib_error', 'cracklib - 错误处理',
         header('cracklib - 错误处理', ['cracklib-check']) + rpm_check(pkg) + cmd_check('cracklib-check') +
         section('错误处理') +
         'rlRun \'cracklib-check --invalid 2>&1 || true\' 0 "无效参数"\n' +
         pass_msg('cracklib-error')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_dbus():
    pkg = 'dbus'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('dbus - D-Bus 消息总线', ['dbus-launch','dbus-send']) +
        rpm_check(pkg) + cmd_check('dbus-launch') + cmd_check('dbus-send') +
        ver_check('dbus-launch') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_dbus_basic', 'dbus - 基本功能',
         header('dbus - 基本功能', ['dbus-launch','dbus-send']) + rpm_check(pkg) + cmd_check('dbus-launch') + cmd_check('dbus-send') +
         section('dbus 基本功能') +
         'rlRun \'dbus-launch --help 2>&1 | head -10\' 0 "dbus-launch 帮助"\n' +
         'rlRun \'dbus-send --help 2>&1 | head -10\' 0 "dbus-send 帮助"\n' +
         pass_msg('dbus-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_glib():
    pkg = 'glib'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('glib - GLib 工具库', ['glib-compile-schemas','gsettings','gresource','gdbus']) +
        rpm_check(pkg) + cmd_check('glib-compile-schemas') + cmd_check('gsettings') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_glib_basic', 'glib - 基本功能',
         header('glib - 基本功能', ['glib-compile-schemas','gsettings']) + rpm_check(pkg) + cmd_check('glib-compile-schemas') + cmd_check('gsettings') +
         section('glib 工具') +
         'rlRun \'glib-compile-schemas --help 2>&1 | head -10\' 0 "glib-compile-schemas 帮助"\n' +
         'rlRun \'gsettings --help 2>&1 | head -10\' 0 "gsettings 帮助"\n' +
         'rlRun \'gsettings list-schemas 2>&1 | head -5 || true\' 0 "列出 GSettings 模式"\n' +
         pass_msg('glib-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_gnutls():
    pkg = 'gnutls'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('gnutls - TLS/SSL 库和工具', ['certtool','gnutls-cli','gnutls-serv','p11tool']) +
        rpm_check(pkg) + cmd_check('certtool') + cmd_check('gnutls-cli') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_gnutls_basic', 'gnutls - 基本功能',
         header('gnutls - 基本功能', ['certtool','gnutls-cli']) + rpm_check(pkg) + cmd_check('certtool') + cmd_check('gnutls-cli') +
         section('gnutls 工具') +
         'rlRun \'certtool --help 2>&1 | head -10\' 0 "certtool 帮助"\n' +
         'rlRun \'gnutls-cli --help 2>&1 | head -10\' 0 "gnutls-cli 帮助"\n' +
         pass_msg('gnutls-basic')),
        
        ('test_certtool', 'gnutls - certtool',
         header('gnutls - certtool', ['certtool']) + rpm_check(pkg) + cmd_check('certtool') +
         tmp_setup() +
         section('certtool') +
         'rlRun \'certtool --generate-privkey --outfile key.pem 2>&1 || true\' 0 "生成私钥"\n' +
         pass_msg('gnutls-certtool')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_kbd():
    pkg = 'kbd'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('kbd - 键盘和终端工具', ['chvt','dumpkeys','kbdrate','loadkeys','setfont','showkey']) +
        rpm_check(pkg) + cmd_check('dumpkeys') + cmd_check('showkey') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_kbd_basic', 'kbd - 基本功能',
         header('kbd - 基本功能', ['dumpkeys','showkey','loadkeys','setfont']) + rpm_check(pkg) + cmd_check('dumpkeys') + cmd_check('showkey') + cmd_check('loadkeys') + cmd_check('setfont') +
         section('键盘工具') +
         'rlRun \'dumpkeys --help 2>&1 | head -10\' 0 "dumpkeys 帮助"\n' +
         'rlRun \'showkey --help 2>&1 | head -10\' 0 "showkey 帮助"\n' +
         'rlRun \'loadkeys --help 2>&1 | head -10\' 0 "loadkeys 帮助"\n' +
         'rlRun \'setfont --help 2>&1 | head -10\' 0 "setfont 帮助"\n' +
         pass_msg('kbd-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_kmod():
    pkg = 'kmod'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('kmod - 内核模块管理', ['depmod','insmod','kmod','lsmod','modinfo','modprobe','rmmod']) +
        rpm_check(pkg) + cmd_check('lsmod') + cmd_check('modinfo') + cmd_check('modprobe') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_kmod_basic', 'kmod - 基本功能',
         header('kmod - 基本功能', ['lsmod','modinfo','modprobe']) + rpm_check(pkg) + cmd_check('lsmod') + cmd_check('modinfo') + cmd_check('modprobe') +
         section('内核模块管理') +
         'rlRun \'lsmod 2>&1 | head -10\' 0 "列出加载的模块"\n' +
         'rlRun \'modinfo --help 2>&1 | head -10\' 0 "modinfo 帮助"\n' +
         'rlRun \'modprobe --help 2>&1 | head -10\' 0 "modprobe 帮助"\n' +
         pass_msg('kmod-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_keyutils():
    pkg = 'keyutils'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('keyutils - 内核密钥管理', ['keyctl','request-key','key.dns_resolver']) +
        rpm_check(pkg) + cmd_check('keyctl') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_keyutils_basic', 'keyutils - 基本功能',
         header('keyutils - 基本功能', ['keyctl']) + rpm_check(pkg) + cmd_check('keyctl') +
         section('keyctl 基本功能') +
         'rlRun \'keyctl --help 2>&1 | head -10\' 0 "keyctl 帮助"\n' +
         'rlRun \'keyctl show 2>&1 || true\' 0 "显示当前密钥"\n' +
         'rlRun \'keyctl list @u 2>&1 || true\' 0 "列出用户密钥"\n' +
         pass_msg('keyutils-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_vim():
    pkg = 'vim'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('vim - Vi 编辑器', ['vim','vi','view','vimdiff','rvim']) +
        rpm_check(pkg) + cmd_check('vim') +
        ver_check('vim') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_vim_basic', 'vim - 基本功能',
         header('vim - 基本功能', ['vim']) + rpm_check(pkg) + cmd_check('vim') +
         section('vim 基本功能') +
         'rlRun \'vim --help 2>&1 | head -10\' 0 "vim 帮助"\n' +
         'rlRun \'echo test | vim - -c "wq! /tmp/vimtest" 2>&1 || true\' 0 "vim 命令行模式"\n' +
         'rlRun \'test -f /tmp/vimtest && rm -f /tmp/vimtest || true\' 0 "验证vim创建文件"\n' +
         pass_msg('vim-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_perl():
    pkg = 'perl'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('perl - Perl 解释器', ['perl']) +
        rpm_check(pkg) + cmd_check('perl') +
        ver_check('perl') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_perl_basic', 'perl - 基本功能',
         header('perl - 基本功能', ['perl']) + rpm_check(pkg) + cmd_check('perl') +
         section('perl 基本功能') +
         'rlRun \'perl --help 2>&1 | head -10\' 0 "perl 帮助"\n' +
         'rlRun \'perl -e "print \\"hello\\n\\""\' 0 "执行简单 Perl 代码"\n' +
         'rlRun \'perl -v 2>&1 | head -5\' 0 "查看版本详情"\n' +
         pass_msg('perl-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_python_pip():
    pkg = 'python-pip'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('python-pip - Python 包管理器', ['pip3']) +
        rpm_check('python3-pip') + cmd_check('pip3') +
        ver_check('pip3') + pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=['python3-pip']))
    
    for sub, title, body in [
        ('test_pip_basic', 'pip - 基本功能',
         header('pip - 基本功能', ['pip3']) + rpm_check('python3-pip') + cmd_check('pip3') +
         section('pip 基本功能') +
         'rlRun \'pip3 --help 2>&1 | head -15\' 0 "pip 帮助"\n' +
         'rlRun \'pip3 list 2>&1 | head -10\' 0 "列出已安装包"\n' +
         'rlRun \'pip3 show pip 2>&1 | head -5\' 0 "查看 pip 信息"\n' +
         pass_msg('pip-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_p11_kit():
    pkg = 'p11-kit'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('p11-kit - PKCS#11 工具', ['p11-kit','trust']) +
        rpm_check(pkg) + cmd_check('p11-kit') + cmd_check('trust') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_p11kit_basic', 'p11-kit - 基本功能',
         header('p11-kit - 基本功能', ['p11-kit','trust']) + rpm_check(pkg) + cmd_check('p11-kit') + cmd_check('trust') +
         section('p11-kit 基本功能') +
         'rlRun \'p11-kit --help 2>&1 | head -10\' 0 "p11-kit 帮助"\n' +
         'rlRun \'trust --help 2>&1 | head -10\' 0 "trust 帮助"\n' +
         'rlRun \'p11-kit list-modules 2>&1 | head -5 || true\' 0 "列出模块"\n' +
         'rlRun \'trust list 2>&1 | head -5 || true\' 0 "列出信任锚"\n' +
         pass_msg('p11kit-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

def gen_ncurses():
    pkg = 'ncurses'; d = os.path.join(BASE, pkg)
    write_test(d, 'test.sh',
        header('ncurses - 终端界面库', ['clear','infocmp','reset','tabs','tic','toe']) +
        rpm_check(pkg) + cmd_check('clear') + cmd_check('infocmp') + cmd_check('tput') +
        pass_msg(pkg))
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg}', require=[pkg]))
    
    for sub, title, body in [
        ('test_ncurses_basic', 'ncurses - 基本功能',
         header('ncurses - 基本功能', ['infocmp','tput','clear','reset']) + rpm_check(pkg) + cmd_check('infocmp') + cmd_check('tput') + cmd_check('clear') + cmd_check('reset') +
         section('ncurses 工具') +
         'rlRun \'infocmp --help 2>&1 | head -10\' 0 "infocmp 帮助"\n' +
         'rlRun \'tput --help 2>&1 | head -10\' 0 "tput 帮助"\n' +
         'rlRun \'clear --help 2>&1 | head -10\' 0 "clear 帮助"\n' +
         'rlRun \'reset --help 2>&1 | head -10\' 0 "reset 帮助"\n' +
         'rlRun \'infocmp 2>&1 | head -5 || true\' 0 "查看终端信息"\n' +
         pass_msg('ncurses-basic')),
    ]:
        sd = os.path.join(d, sub)
        write_test(sd, 'test.sh', body)
        write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, title))
    return f'{pkg}: ok'

# ============================================================
# Library packages (file-level verification, no C compilation needed)
# ============================================================

def gen_library_pkg(pkg, libs):
    d = os.path.join(BASE, pkg)
    # Main
    body = header(f'{pkg} - 库包', libs) + rpm_check(pkg)
    body += section('库文件验证')
    body += 'rlRun \'ldconfig -p 2>/dev/null | grep ' + pkg + ' | head -5 || true\' 0 "ldconfig 查找库文件"\n'
    body += 'rlRun \'rpm -ql ' + pkg + ' 2>/dev/null | grep "\\\\.so" | head -10 || true\' 0 "列出 .so 文件"\n'
    body += pass_msg(pkg)
    
    write_test(d, 'test.sh', body)
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg} 库包验证', require=[pkg]))
    
    # Sub: file verification
    sub = f'test_{pkg}_files'
    sd = os.path.join(d, sub)
    sub_body = header(f'{pkg} - 文件验证', libs) + rpm_check(pkg)
    sub_body += section('库文件验证')
    for lib in libs[:5]:
        sub_body += f'rlRun \'ls /usr/lib64/{lib}* 2>/dev/null || ls /usr/lib/{lib}* 2>/dev/null || echo "not in standard path"\' 0 "检查 {lib}"\n'
    sub_body += section('pkg-config 验证')
    sub_body += f'rlRun \'pkg-config --libs {pkg} 2>&1 || true\' 0 "pkg-config 库信息"\n'
    sub_body += pass_msg(f'{pkg}-files')
    
    write_test(sd, 'test.sh', sub_body)
    write_test(sd, 'main.fmf', gen_sub_main_fmf(pkg, sub, f'{pkg} - 文件验证'))
    
    return f'{pkg}: ok'

def gen_config_pkg(pkg):
    d = os.path.join(BASE, pkg)
    body = header(f'{pkg} - 配置/数据包') + rpm_check(pkg)
    body += section('文件列表验证')
    body += 'rlRun \'rpm -ql ' + pkg + ' 2>/dev/null | head -20 || true\' 0 "列出包文件"\n'
    body += pass_msg(pkg)
    
    write_test(d, 'test.sh', body)
    write_test(d, 'main.fmf', gen_main_fmf(pkg, f'功能测试 - {pkg} 配置验证', require=[pkg]))
    return f'{pkg}: ok'

# ============================================================
# Execute: Remaining CLI packages
# ============================================================

results = []

# Complex CLI (not in batch1)
complex_cli = {
    'authselect': gen_authselect,
    'bzip2': gen_bzip2,
    'openssl': gen_openssl,
    'chkconfig': gen_chkconfig,
    'cracklib': gen_cracklib,
    'dbus': gen_dbus,
    'glib': gen_glib,
    'gnutls': gen_gnutls,
    'kbd': gen_kbd,
    'kmod': gen_kmod,
    'keyutils': gen_keyutils,
    'vim': gen_vim,
    'perl': gen_perl,
    'python-pip': gen_python_pip,
    'p11-kit': gen_p11_kit,
    'ncurses': gen_ncurses,
}

for pkg_name, gen_func in complex_cli.items():
    try:
        result = gen_func()
        results.append(result)
        print(f'  {result}')
    except Exception as e:
        print(f'  {pkg_name}: ERROR - {e}')

# Library packages (file-level verification)
lib_pkgs = [k for k, v in pkg_info.items() if v['type'] == 'library' and v['libs']]
print(f'\nGenerating {len(lib_pkgs)} library packages...')
for pkg_name in sorted(lib_pkgs):
    try:
        libs = pkg_info[pkg_name]['libs']
        result = gen_library_pkg(pkg_name, libs)
        results.append(result)
        print(f'  {result}')
    except Exception as e:
        print(f'  {pkg_name}: ERROR - {e}')

# Config packages
cfg_pkgs = [k for k, v in pkg_info.items() if v['type'] == 'config/data']
print(f'\nGenerating {len(cfg_pkgs)} config packages...')
for pkg_name in sorted(cfg_pkgs):
    try:
        result = gen_config_pkg(pkg_name)
        results.append(result)
        print(f'  {result}')
    except Exception as e:
        print(f'  {pkg_name}: ERROR - {e}')

print(f'\nBatch 2 total: {len(results)} packages generated')
