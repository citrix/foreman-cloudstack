#!/bin/bash
curl -s -H "Accept:application/json" -X POST \
     -k -u admin:changeme \
     -d "host[name]=test$(date +%s%N)" \
     -d "host[hostgroup_id]=1" \
     -d "host[environment_id]=1" \
     -d "host[managed]=true" \
     -d "host[type]=Host::Managed" \
     -d "capabilities=image" \
     -d "host[domain_id]=1" \
     -d "host[compute_resource_id]=1" \
     -d "host[compute_attributes][network_ids]=b952b73c-3df7-42b3-b763-c165d532055f"  \
     -d "host[interfaces_attributes][new_interfaces][_destroy]=false"  \
     -d "host[interfaces_attributes][new_interfaces][type]=Nic::Managed" \
     -d "host[interfaces_attributes][new_interfaces][provider]=IPMI" \
     -d "host[compute_attributes][flavor_id]=f13c5944-01a1-42a2-a667-01ec2d240959" \
     -d "host[architecture_id]=1" \
     -d "host[operatingsystem_id]=1" \
     -d "provision_method=image" \
     -d "host[compute_attributes][image_id]=ef867ba8-418b-11e4-9e73-080027700f81" \
     -d "host[build]=1" \
     -d "host[enabled]=1" \
     -d "host[overwrite]=false" \
     -d "host[comment]= {\"tags\":{\"lob\":\"${lob}\"}}" \
      "http://localhost:3000/api/hosts" 

     #-d "host[progress_report_id]=f91dde83-dda7-43ae-8034-e589560d59ff" \
     #-d "host[puppet_ca_proxy_id]=2" 
     #-d "host[puppet_proxy_id]=1" \
