## abrir o powershell e executar.
Invoke-WebRequest -OutFile install.ps1 -Uri "https://raw.githubusercontent.com/comottec/comottec/refs/heads/main/scripts/oga/prd_2510/install.ps1"
powershell.exe -executionpolicy bypass -file "install.ps1"
