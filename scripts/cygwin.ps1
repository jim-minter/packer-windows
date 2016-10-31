$client = New-Object System.Net.WebClient

### Install Cygwin
$client.DownloadFile("https://cygwin.com/setup-x86_64.exe", "C:\Windows\Temp\setup-x86_64.exe")
&C:\Windows\Temp\setup-x86_64.exe -q -D -L -d -o -s http://mirrors.kernel.org/sourceware/cygwin -l C:\Windows\Temp\cygwin -R C:\cygwin -P grep -P openssh -P rsync | Out-Null
Remove-Item -Recurse C:\Windows\Temp\cygwin
Remove-Item C:\Windows\Temp\setup-x86_64.exe
$env:Path += ";C:\cygwin\bin"

# Configure OpenSSH
&bash -c "ssh-host-config --yes -w Vagrant01$"

# Copy /etc/skel to /home/vagrant
Out-Null | &bash --login

# Start OpenSSH and open firewall
&cygrunsrv -S sshd
&netsh advfirewall firewall add rule "name=Port 22" profile=any localport=22 enable=yes action=allow dir=in protocol=tcp
