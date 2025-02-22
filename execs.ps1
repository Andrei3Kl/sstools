# Definim calea de export pentru fișierul CSV
$csvPath = "$env:USERPROFILE\Documents\datapcheck\File_List.csv"

# Definim extensiile de fișiere pe care le căutăm
$extensions = @("*.exe", "*.jar", "*.dll", "*.xml", "*.ahk", "*.bat")

# Creăm un array pentru a stoca datele
$fileData = @()

# Parcurgem fiecare extensie
foreach ($extension in $extensions) {
    # Căutăm fișierele recursive în toate directoarele
    $files = Get-ChildItem -Path C:\ -Recurse -Filter $extension -ErrorAction SilentlyContinue

    # Parcurgem fiecare fișier găsit
    foreach ($file in $files) {
        try {
            # Verificăm dacă fișierul are drepturi de administrator
            $isAdmin = $false
            $fileOwner = (Get-Acl -Path $file.FullName).Owner
            if ($fileOwner -like "*Administrator*") {
                $isAdmin = $true
            }

            # Adăugăm informațiile în array
            $fileData += [PSCustomObject]@{
                Name         = $file.Name
                FullPath     = $file.FullName
                CreationTime = $file.CreationTime.ToString("yyyy-MM-dd HH:mm:ss")
                LastWriteTime = $file.LastWriteTime.ToString("yyyy-MM-dd HH:mm:ss")
                SizeKB       = [math]::Round($file.Length / 1KB, 2)
                IsAdmin      = $isAdmin
            }
        } catch {
            # Ignorăm erorile (de exemplu, pentru fișiere fără permisiuni de acces)
            continue
        }
    }
}

# Exportăm array-ul într-un fișier CSV
$fileData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Informațiile despre fișiere au fost exportate în $csvPath" -ForegroundColor Green
