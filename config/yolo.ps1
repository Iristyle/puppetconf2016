# git reset --hard final-orchestration~$Count
git push origin production
puppet-code deploy --all --wait

Write-Host 'Waiting 5 seconds for master to update code'
Start-Sleep -Seconds 5
puppet-app show

puppet-job run --application Puppylabs_app['puppylabs']
