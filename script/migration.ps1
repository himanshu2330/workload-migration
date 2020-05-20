$sourceVCConn = Connect-VIServer -Server xx.xx.xx.xx -user administrator@vsphere.local -password Vmware@123
$destVCConn = Connect-VIServer -Server xx.xx.xx.xx -user administrator@vsphere.local -password Vmware@123
$vm = Get-VM redis-1 -Server $sourceVCConn
$networkAdapter = Get-NetworkAdapter -VM $vm -Server $sourceVCConn
$destination = Get-VMHost -Server $destVCConn
$virtualSwitch = Get-VirtualSwitch -VMHost xx.xx.xx.xx -Name vSwitch0
#$virtualSwitch = Get-VirtualSwitch -Name vSwitch0
$destinationPortGroup = Get-VirtualPortGroup -VirtualSwitch $virtualSwitch -Name 'VM Network' -Server $destVCConn
$destinationDatastore = Get-Datastore -Name 'datastore1' -Server $destVCConn
Move-VM -VM $vm -Destination $destination -NetworkAdapter $networkAdapter -PortGroup $destinationPortGroup -Datastore $destinationDatastore
