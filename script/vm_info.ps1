
param
(
  [Parameter(Mandatory=$True,Position=1)]
  [string]$VM
)
#$VM=$args[0]
$VM= 'VirtualMachine-'+$VM
Connect-VIServer -Server 192.168.179.140 -User administrator@vsphere.local -Password Vmware@123 | Out-Null
$entities = Get-VM | Where-Object { $_.Id -eq $VM }

$start = (Get-Date).AddYears(-1)
echo $entities
$stat = 'cpu.usagemhz.average','mem.usage.average'

 

Get-Stat -Entity $entities -Stat $stat -Start $start -ErrorAction SilentlyContinue |

Group-Object -Property {$_.Entity.Name} |

Select @{N='VM';E={$_.Name}},

    @{N='CPU(Mhz)';E={($_.Group | Where{$_.MetricId -eq 'cpu.usagemhz.average' -and $_.Instance -eq ''} | Measure-Object -Property Value -Maximum | select -ExpandProperty Maximum) * 1.3 / 2500}},

    @{N='Mem';E={($_.Group | Where{$_.MetricId -eq 'mem.usage.average'} | Measure-Object -Property Value -Maximum | select -ExpandProperty Maximum) * 1.1}},

    @{N='MemAllocated(GB)';E={$_.Group[0].Entity.MemoryGB}},

    @{N='vCPU';E={$_.Group[0].Entity.NumCpu}} | Out-File -FilePath vminfo.json

