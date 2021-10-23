# check for admin rights
#Requires -RunAsAdministrator

# set field
# set the variables for the firewall network (here: LAN1)
$ip='0.0.0.0'               # Network from pfSense LAN1
$mask='255.255.255.0'       # Subnet from pfSense LAN1
$gateway='192.168.178.0'    # IP from pfSense WAN 

# add route
route add $ip mask $mask $gateway

# output
Write-Host "###########################################"
Write-Host "The network $($ip) was successfully added!"
Write-Host "###########################################"