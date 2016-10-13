$PEClientToolsPath = 'C:\Program Files\Puppet Labs\Client'
$PEClientToolsBinPath = "$($PEClientToolsPath)\bin"

If (-not (Test-Path -Path $PEClientToolsBinPath)) {
  Write-Warning "Could not locate the PE Client Tools at '$($PEClientToolsPath)'"
  return
}

function Get-Batchfile ($file)
{
  Write-Host "Executing batch file $file to parse environment variables"
  $cmd = "`"$file`" & set"
  cmd /c $cmd | % {
    $p, $v = $_.split('=')
    Set-Item -path env:$p -value $v
  }
}

function Import-ClientToolsEnvironment()
{
  $name = "Parsed-PEClient-Environment"
  $readVersion = Get-Variable -Scope Global -Name $name `
    -ErrorAction SilentlyContinue

  # continually jamming stuff into PATH is *not* cool ;0
  if ($readVersion) { return }

  $BatchFile = Join-Path $PEClientToolsBinPath 'environment.bat'
  Push-Location $PEClientToolsPath
  Get-Batchfile $BatchFile
  Set-Variable -Scope Global -Name $name -Value $true
  Pop-Location
}

Import-ClientToolsEnvironment
Set-Location $PEClientToolsPath

Write-Host "Use C:\vagrant\generate-client-tools-token.bat to generate an access token!"

# # Start-Process -FilePath "cmd.exe" -Argument @('/k',"`"$($PEClientToolsBinPath)\pe_client_shell.bat`"") | Out-Null
