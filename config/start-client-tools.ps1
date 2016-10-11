$PEClientToolsPath = 'C:\Program Files\Puppet Labs\Client'
$PEClientToolsBinPath = "$($PEClientToolsPath)\bin"

If (-not (Test-Path -Path $PEClientToolsBinPath)) {
  Write-Warning "Could not locate the PE Client Tools at '$($PEClientToolsPath)'"
  return
}

Write-Host "Use C:\vagrant\generate-client-tools-token.bat to generate an access token!"

Start-Process -FilePath "cmd.exe" -Argument @('/k',"`"$($PEClientToolsBinPath)\pe_client_shell.bat`"") | Out-Null
