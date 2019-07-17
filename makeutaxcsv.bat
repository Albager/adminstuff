@echo off
:loop
set /p id="Letzte sechs Stellen der FAU ID: "
echo("%id:"= %"|findstr /rbe /c:"""[0-9][0-9][0-9][0-9][0-9][0-9]""" >nul || ( echo EINGABEFEHLER & goto loop )
:: Name des Mitarbeiters, idealerweise NachnameVorname
set /p name="Name des Mitarbeiters: "
:: Leerzeichen entfernen
set name=%name: =%
:: UTAX-CSV generieren
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
)> \\geoserv05.rrze.uni-erlangen.de\admins\[Drucker]\[UTAX-CSVs]\UTAX-%name%.csv
echo Fertig! Pfad zur Datei: \\geoserv05.rrze.uni-erlangen.de\admins\[Drucker]\[UTAX-CSVs]\UTAX-%name%.csv
:: Speicherort im Explorer öffnen
explorer \\geoserv05.rrze.uni-erlangen.de\admins\[Drucker]\[UTAX-CSVs]
pause
