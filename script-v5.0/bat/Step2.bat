<!-- :
:: textSubmitter.bat
@echo off

	for /f "delims=." %%i in ('wmic.exe OS get LocalDateTime ^| find "."') do (
	set "DateTime=%%i"
)	
	for /f "tokens=1-3 delims=," %%a in ('mshta.exe "%~f0"') do (
    set "input1=%%a"
    set "input2=%DateTime:~0,4%%DateTime:~4,2%%DateTime:~6,2%_%DateTime:~8,2%%DateTime:~10,2%_%%a"
    set "input3=%%b"
    set "input4=%%c"
)
	
cd /d ..\..\
.\R\R-4.1.1\bin\Rscript.exe --max-mem-size=4GB .\script\Rscript\Step2.Calculate.R %input1% %input2% %input3% %input4%

pause
goto :EOF

-->

<html>
  <head>
    <title>PRS Check (ver5.0)</title>
      PRS Check (ver5.0)<br>
  </head>
  <body>

    <script language='javascript' >
        function pipeText() {
            var input1=document.getElementById('input1').value;
			var input3=document.getElementById('UserSelect').value;
			
			if (document.getElementById('Yes').checked) {
    			var family_type = document.getElementById('Yes').value;
    			
  				 } else if (document.getElementById('No').checked) {
    			var family_type = document.getElementById('No').value;
  				 }
  				 
            var Batch = new ActiveXObject('Scripting.FileSystemObject').GetStandardStream(1);
            close(Batch.WriteLine(input1+','+input3+','+family_type));
      }
    </script>

    <br>Please input the PatientID (Ex: 12345600): <input type='text' name='input1' size='15'></input>
    <br>
    <br>Please input the King-Ship Threshold:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<select class="form-control" required="required" id="UserSelect"> 
	    	<option value='0.25'  > 叫块霩(箇砞: 0.25)         </option>
	    	<option value='0.50'  > 单克 (ダ): 0.5         </option>
	    	<option value='0.25'  > 单克 (ダ﹏ゝ): 0.25  </option>
	    	<option value='0.125' > 单克 (﹉嘶): 0.125 </option>
	</select>
    <br>
    <br>
    Please select do you want the Family PGS output :<input type="radio" id="Yes" name="checktype" value="1" checked><label for="Yes">Yes</label><input type="radio" id="No" name="checktype" value="0"><label for="No">No</label>
	<hr>
    <button onclick='pipeText()'>Go</button>
  </body>
</html>