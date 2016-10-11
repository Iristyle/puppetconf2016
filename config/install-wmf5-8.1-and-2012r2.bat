sc config wuauserv start= demand
net start wuauserv
wusa.exe C:\vagrant\config\Win8.1AndW2K12R2-KB3134758-x64.msu /quiet /norestart
sc config wuauserv start= disabled

REM not necessary as we trigger a reboot later anyhow
REM net stop wuauserv
