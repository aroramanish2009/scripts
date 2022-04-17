#/usr/bin/python

#README
#You can use script to enable/disable monitoring on hosts that are being monitored us Zabbix.
#The script can be used in ansible playbook by using the folloiwng (example)
#- name: zabbix server create host
#  connection: local
#  shell: /opt/scripts/SCRIPT.py {{ ansible_hostname }} {{ ansible_eth0.ipv4.address }} {{ zabbix_host_group_id }} {{ zabbix_username }} {{ zabbix_password }} 
#  register: command_result
#  failed_when: "'error' in command_result.stderr"

import json
import requests
import sys
from requests.auth import HTTPBasicAuth
import datetime
import time

if ( len(sys.argv) < 4 ):
   print '[username] [password] [host-name] [enable|disable] are required Variables'
   sys.exit(1)
else:
    zabbixuser=sys.argv[1]
    zabbixpass=sys.argv[2]
    zabbixhost=sys.argv[3]
    status=sys.argv[4]

if status == "disable":
    statuscode = 1
else:
    statuscode = 0
 

url = 'http://my-zabbixserver/api_jsonrpc.php'
headers = {'content-type': 'application/json'}

def get_auth_key():
    res = requests.post(url, json={'jsonrpc': '2.0', 'method' : 'user.authenticate', 'params' : {'user':zabbixuser,'password':zabbixpass}, 'id':'1'} )
    if res.status_code != 200:
	print 'Problem -key'
	print res.status_code
	print res.text
	sys.exit()
    else: 
	result=res.json()
	auth_key=result['result']
	return auth_key

def get_host_id (auth_key):
    payload={
	'jsonrpc': '2.0',
	'method': 'host.get',
	'params': {
		  'output': 'extend',
		  'filter': {
			    'host': [zabbixhost],
			    }
		 },
	 'auth': auth_key,
	 'id': 1
	     }
    res = requests.post(url, data=json.dumps(payload), headers=headers) 
    if res.status_code != 200:
        print 'Problem -hostid'
        print res.status_code
        print res.text
        sys.exit()
    else:
	try:
		result=res.json()['result']
		host_id=result[0] ['hostid']
		return host_id
	except:
		print 'error -get_host_id'
		result=res.json()['result']
		if result():
		   print (zabbixhost + " doesn't exists.")
		   sys.exit()
		else:
		   result=res.json()['error']
		   sys.exit()

def enable_disable_host (host_id, auth_key):
    payload={
        'jsonrpc': '2.0',
        'method': 'host.update',
        'params': {
		  'hostid': host_id,
		  'status': statuscode
                 },
         'auth': auth_key,
         'id': 1
             }
    res = requests.post(url, data=json.dumps(payload), headers=headers)
    if res.status_code != 200:
        print 'Problem -hostid'
        print res.status_code
        print res.text
        sys.exit()
    else:
	result=res.json()['result']
	print (zabbixhost + " is now " + status + "d.")
	

auth_key=get_auth_key()
host_id=get_host_id (auth_key)
enable_disable_host(host_id, auth_key)
