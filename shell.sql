
# ------------------------------------------------------------------------------
# Shell Tips for Linux Server Administrators
# ------------------------------------------------------------------------------

# View system log
sudo cat /var/log/messages

# Kill process by PID
kill <PID>  # Use 'ps aux' or 'top' to identify PID

# TOP shortcuts
#   k - Kill process
#   M - Sort by memory
#   N - Sort by PID
#   r - Renice
#   h - Help
#   z - Color
#   d - Delay update
#   c - Show full path
#   x/y - Highlight sort/running
#   L,&,<,> - Locate/sort
#   CTRL+C or q - Quit

top

# Memory usage
free -h

# Tail logs
tail -100f <file>

# List files ordered by time
ls -ltrh

# Grep exact word
grep -w MAP *.prm

# Grep across files and return filenames
grep -l NODISCARDFILE *

# Fix backspace key issue
stty erase ^H

# View non-comment, non-empty lines
cat template.rsp | grep -v '^#' | grep '\\S'

# Show IP
ifconfig

# Directory size by depth
sudo du -mh --max-depth 1 /u01 | sort -n | grep G

# Check open port
netstat -putona | grep 7809

# Firewall commands
systemctl status firewalld
systemctl stop firewalld
firewall-cmd --add-port=7809/tcp --permanent
sudo firewall-cmd --list-ports

# Compare ignoring whitespace
diff -w file1 file2

# Remove directory recursively
rm -rf <dir>

# OS info
cat /etc/os-release
uname -m
hostnamectl

# sudoers example
# oracle ALL=(ALL) NOPASSWD:/bin/mkdir

# DNS cache cleanup (Windows)
ipconfig /flushdns
ipconfig /release
ipconfig /renew

# Which binary
which java

# IP address
ip addr

# Recover deleted file via open file descriptor
lsof -p <PID> | grep <filename>
cd /proc/<PID>/fd
ds -lrt
cat <fd> > /path/to/restore/file

# Docker resource usage
docker stats

# Read clean config file
cat file.rsp | grep -v "^#" | grep -v "^$"

# Clear OS buffer cache
echo 1 > /proc/sys/vm/drop_caches

# Add user/group
groupadd -g 501 oinstall
adduser oracle
useradd -d /home/oracle -u 500 -g oinstall -G oinstall -m -s /bin/bash oracle
usermod -aG oinstall oracle

# Confirm groups
groups oracle
cat /etc/group | grep oinstall
cat /etc/passwd | grep oracle

# SSH to alternate hosts
ssh user@host

# Find directory with special chars
find / -type d -name 'directory*name#?%'

# Mass substitution
find . -type f -exec sed -i 's/DADOS_/DATA_/gI' {} +

# Disk usage (top 20)
du -ah <path> | sort -nr | head -20

# Add datetime to history
export HISTTIMEFORMAT="%d/%m/%y %T "

# Create profile if missing
touch ~/.bash_profile
chmod +x ~/.bash_profile
echo "source ~/.bashrc" >> ~/.bash_profile

# SCP file Linux to Linux
scp /path/to/file user@ip:/path/to/dest

# SCP from Windows using PuTTY (pscp)
pscp -scp -i path\to\key.pem file user@ip:/path

# SCP Linux to Windows
scp -P <port> -i key.pem user@ip:/path/to/file C:\path\to\dest

# Compress/decompress
sudo tar -zcvf file.tar /dir
sudo tar -xvf file.tar -C /
tar -tzf file.tar

# Symbolic links
ln -s <target> <link>

# Timezone
export TZ=America/Sao_Paulo
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Remove lines containing word
sed -i -e "s|teste.*||g" file

# IPTABLES commands
iptables -L --line-numbers
iptables -I INPUT -p tcp --dport 7809 -j ACCEPT
iptables -D INPUT <rule>
iptables-legacy -L --line-numbers
iptables-legacy-save > /etc/iptables/rules.v4

# Shell Script conditionals
if [ ! -f file ]; then echo "missing"; fi
if [ ! -L link ]; then ln -s target link; fi
if [ ! -d dir ]; then echo "dir missing"; fi

# Remove file if exists
if [ -f "file.sql" ]; then rm "file.sql"; fi

# View logical volumes
sudo vgdisplay
sudo pvdisplay
lsblk

# Create fake files for test
fallocate -l 1G fakefile

# iperf3 speed test
iperf3 -s  # on target
iperf3 -c target_ip
iperf3 -c target_ip -n 1G
iperf3 -c target_ip -n 1G -R  # reverse

# Test transfer speed via ssh
# (source --> destination)
dd if=/dev/zero bs=1M count=1024 | ssh user@ip "dd of=/dev/null status=progress"

# CPU Info
lscpu

# Disk I/O and performance
vmstat 1 100
iostat 1 100

# Windows info
msinfo32
wmic memorychip get speed

# Kernel log grep
sudo grep -r "<pattern>" /var/log

# Map dm-X devices
sudo dmsetup ls
dmsetup info /dev/dm-X
sudo lvdisplay | awk '/LV Name/{n=$3} /Block device/{d=$3; sub(".*:","dm-",d); print d,n;}'

# X11 forwarding setup
xauth merge /home/user/.Xauthority
xeyes

# Systemd service management
systemctl list-units --all
systemctl edit --full <service>
systemctl daemon-reload
systemctl enable <service>
systemctl start <service>
systemctl status <service>

# Hostname change
hostnamectl set-hostname new_name
reboot

# Crontab
sudo yum install cronie -y  # or dnf for Ubuntu
sudo crond
crontab -e
crontab -l

# Validate multiple file existence (bash array)
files=(file1.sql file2.sql)
for f in "${files[@]}"; do
  [ -f "$f" ] && echo "$f ok" || echo "$f missing"
done

# Search pattern in Windows (like grep -iR)
findstr /S /I /C:"pattern" *

# How to update ssh configurations without losing current connection:
echo "DenyUsers oracle" >> /etc/ssh/sshd_config
kill -HUP $(pgrep -o sshd)
sed -i "s|DenyUsers oracle||g" /etc/ssh/sshd_config
kill -HUP $(pgrep -o sshd)