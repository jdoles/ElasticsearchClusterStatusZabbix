<#
    GetNodeInfo.ps1
    Updated: 2018-10-11
    Author: Justin Doles
    Requires: PowerShell 5.1 or higher, Internet Explorer 11 or higher
#>
<#
.SYNOPSIS
Monitors the status of the local node and returns the values to Zabbix

.DESCRIPTION
Monitors the status of the local node and returns the values to Zabbix

.EXAMPLE
None

.NOTES
MUST execute IE once as the user who runs this script or you'll receive the error below:
    System.NotSupportedException: The response content cannot be parsed because the Internet Explorer engine is not available, 
    or Internet Explorer's first-launch configuration is not complete. Specify the UseBasicParsing parameter and try again.
If running as LocalSytem - psexec -s -i "%programfiles%\Internet Explorer\iexplore.exe"
You may need to adjust the Timeout setting in your Zabbix agent config file to 30 seconds.  Otherwise you'll see periodic timeouts.
#>
Param ( 
	[Parameter(Mandatory=$True)]
    	[string]$Stat
)

try {
    $local = ($env:COMPUTERNAME).ToLower()
    $uri = "http://localhost:9200/_nodes/$local/stats/"
    $endpoint = 'none'
    switch ($Stat) {
        'search'{ $endpoint = 'indices' }
        'indexperf'{ $endpoint = 'indices' }
    }

    $response = Invoke-WebRequest $uri$endpoint
    $status = 0
    if ($response.StatusCode -eq 200) {
        $json = $response.Content | ConvertFrom-Json
        $node = $json.nodes.psobject.properties.name
        if ( $Stat = 'indexperf' ) {
            $status = [Math]::Round($json.nodes.($node).indices.indexing.index_total/($json.nodes.($node).indices.indexing.index_time_in_millis/1000),3)
        }

    } else {
        $status = "Unexpected response "+$response.StatusCode
    }
    return $status
} catch {
    $e = $_.Exception.GetType().Name
    return $e
}