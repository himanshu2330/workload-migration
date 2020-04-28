#!/bin/bash
V_ticket=`cat request.txt | awk -F "," '{print $1}'`
for i in ${V_ticket[@]}
do
  cp sample_request.json ${i}_request.json
  VM=`cat request.txt | awk -F "vm_to_be_migrated':" '{print $2}' | awk -F "'" '{print $2}'`
  source_vcenter_ip=`cat request.txt | awk -F "source_vcenter_ip':" '{print $2}' | awk -F "'" '{print $2}'`
  destination_vcenter_ip=`cat request.txt | awk -F "destination_vcenter_ip':" '{print $2}' | awk -F "'" '{print $2}'`
  source_vcenter_cluster=`cat request.txt | awk -F "source_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  destination_vcenter_cluster=`cat request.txt | awk -F "destination_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  sed -i "s/source_vcenter_ip/$source_vcenter_ip/g" "${i}_request.json"
  sed -i  "s/vm_to_be_migrated/$VM/g" "${i}_request.json"
  sed -i  "s/destination_vcenter_ip/$destination_vcenter_ip/g" "${i}_request.json"
  sed -i  "s/source_vcenter_cluster/$source_vcenter_cluster/g" "${i}_request.json"
  sed -i  "s/destination_vcenter_cluster/$destination_vcenter_cluster/g" "${i}_request.json"
#  perl -pi -e '"s/source_vcenter_ip/$source_vcenter_ip/g";"s/vm_to_be_migrated/$vm_to_be_migrated/g";"s/destination_vcenter_ip/$destination_vcenter_ip/g";"s/source_vcenter_cluster/$source_vcenter_cluster/g";"s/destination_vcenter_cluster/$destination_vcenter_cluster/g"'  ${i}_request.json 
  touch ${i}.yaml
  echo "Request: $i">>${i}.yaml
  VM=`cat request.txt | awk -F "vm_to_be_migrated':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "VM_list: [$VM]">>${i}.yaml
  source_vcenter_url=`cat request.txt | awk -F "source_vcenter_ip':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "source_vcenter_url: https://$source_vcenter_url">>${i}.yaml
  destination_vcenter_url=`cat request.txt | awk -F "destination_vcenter_ip':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "destination_vcenter_url: https://$destination_vcenter_url">>${i}.yaml
  source_vcenter_cluster=`cat request.txt | awk -F "source_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "source_vcenter_cluster: $source_vcenter_cluster">>${i}.yaml
  destination_vcenter_cluster=`cat request.txt | awk -F "destination_vcenter_cluster':" '{print $2}' | awk -F "'" '{print $2}'`
  echo "destination_vcenter_cluster: $destination_vcenter_cluster">>${i}.yaml
done

