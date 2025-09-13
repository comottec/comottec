Invoke-WebRequest -OutFile install.ps1 -Uri "https://github.com/comottec/comottec/raw/refs/heads/main/scripts/ofi/prd_2410/install.ps1"
powershell.exe -executionpolicy bypass -file "install.ps1"
