#!/usr/bin/python
'''
The script connects to the Cisco switch running IOS using SNMP Version 2 community based and provides a list of ports that currently down &
their "show interface counter" value is zero for In and Out traffic.
DONOT USE THIS BECAUSE STUPID CISCO DOESN'T CLEAR SNMP COUNTER UNLESS DEVICE IS REBOOTED.
'''
import re
import sys
from snmp_helper import snmp_get_oid,snmp_extract

if ( len(sys.argv) < 3 ):
   print '[device_ip] [community_string] [snmp_port] are required Variables'
   sys.exit(1)
else:
    device_ip=sys.argv[1]
    community_string=sys.argv[2]
    snmp_port=sys.argv[3]

def get_hostname(device_ip, community_string):
    a_device=(device_ip, community_string, snmp_port)
    snmp_hostname = snmp_get_oid(a_device, oid='.1.3.6.1.2.1.1.5.0', display_errors=True)
    output = snmp_extract(snmp_hostname)
    if output == "No Such Instance currently exists at this OID":
        print 'No Such OID'
        sys.exit()
    else:
        hostname=output
        return hostname

def get_total_port(device_ip, community_string):
    a_device=(device_ip, community_string, snmp_port)
    ifcount = 0
    for i in range(1,1000):
        snmp_ifType = snmp_get_oid(a_device, oid='.1.3.6.1.2.1.2.2.1.3.' + `i` , display_errors=True)
        output = snmp_extract(snmp_ifType)
        if output == "No Such Instance currently exists at this OID":
            return ifcount
            break
        else:
            ifcount = ifcount + 1

def get_available_port(device_ip, community_string, ifcount):
    a_device=(device_ip, community_string, snmp_port)
    snmp_hostname = snmp_get_oid(a_device, oid='1.3.6.1.2.1.1.5.0', display_errors=True)
    output_hostname = snmp_extract(snmp_hostname)
    print "Switch " + output_hostname + " at " +  device_ip + " have following Ports avaiable for use."
    print "==============================================================================================="
    for i in range(1,ifcount):
        snmp_ifOutOctets = snmp_get_oid(a_device, oid='.1.3.6.1.2.1.2.2.1.16.' + `i` , display_errors=True)
        snmp_ifInOctets = snmp_get_oid(a_device, oid='.1.3.6.1.2.1.2.2.1.10.' + `i` , display_errors=True)
        output_ifOutOctets = snmp_extract(snmp_ifOutOctets)
        output_ifInOctets = snmp_extract(snmp_ifInOctets)
        if output_ifOutOctets == "0" and output_ifInOctets == "0":
            snmp_ifDescr = snmp_get_oid(a_device, oid='.1.3.6.1.2.1.2.2.1.2.' + `i`, display_errors=True)
            output_ifDescr = snmp_extract(snmp_ifDescr)
            interface_check = re.search( r'.*/1/.*', output_ifDescr, flags=0)
            stackinterface_check = re.search( r'StackPort.*', output_ifDescr, flags=0)
            if stackinterface_check or output_ifDescr == "Null0" or output_ifDescr == "GigabitEthernet0/0" or interface_check:
                pass
            else:
                switch = output_ifDescr.split('/') [0]
                switchno_len = len(switch)
                switchno = switch[switchno_len - 1]
                switchport = output_ifDescr.split('/') [2]
                print "Switch " + switchno + " --- Port# " + switchport
                #print output_ifDescr


hostname=get_hostname(device_ip, community_string)
ifcount=get_total_port(device_ip, community_string)
print "==============================================================================================="
get_available_port(device_ip, community_string, ifcount)
print "==============================================================================================="
