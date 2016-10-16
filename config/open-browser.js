var navOpenInBackgroundTab = 0x1000;
var objIE = new ActiveXObject("InternetExplorer.Application");

objIE.Visible = true;
objIE.Navigate2("https://davis-master.vm");
objIE.Navigate2("http://win2012-choco", navOpenInBackgroundTab);
objIE.Navigate2("http://loadbalancer.vm:9000", navOpenInBackgroundTab);
objIE.Navigate2("http://loadbalancer.vm", navOpenInBackgroundTab);
objIE.Navigate2("https://github.com/puppetlabs/puppetlabs-app_modeling", navOpenInBackgroundTab);
objIE.Navigate2("http://win2012-web-green-1", navOpenInBackgroundTab);
objIE.Navigate2("http://win2012-web-green-2", navOpenInBackgroundTab);
objIE.Navigate2("http://win2012-web-blue-1", navOpenInBackgroundTab);
objIE.Navigate2("http://win2012-web-blue-2", navOpenInBackgroundTab);

