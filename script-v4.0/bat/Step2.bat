<!-- :
:: textSubmitter.bat
@echo off

	for /f "delims=." %%i in ('wmic.exe OS get LocalDateTime ^| find "."') do (
	set "DateTime=%%i"
)	
	for /f "tokens=1 delims=," %%a in ('mshta.exe "%~f0"') do (
    set "input1=%%a"
    set "input2=%DateTime:~0,4%%DateTime:~4,2%%DateTime:~6,2%_%DateTime:~8,2%%DateTime:~10,2%_%%a"
)
	
cd /d ..\..\
.\R\R-4.1.1\bin\Rscript.exe --max-mem-size=4GB .\script\Rscript\Step2.Calculate.R %input1% %input2% 

pause
goto :EOF

-->

<html>
  <head>
    <title>PRS Check (ver4.0)</title>
      PRS Check (ver4.0)<br>
  </head>
  <body>

    <script language='javascript' >
        function pipeText() {
            var input1=document.getElementById('input1').value;

            var Batch = new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(Batch.WriteLine(input1));
      }
    </script>

    <br>Please input the PatientID (Ex: 12345600): <input type='text' name='input1' size='30'></input><br>
    <hr>
    <button onclick='pipeText()'>Go</button>
  </body>
</html>