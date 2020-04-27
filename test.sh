#!/bin/bash
V_ticket=`cat request.txt | awk -F "," '{print $1}'`
for i in ${V_ticket[@]}
do
  touch ${i}.yaml
  echo "Request: $i">>${i}.yaml
  VM=`cat request.txt | awk -F "vm_to_be_migrated':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "VM_list: [$VM]">>${i}.yaml
  source_vcenter_url=`cat request.txt | awk -F "source_vcenter_url':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "source_vcenter_url: $source_vcenter_url">>${i}.yaml
  destination_vcenter_url=`cat request.txt | awk -F "destination_vcenter_url':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "destination_vcenter_url: $destination_vcenter_url">>${i}.yaml
  source_vcenter_cluster=`cat request.txt | awk -F "source_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "source_vcenter_cluster: $source_vcenter_cluster">>${i}.yaml
  destination_vcenter_cluster=`cat request.txt | awk -F "destination_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "destination_vcenter_cluster: $destination_vcenter_cluster">>${i}.yaml
done
for i in ${V_ticket[@]}
do
ansible-playbook display_data.yaml --extra-vars="myvarfile=${i}.yaml"
done



for i in ${V_ticket[@]}
do
ansible-playbook create_report.yaml --extra-vars="myvarfile=${i}.yaml"
done


#####COmparing CPU  and Memory of VM whether its good for migration or not#########
echo""
echo "Comparing CPU  and Memory of VM whether its good for migration or not"
Destination_cluster_avaiable_memory=`cat report/destination_host_memory_info.json | grep "Available Memroy" | awk -F " " '{print $5}'`
echo "Destination_cluster_avaiable_memory(GB): $Destination_cluster_avaiable_memory"
echo""
echo""
Destination_cluster_avaiable_cpu=`cat report/destination_host_memory_info.json | grep 'Available CPU' | awk -F " " '{print $5}'`
echo "Destination_cluster_avaiable_cpu(Mhz): $Destination_cluster_avaiable_cpu"
echo""
echo""
Memory_requirement_for_VM_migration=`cat report/sourceVMcompute.json | grep memcache-1 | awk -F ' ' '{print $4}'`
echo "Memory_requirement_for_VM_migration(GB): $Memory_requirement_for_VM_migration"
echo""
echo""
#CPU_requirement_for_VM_migration=`cat report/sourceVMcompute.json | grep memcache-1 | awk -F ' ' '{print $3}'`
#echo " VM cpu assigned (number of cores): $CPU_requirement_for_VM_migration"
#echo""
#echo""
echo "Comparing memory for migration:"
if [ ${Memory_requirement_for_VM_migration%%.*} -lt ${Destination_cluster_avaiable_memory%%.*} ]
then
echo""
echo""
echo "VM memory is suitable for migration"
else
echo "VM memory is not suitable for migration"
exit 0
fi
#if [ ${CPU_requirement_for_VM_migration%%.*} -lt ${Destination_cluster_avaiable_cpu%%.*} ]
#then
#echo""
#echo""
#echo "VM cpu is suitable for migration"
#else
#echo "VM cpu is not suitable for migration"
#exit 0
#fi
echo ""
echo "CPU and Memory is good for Migration starting migration"

###################Starting Migration##############################################
for i in ${V_ticket[@]}
do
ansible-playbook migrate.yaml --extra-vars="myvarfile=${i}.yaml"
done




