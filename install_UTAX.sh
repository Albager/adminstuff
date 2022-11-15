#!/bin/bash
echo
#echo "This script will install the UTAX-TA 3508ci driver and set up Job Accounting by manipulating the PPD file"
zenity --info --title="UTAX 3508ci installer" --text="This script will install the UTAX-TA 3508ci driver and set up Job Accounting by manipulating the PPD file" --no-wrap

echo "downloading driver..."

wget https://catalogue-prod.utax.de/blobs/dc92d4bd-a761-4c0f-a981-0f1efc7c1a7f

tar -zxf TALinuxDriver*.tar.gz --directory /tmp/

#install ta-utax-dialog
sudo dpkg -i /tmp/Ubuntu/EU/ta_utax_dialog_amd64/ta-utax-dialog*.deb

#sudo service dbus restart

#get the user's print account
fauid=$(zenity --entry --title="UTAX 3508ci installer" --text="last six digits of your FAUID:")
lastname=$(zenity --entry --title="UTAX 3508ci installer" --text="your last name:")

#change the PPD file accordingly
sudo sed -i "s/DefaultKmManagment: Default/DefaultKmManagment: MG09$fauid/" /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd
sudo sed -i "s/MG00000000\/00000000: \"(00000000)/MG09$fauid\/09$fauid: \"(09$fauid)/" /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd
sudo sed -i "s/MG00000001\/00000001: \"(00000001)/MG08$fauid\/08$fauid: \"(08$fauid)/" /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd
sudo sed -i "s/MG00000002\/00000002: \"(00000002)/MG07$fauid\/07$fauid: \"(07$fauid)/" /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd

#install cups printers with PPD file
/usr/sbin/lpadmin -p UTAX-Nord -E -v socket://10.26.64.25 -P /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd
/usr/sbin/lpadmin -p UTAX-Süd -E -v socket://10.26.64.22 -P /usr/share/cups/model/TA_UTAX/TA_3508ci.ppd

#done
zenity --info --title="UTAX 3508ci installer" --text="Installation complete! Please check your configuration by printing a test page. Cheers!" --no-wrap

#open printers
system-config-printer &
