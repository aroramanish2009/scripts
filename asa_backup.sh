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
USER='MYUSERNAME'
USER_PASSWORD='MYPASS'
ENABLE_PASSWORD='MYENABLEPASS'
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
                                 send \"pager 0\"
                                 send \r
                                }
                        }
        sleep 20
                expect {
                        "$promptconf"
                                {
                                 log_file /root/network/firewalls/$2/Configuration_`date +%F`.txt
                                 send \"more system:run\"
                                 send \r
                                }
                        }
        sleep 20
                expect {
                        "$promptconf"
                                {
                                 send \"pager 24\"
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
diff -a -b -B -I "Connection to $1 closed by remote host." -I "Connection to $1 closed." -I ': Written by * ' /root/network/firewalls/$2/Configuration_`date +%F`.txt /root/network/firewalls/$2/Configuration_`date +%F --date='1 day ago'`.txt
if [ ! $? -eq 0 ];
then
           echo "******* File has been Changed ********"
           touch /root/network/firewalls/$2/Changes_`date +%F`.txt
           diff -a -b -B -I "Connection to $1 closed by remote host." -I "Connection to $1 closed." -I ': Written by * ' /root/network/firewalls/$2/Configuration_`date +%F`.txt /root/network/firewalls/$2/Configuration_`date +%F --date='1 day ago'`.txt >> /root/network/firewalls/$2/Changes_`date +%F`.txt
           sleep 3
           cp /root/network/firewalls/$2/Changes_`date +%F`.txt /tmp/file1.txt

perl <<'EOF'
                use strict;
                use integer;
                my $work_file;
                my @raw_data;
                my $raw_data;
                my @files;
                $work_file="/tmp/file1.txt";
                open(DAT, $work_file) || die("could not open file /tmp/file1.txt here! ");
                @raw_data=<DAT>;
                close(DAT);
                foreach $raw_data(@raw_data)
                        {
                         if ( $raw_data =~ "Cryptochecksum")
                           {
                            print "Bogus\n"
                           }
                         elsif ( $raw_data =~ '>')
                           {
                            open (DATA1,">>/tmp/OUT.txt") || die("could not open file /tmp/OUT.txt here! ");
                            print DATA1 "$raw_data";
                            close (DATA1);
                           }
                         elsif ( $raw_data =~ '<')
                           {
                           open (DATA2,">>/tmp/IN.txt") || die("could not open file /tmp/IN.txt here! ");
                            print DATA2 "$raw_data";
                            close (DATA2);
                           }
                        }
EOF
install -b -m 644 /dev/null /tmp/xyz.txt
echo "Configuration ADDED to $2 Firewall" >> /tmp/xyz.txt
echo -e "--------------------------------------------------" >> /tmp/xyz.txt
cat /tmp/IN.txt >> /tmp/xyz.txt
echo "====================================================" >> /tmp/xyz.txt
echo "Configuration REMOVED to $2 Firewall" >> /tmp/xyz.txt
echo -e "----------------------------------------------------" >> /tmp/xyz.txt
cat /tmp/OUT.txt >> /tmp/xyz.txt
echo "====================================================" >> /tmp/xyz.txt
sed -i 's/>//g' /tmp/xyz.txt
sed -i 's/<//g' /tmp/xyz.txt
mailx -s "$2 Firewall Changes" $EMAIL < /tmp/xyz.txt
rm -f /tmp/xyz.txt /tmp/file1.txt /tmp/IN.txt /tmp/OUT.txt
else
    echo "No Changes"
fi
}
#======================================================================================================================
## Call the fuction per Firewall, Please make sure directories are created.

backmeup_fw 1.1.1.1 MY-FIREWALL-1
sleep 120
backmeup_fw 1.1.1.2 MY-FIREWALL-2

===================================================================================================================
