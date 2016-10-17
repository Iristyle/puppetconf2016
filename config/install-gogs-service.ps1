[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]
  $ControlRepo
)
$ErrorActionPreference = 'Stop'

# https://gogs.io/docs/installation/run_as_windows_service
$vagrant_dir = 'C:\vagrant\config'

if (! (Test-Path c:\gogs))
{
  $archive = "$vagrant_dir\gogs_v0.9.97_windows_amd64_mws.zip"
  Write-Host "Extracting Gogs file - $archive"
  # Extract Zip
  # Assumes Choco already installed
  C:\ProgramData\Chocolatey\tools\7z.exe x $archive -oC:\

  # And copy in config
  $confdir = 'C:\gogs\custom\conf'
  New-Item $confdir -Type Directory
  # default settings are at
  # https://github.com/gogits/gogs/blob/master/conf/app.ini
  Copy-Item "$vagrant_dir\app.ini" "$confdir\app.ini"
}

Write-Host 'Opening Firewall Port 80'
netsh.exe  --% advfirewall firewall add rule name="Gogs Git Server" dir=in action=allow protocol=TCP localport=80

sc.exe query gogs | Out-Null
# if service does not exist
if ($LASTEXITCODE -ne 0)
{
  Write-Host "Creating gogs service as it does not exist"

  # create service
  sc.exe --% create gogs start= auto binPath= ""C:\gogs\gogs.exe" web --config "C:\gogs\custom\conf\app.ini""

  Write-Host 'Installing Git Dependency'
  choco install -y git --version 2.10.1 --limit-output

  Write-Host "Starting gogs service"
  Start-Service gogs
}

if (! (Test-Path 'c:\source')) { New-Item 'c:\source' -Type Directory }

Write-Host 'Configuring local git user'
$git = 'C:\Program Files\git\cmd\git.exe'
&$git config --global user.email "puppet@localhost.com"
&$git config --global user.name "puppet"

# HACK: pre-configure credentials for push to localhost gogs
Write-Host 'Setting up _netrc credentials'
@'
machine localhost
login puppet
password puppetlabs
'@ | Out-File ~/_netrc -Encoding ASCII

Write-Host 'Waiting for gogs to start listening'
do
{
  Write-Host 'Gogs API port not yet listening.. sleeping...'
  Start-Sleep -Milliseconds 500
} while ((Get-NetTCPConnection -State Listen -LocalPort @(80) -ErrorAction SilentlyContinue) -eq $null)


# NOTE: buy some extra time after HTTP is listening
# else the user creation might fail and prevent the rest of the process from working
if (! (Test-Path 'c:\source\controlrepo'))
{
  Write-Host "Cloning $ControlRepo locally to c:\source"
  Push-Location 'c:\source'

  &$git clone $ControlRepo controlrepo
  Pop-Location
}

# TODO: not sure how to query if user exists
# create default puppet user with puppetlabs password
Write-Host 'Generating puppet user within gogs'
choco install -y psexec --version 2.11 --limit-output --ignore-checksums
# this doesn't work without elevating / execing through psexec
psexec -u vagrant -p vagrant -h c:\gogs\gogs.exe admin create-user --name=puppet --password=puppetlabs --email=puppet --admin=true -c c:\gogs\custom\conf\app.ini

# create gogs repo for user && push cloned source to host
if (! (Test-Path 'c:\gogs-repos\puppet\controlrepo.git'))
{
  # get puppet user token
  $creds = "puppet:puppetlabs"
  $credsHeader = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(($creds)))

  # https://github.com/gogits/go-gogs-client/wiki
  Write-Host 'Generating token for puppet user'
  $request = @{
    Uri = 'http://localhost/api/v1/users/puppet/tokens'
    Method = 'Post'
    Headers = @{ Authorization = "Basic $credsHeader" }
    Body = @{ name = 'api' }
  }

  $response = Invoke-RestMethod @request

  Write-Host 'Generating controlrepo repo for puppet user'
  # create puppet user repo controlrepo with the gogs API
  $repoCreate = @{
    Uri = 'http://localhost/api/v1/admin/users/puppet/repos'
    Method = 'Post'
    Headers = @{ Authorization = "token $($response.sha1)" }
    Body = @{
      name = 'controlrepo'
      description = 'Code Manager Control Repo'
      private = $false
      auto_init = $false
    }
  }
  Invoke-RestMethod @repoCreate

  Write-Host 'Pushing control repo code up to local Git server'
  Push-Location 'c:\source\controlrepo'
  &$git remote set-url origin http://localhost/puppet/controlrepo
  &$git push origin production
  &$git checkout final-orchestration
  &$git push origin final-orchestration
  &$git remote add upstream $ControlRepo
  &$git checkout production
  Pop-Location
}
