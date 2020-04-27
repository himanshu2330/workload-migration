$destinationVCConn = Connect-VIServer -Server 192.168.179.141 -user administrator@vsphere.local -password Vmware@123
Get-Cluster -Name 'FMO' | Get-VMHost
Get-Datastore  
