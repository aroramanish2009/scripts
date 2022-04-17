#!/bin/bash
###############################################################################################################################################
#Script to backup network devices.
#Written by Manish Arora 
#Dated: 10/14/2005
#
#Comments & suggestions -> writeit@yourself.com ;-)
#If I have time, I would love to rewrite it in python only.
#################################################################################################################################################
#Known Issue - Certificate warning selected to yes before using the script or disable checking the Certificate in ssh_config on your linux server.
#
##################################################################################################################################################
## Variables
EMAIL="myemail@email.com"
prompt="*#"
promptconf="*(config)#"
USER='manish'
USER_PASSWORD='xxxx'
ENABLE_PASSWORD='xxxx'
##########################################################################

backmeup_fw () {
expect -c "
        spawn ssh -l $USER $1
        sleep 2
                expect {
                        "*word"
                                {
                                 send "$USER_PASSWORD"
                                 send \r
                                }
                        }
        sleep 2
                expect {
                        "*"
                                {
                                 send "en"
                                 send \r
                                }
                        }
        sleep 2
                expect {
                        "*word"
                                {
                                 send "$ENABLE_PASSWORD"
                                 send \r
                                }
                        }
        sleep 1
                expect {
                        "$prompt"
                                {
                                 send \"conf t\"
                                 send \r
                                }
                        }
        sleep 1
                expect {
                        "$promptconf"
                                {
                                 send \"$2\"
                                 send \r
                                }
                        }
        sleep 1
                expect {
                        "$promptconf"
                                {
                                 send \"$3\"
                                 send \r
                                }
                        }
        sleep 1
                expect {
                        "$promptconf"
                                {
                                 send \"wr mem\"
                                 send \r
                                }
                        }
        sleep 2
                expect {
                        "$promptconf"
                                {
                                 send \"logout\"
                                 send \r
                                }
                        }
expect eof "
}
#======================================================================================================================
## Call the fuction per Firewall, Please make sure directories are created.

backmeup_fw '10.x.x.x' 'no crypto map outside_map 1 set peer y.y.y.y' 'crypto map outside_map 1 set peer z.z.z.z'
sleep 20
#===================================================================================================================
