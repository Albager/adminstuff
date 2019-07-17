@echo off
:loop
set /p id="Last six digits of the FAU ID: "
echo("%id:"= %"|findstr /rbe /c:"""[0-9][0-9][0-9][0-9][0-9][0-9]""" >nul || ( echo INPUT ERROR & goto loop )
:: Name of the staff member, ideally LastnameFirstname
set /p name="Name of the staff member: "
:: remove whitespace
set name=%name: =%
:: generate UTAX-CSV
(
echo 3005ci KX,
echo Version 7.3.1721,
echo.
echo.
echo Management Codes:,3
echo Description,Code,Count Usernames,Usernames
echo "'%name% (Lehre)","'07%id%","'0",
echo "'%name% (privat)","'08%id%","'0",
echo "'%name% (dienstlich)","'09%id%","'0",
)> \\path\to\folder\UTAX-%name%.csv
echo Ready! File Location: \\path\to\folder\UTAX-%name%.csv
:: open file location
explorer \\path\to\folder
pause
