<!-- :
:: textSubmitter.bat
@echo off
for /f "tokens=1-3 delims=," %%a in ('mshta.exe "%~f0"') do (
    set "input1=%%a"
)

cd /d %~dp0
cd /d ..\..\
.\R\R-4.1.1\bin\Rscript.exe .\script\Rscript\Step1.CheckName.R %input1%

pause
goto :EOF

-->

<html>
  <head>
    <title>PRS Check(ver4.0)</title>
      PRS Check(ver4.0)<br>
  </head>
  <body>

    <script language='javascript' >
        function pipeText() {
            var input1=document.getElementById('input1').value;

            var Batch = new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(Batch.WriteLine(input1));
      }
    </script>

    <br>Please input the Patient Name: <input type='text' name='input1' size='10'></input><br>
    <hr>
    <button onclick='pipeText()'>Go</button>
  </body>
</html>