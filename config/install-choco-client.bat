@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco source add -n=%1 -s"http://%2/chocolatey/Packages"
choco apikey -s"http://%2/chocolatey/Packages" -k="%3"
