@echo off 

for /f "tokens=2-8 delims=.:/ " %%a in ("%date% %time%") do set timestamp=%%c-%%a-%%b_%%d-%%e-%%f.%%g

set DISABLED_LOG="E:\ADCleaner\Workstation\Disabled\disabled_log_%timestamp%.txt"

set DELETED_LOG="E:\ADCleaner\Workstation\Deleted\deleted_log_%timestamp%.txt"
 
dsquery computer ou=ADOUNAME,dc=DOMAINNAME,dc=com -inactive 8 -limit 0 > "%DISABLED_LOG%"

@echo No of Inactive Computers: 
 
dsquery computer ou=ADOUNAME,dc=DOMAINNAME,dc=com -inactive 8 -limit 0 | find "CN=" /c
 
@echo Disabling Computers 
 
dsquery computer ou=ADOUNAME,dc=DOMAINNAME,dc=com -inactive 8 -limit 0 | dsmod computer -disabled Yes 
 
@echo Moving Computers 

FOR /F "usebackq tokens=*"  %%i in (%DISABLED_LOG%) do (dsmove %%i -newparent "OU=ADOUNAME,DC=DOMAINNAME,DC=com") 

@echo Deleting Computers

dsquery computer OU="ADOUNAME",DC=DOMAINNAME,DC=com -scope onelevel -inactive 16 -limit 0 > "%DELETED_LOG%"

rem FOR /F "usebackq tokens=*"  %%i in (%DELETED_LOG%) do (dsrm -noprompt)