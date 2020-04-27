$sourceVCConn = Connect-VIServer -Server 192.168.179.140 -user administrator@vsphere.local -password Vmware@123
$sourceVCConn = Connect-VIServer -Server 192.168.179.141 -user administrator@vsphere.local -password Vmware@123
Get-VM 'webserver-1' -Server $sourceVCConn
Get-VM 'webserver-1' -Server $sourceVCConn | Out-File -FilePath sourceVMcompute.json
Get-Datastore -Name 'datastore1'
Get-Datastore -Name 'datastore1' | Out-File -FilePath sourcevmdatastore.json
Get-Cluster -Name 'FMO' | Get-VMHost 
Get-Cluster -Name 'FMO' | Get-VMHost | Out-File -FilePath destinationhost.json
