:: vagrant public key
mkdir c:\cygwin\home\vagrant\.ssh
if exist a:\vagrant.pub (
  copy a:\vagrant.pub c:\cygwin\home\vagrant\.ssh\authorized_keys
) else (
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub', 'c:\cygwin\home\vagrant\.ssh\authorized_keys')" <NUL
)
