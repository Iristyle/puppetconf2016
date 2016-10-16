if (! (Test-Path $PROFILE))
{

@"
function subl { &"`${Env:ProgramFiles}\Sublime Text 2\sublime_text.exe" `$args }
# function subl { &"`${Env:ProgramFiles}\Sublime Text 3\sublime_text.exe" `$args }

Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadlineKeyHandler -Key Tab -Function Complete

# Chocolatey profile
`$ChocolateyProfile = "`$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path(`$ChocolateyProfile)) {
  Import-Module "`$ChocolateyProfile"
}
"@ | Out-File $PROFILE
}

choco install -y ethanbrown.gitaliases --version 0.0.5 --limit-output

choco install -y sourcecodepro --version 2.030.0 --limit-output

choco install -y conemu --version 16.10.9.1 --limit-output
choco install -y ethanbrown.conemuconfig --version 0.0.5 --limit-output

choco install -y sublimetext2 --version 2.0.2.2221 --allow-empty-checksums --limit-output
# # editorpackages is broken
# # choco install -y ethanbrown.sublimetext2.editorpackages --version 0.2.2 --limit-output

# TODO: something here is breaking ability to `vagrant rdp`
# choco install -y notepadplusplus.install --version 7.1 --limit-output
# choco install -y diffmerge --version 4.2.0.697 --limit-output
# choco install -y ethanbrown.gitconfiguration --version 0.0.4 --limit-output
# choco install -y poshgit --limit-output


# # TODO: setup SourceCodePro in ST2
