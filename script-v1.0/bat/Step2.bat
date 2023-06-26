<!-- :
:: textSubmitter.bat
@echo off

	for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%a-%%b)
	for /f "tokens=1-2 delims=/:" %%a in ("%TIME%")  do (set mytime=%%a%%b)
	for /f "tokens=1 delims=," %%a in ('mshta.exe "%~f0"') do (
    set "input1=%%a"
    set "input2=%%a_%mydate%_%mytime%"
)
	
cd /d ..\..\
.\R\R-4.1.1\bin\Rscript.exe .\script\Rscript\Step2.Calculate.R %input1% %input2% 

pause
goto :EOF

-->

<html>
  <head>
    <title>PRS Check (ver1.0)</title>
      PRS Check (ver1.0)<br>
  </head>
  <body>

    <script language='javascript' >
        function pipeText() {
            var input1=document.getElementById('input1').value;

            var Batch = new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(Batch.WriteLine(input1));
      }
    </script>

    <br>Please input the Patient ID card number (Ex: A123456789): <input type='text' name='input1' size='30'></input><br>
    <hr>
    <button onclick='pipeText()'>Go</button>
  </body>
</html>