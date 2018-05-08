# Elasticsearch Monitoring for Zabbix
Put simply these scripts monitor Elasticsearch cluster status and reports the results to Zabbix.

## Requirements
Elasticsearch 2.x or higher - https://www.elastic.co/products/elasticsearch
Powershell 5.1 or higher (Windows scripts only) - https://www.microsoft.com/en-us/download/details.aspx?id=54616
Zabbix 3.x or higher - https://www.zabbix.com/

## Configuration
### Windows
You will need to install Powershell 5.1 or higher to use the scripts.
Additionally, you will need to run IE once as the user you run the Zabbix Agent as.  By default this is LocalSystem.  You can use PsExec (https://docs.microsoft.com/en-us/sysinternals/downloads/psexec) to accomplish this: psexec -s -i "%programfiles%\Internet Explorer\iexplore.exe"


### Zabbix Agent
This guide assumes you have installed the Zabbix Agent to c:\Program Files\Zabbix.
- Add zabbix_agentd.userparams.conf to the conf directory in the ZAbbix Agent installation directory. e.g. c:\Program Files\Zabbix\conf\zabbix_agentd.userparams.conf
- Edit your zabbix_agentd.win.conf file.  Find the "### Option: Include" section and add Include=C:\Program Files\Zabbix\conf\zabbix_agentd.userparams.conf
- Restart the Zabbix Agent

### Zabbix Server
You will need to import the Zabbix_Item_Template.xml file into your Zabbix server.  This will configure the required items in Zabbix.
See https://www.zabbix.com/documentation/3.2/manual/xml_export_import for detailed help.

