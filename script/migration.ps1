$sourceVCConn = Connect-VIServer -Server 192.168.179.140 -user administrator@vsphere.local -password Vmware@123
$destVCConn = Connect-VIServer -Server 192.168.179.141 -user administrator@vsphere.local -password Vmware@123
$vm = Get-VM database-1 -Server $sourceVCConn
$networkAdapter = Get-NetworkAdapter -VM $vm -Server $sourceVCConn
$destination = Get-VMHost -Server $destVCConn
#$virtualSwitch = Get-VirtualSwitch -VMHost 192.168.179.137 -Name vSwitch0
$virtualSwitch = Get-VirtualSwitch
$destinationPortGroup = Get-VirtualPortGroup -VirtualSwitch $virtualSwitch -Name 'VM Network' -Server $destVCConn
$destinationDatastore = Get-Datastore -Name 'datastore1' -Server $destVCConn
Move-VM -VM $vm -Destination $destination -NetworkAdapter $networkAdapter -PortGroup $destinationPortGroup -Datastore $destinationDatastore
