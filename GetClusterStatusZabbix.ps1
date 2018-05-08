<#
    GetClusterStatusZabbix.ps1
    Updated: 2018-05-08
    Author: Justin Doles
    Requires: PowerShell 5.1 or higher, Internet Explorer 11 or higher
#>
<#
.SYNOPSIS
Monitors the status of the cluster and returns a value usable by Zabbix

.DESCRIPTION
Monitors the status of the cluster and returns a value usable by Zabbix

.EXAMPLE
None

.NOTES
MUST execute IE once as the user who runs this script or you'll receive the error below:
    System.NotSupportedException: The response content cannot be parsed because the Internet Explorer engine is not available, 
    or Internet Explorer's first-launch configuration is not complete. Specify the UseBasicParsing parameter and try again.
If running as LocalSytem - psexec -s -i "%programfiles%\Internet Explorer\iexplore.exe"
#>
try {
    $response = Invoke-WebRequest "http://localhost:9200/_cluster/health"
    $status = 0
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        $status = $json.status
    } else {
        $status = "Unexpected response "+$response.StatusCode
    }
    return $status
} catch {
    $e = $_.Exception.GetType().Name
    return $e
}