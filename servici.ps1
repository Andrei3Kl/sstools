# Definim calea de export
$exportFolder = "$env:USERPROFILE\Documents\datapcheck"
$csvPath = "$exportFolder\Stopped_Disabled_Services.csv"

# Verificăm dacă folderul există; dacă nu, îl creăm
if (-not (Test-Path $exportFolder)) {
    New-Item -Path $exportFolder -ItemType Directory | Out-Null
    Write-Host "Folderul $exportFolder a fost creat." -ForegroundColor Yellow
}

# Definim lista de servicii de verificat
$services = @("pcasvc", "DPS", "DiagTrack", "SysMain", "EventLog", "SgrmBroker", "CDPUserSvc")

# Creăm un array pentru a stoca serviciile filtrate
$filteredServices = @()

# Parcurgem fiecare serviciu din listă
foreach ($service in $services) {
    # Obținem informații despre serviciu
    $serviceInfo = Get-Service -Name $service -ErrorAction SilentlyContinue

    # Verificăm dacă serviciul există și este oprit sau dezactivat
    if ($serviceInfo -and ($serviceInfo.Status -eq "Stopped" -or $serviceInfo.StartType -eq "Disabled")) {
        $filteredServices += [PSCustomObject]@{
            Name        = $serviceInfo.Name
            DisplayName = $serviceInfo.DisplayName
            Status      = $serviceInfo.Status
            StartType   = $serviceInfo.StartType
        }
    }
}

# Exportăm serviciile filtrate într-un fișier CSV
$filteredServices | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Serviciile oprite sau dezactivate au fost exportate în $csvPath" -ForegroundColor Green
