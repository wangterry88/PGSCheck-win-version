<!-- :
:: textSubmitter.bat
@echo off

for /f "tokens=1-3 delims=," %%a in ('mshta.exe "%~f0"') do (
    set "input_type=%%a"
)

cd /d %~dp0

if "%input_type%" == "ptname" (
	
	start /wait .\Step1.bat & start .\Step2.bat & exit
	
	)else if "%input_type%" == "ptid" (
	
	start .\Step2.bat 
	
	)else (
	
	 exit

	)
	
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
            var input_type ; 
            	if (document.getElementById('Ptname').checked) {
    			input_type = document.getElementById('Ptname').value;
  				 } else if (document.getElementById('Ptid').checked) {
    			input_type = document.getElementById('Ptid').value;
  				 }
            var Batch = new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(Batch.WriteLine(input_type));
      }
    </script>
  
  <fieldset>
    <legend>Select a Search method:</legend>

    <div>
      <input type="radio" id="Ptname" name="checktype" value="ptname" checked>
      <label for="ptname">Search by Patient name</label>
    </div>
    <div>
      <input type="radio" id="Ptid" name="checktype" value="ptid">
      <label for="ptid">Search by Patient ID</label>
    </div>
    <div>
    	<button onclick='pipeText()'>Go</button>
    </div>
  </fieldset>
  
  </body>
  
</html>