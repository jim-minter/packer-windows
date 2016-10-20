$client = New-Object System.Net.WebClient

### Install Cygwin
$client.DownloadFile("https://cygwin.com/setup-x86_64.exe", "C:\Windows\Temp\setup-x86_64.exe")
&C:\Windows\Temp\setup-x86_64.exe -q -D -L -d -o -s http://mirrors.kernel.org/sourceware/cygwin -l C:\Windows\Temp\cygwin -R C:\cygwin -P git -P grep -P make -P openssh -P rsync | Out-Null
Remove-Item -Recurse C:\Windows\Temp\cygwin
Remove-Item C:\Windows\Temp\setup-x86_64.exe
$env:Path += ";C:\cygwin\bin"

# Configure OpenSSH
&bash -c "ssh-host-config --yes -w Vagrant01$"

# Copy /etc/skel to /home/vagrant
Out-Null | &bash --login

### Install Golang
$client.DownloadFile("https://storage.googleapis.com/golang/go1.7.1.windows-amd64.msi", "C:\Windows\Temp\go1.7.1.windows-amd64.msi")
&msiexec /qb /i C:\Windows\Temp\go1.7.1.windows-amd64.msi | Out-Null
Remove-Item C:\Windows\Temp\go1.7.1.windows-amd64.msi

$stream = New-Object System.IO.StreamWriter @("c:\cygwin\home\vagrant\.bash_profile", $true)
$stream.Write("export GOPATH='c:\cygwin\home\vagrant\go'`n")
$stream.Close()

### Install Docker client
$client.DownloadFile("https://get.docker.com/builds/Windows/x86_64/docker-1.10.3.exe", "C:\cygwin\usr\local\bin\docker.exe")

### Install JRE
$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, "oraclelicense=accept-securebackup-cookie")
$client.DownloadFile("http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jre-8u112-windows-x64.exe", "C:\Windows\Temp\jre-8u112-windows-x64.exe")

$stream = [System.IO.StreamWriter] "C:\Windows\Temp\java.settings.cfg"
$stream.WriteLine("INSTALL_SILENT=1")
$stream.Close()

&C:\Windows\Temp\jre-8u112-windows-x64.exe INSTALLCFG=C:\Windows\Temp\java.settings.cfg | Out-Null

Remove-Item C:\Windows\Temp\java.settings.cfg
Remove-Item C:\Windows\Temp\jre-8u112-windows-x64.exe

# Start OpenSSH and open firewall
&cygrunsrv -S sshd
&netsh advfirewall firewall add rule "name=Port 22" profile=any localport=22 enable=yes action=allow dir=in protocol=tcp
