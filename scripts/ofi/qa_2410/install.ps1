## powershell.exe -executionpolicy bypass -file "install.ps1"

$APPSERVER_ENDPOINT = "https://200.208.140.78:6010"
$INSTALATION_ROOT = "c:\Totvs_WebAgent"
$INSTALATION_DIR = (join-path -Path $INSTALATION_ROOT -ChildPath "Totvs2410")
$WEBAGENT_URL = "https://comottecstore.blob.core.windows.net/`$web/files/ofi/Totvs2410.zip"
$TEMP_DIR = [System.IO.Path]::GetTempPath()
$TEMP_FILE = (Join-Path -Path $TEMP_DIR -ChildPath "Totvs2410.zip")

function get-browser {
    $process = Start-Process -FilePath 'http://www.google.com' -PassThru -WindowStyle Hidden
    $browserApp = $process.Path
    $process.Kill()
    return $browserApp
}

function get-SmartApp {
    echo "Baixando arquivos para instalação..."

    if (test-path $TEMP_FILE) {
        Remove-Item -Path $TEMP_FILE  -Force
    }

    Invoke-WebRequest -OutFile $TEMP_FILE -Uri $WEBAGENT_URL

    if (-not (test-path $INSTALATION_ROOT)) {
        md $INSTALATION_ROOT
    }

    if (test-path $INSTALATION_DIR) {
        Remove-Item -Path $INSTALATION_DIR -Recurse -Force
    }
    Expand-Archive -Path $TEMP_FILE -DestinationPath $INSTALATION_ROOT 
}

function create-Shortcut {
    echo "Criando atalhos..."
    $localBrowser = (get-browser)
    $WshShell = New-Object -ComObject WScript.Shell
    $ShortcutFile = (join-path -Path $INSTALATION_DIR -ChildPath "Totvs2410.lnk")
    $Shortcut = $WshShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = (join-path -Path $INSTALATION_DIR -ChildPath "web-agent.exe")
    $Shortcut.Arguments = "launch `"$APPSERVER_ENDPOINT/webapp/?p=SIGAMDI`&e=homolog`&M=1`" --browser=`"$localBrowser`""
    $IconLocation = "C:\Windows\System32\shell32.dll,44"
    $Shortcut.IconLocation = $IconLocation
    $Shortcut.Save()
    
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    copy-item -Path $ShortcutFile -Destination $desktopPath 
}

# function import-certTotvs {
#     echo "Importando certificados Totvs..."
#     Import-Certificate -FilePath (join-path -Path $INSTALATION_DIR -ChildPath "totvs_certificate_CA.crt") -CertStoreLocation  'Cert:\LocalMachine\Root' 
# }

function instalation-program {
    get-SmartApp
    create-Shortcut
    # import-certTotvs
}

echo "Iniciando programa de instalaçào..."
instalation-program
echo "Instalação concluída."

