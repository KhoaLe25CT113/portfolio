param(
    [string]$ImagePath = "avatar.jpg"
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

$fullImgPath = Join-Path $scriptDir $ImagePath
if (-not (Test-Path $fullImgPath)) {
    Write-Host "[!] Khong tim thay file anh tai: $fullImgPath" -ForegroundColor Red
    Write-Host "Vui long dat file anh (VD: avatar.jpg) vao cung thu muc nay."
    pause
    exit 1
}

Write-Host "[*] Dang doc va chuyen doi anh $ImagePath sang Base64..." -ForegroundColor Cyan
$bytes = [System.IO.File]::ReadAllBytes($fullImgPath)
$base64 = [System.Convert]::ToBase64String($bytes)

# Xac dinh dinh dang anh (jpg, png, webp)
$ext = [System.IO.Path]::GetExtension($fullImgPath).ToLower().TrimStart('.')
if ($ext -eq "jpg") { $ext = "jpeg" }
$dataUri = "data:image/$ext;base64,$base64"

$filesToUpdate = @("index.html", "portfolio.html")

foreach ($file in $filesToUpdate) {
    $filePath = Join-Path $scriptDir $file
    if (Test-Path $filePath) {
        Write-Host "[*] Dang cap nhat anh vao $file..." -ForegroundColor Yellow
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        
        # Thay the moi the img co class brand-avatar-mini va avatar-photo
        $regexMini = '<img\s+src="[^"]*"\s+alt="Lê Văn Khoa Avatar"\s+class="brand-avatar-mini"\s*/?>'
        $regexPhoto = '<img\s+src="[^"]*"\s+alt="Lập trình viên Lê Văn Khoa"\s+class="avatar-photo"\s*/?>'
        
        $newMini = '<img src="' + $dataUri + '" alt="Lê Văn Khoa Avatar" class="brand-avatar-mini" />'
        $newPhoto = '<img src="' + $dataUri + '" alt="Lập trình viên Lê Văn Khoa" class="avatar-photo" />'
        
        $content = [regex]::Replace($content, $regexMini, $newMini)
        $content = [regex]::Replace($content, $regexPhoto, $newPhoto)
        
        [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        Write-Host "[OK] Da cap nhat $file thanh cong!" -ForegroundColor Green
    }
}

Write-Host "`n[HOAN TAT] Tat ca file HTML da duoc nhung anh moi truc tiep (Base64)." -ForegroundColor Green
Write-Host "File HTML doc lap hoan toan, nguoi khac mo xem luon hien anh 100%!" -ForegroundColor Cyan
