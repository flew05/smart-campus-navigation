# =====================================================
# Автоматическая установка Apache Maven на Windows
# =====================================================

# Запустите этот скрипт от имени администратора!

$ErrorActionPreference = "Stop"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Apache Maven - Автоматическая установка  " -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Проверка прав администратора
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[ERROR] Этот скрипт должен быть запущен от имени администратора!" -ForegroundColor Red
    Write-Host "Нажмите правой кнопкой на PowerShell и выберите 'Запуск от имени администратора'" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host "[1/6] Проверка текущей установки..." -ForegroundColor Yellow

# Проверка Maven
try {
    $mavenVersion = mvn -version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[INFO] Maven уже установлен:" -ForegroundColor Green
        Write-Host $mavenVersion
        $continue = Read-Host "Продолжить переустановку? (y/n)"
        if ($continue -ne 'y') {
            Write-Host "Установка отменена." -ForegroundColor Yellow
            exit 0
        }
    }
} catch {
    Write-Host "[INFO] Maven не найден, продолжаем установку..." -ForegroundColor Yellow
}

# Проверка Java
Write-Host "[2/6] Проверка Java..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1
    Write-Host "[OK] Java найдена:" -ForegroundColor Green
    Write-Host $javaVersion[0]
} catch {
    Write-Host "[ERROR] Java не найдена! Установите Java перед установкой Maven." -ForegroundColor Red
    Write-Host "Скачайте Java с: https://adoptium.net/" -ForegroundColor Yellow
    pause
    exit 1
}

Write-Host ""
Write-Host "[3/6] Выберите способ установки:" -ForegroundColor Yellow
Write-Host "  1. Через Chocolatey (рекомендуется, быстро)" -ForegroundColor Cyan
Write-Host "  2. Ручная установка (скачивание и настройка)" -ForegroundColor Cyan
$choice = Read-Host "Ваш выбор (1 или 2)"

if ($choice -eq "1") {
    # ===== УСТАНОВКА ЧЕРЕЗ CHOCOLATEY =====
    Write-Host ""
    Write-Host "[4/6] Проверка Chocolatey..." -ForegroundColor Yellow
    
    try {
        choco -v 2>$null | Out-Null
        Write-Host "[OK] Chocolatey установлен" -ForegroundColor Green
    } catch {
        Write-Host "[INFO] Установка Chocolatey..." -ForegroundColor Yellow
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] Chocolatey установлен успешно!" -ForegroundColor Green
            # Обновить PATH
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        } else {
            Write-Host "[ERROR] Не удалось установить Chocolatey" -ForegroundColor Red
            pause
            exit 1
        }
    }
    
    Write-Host ""
    Write-Host "[5/6] Установка Maven через Chocolatey..." -ForegroundColor Yellow
    choco install maven -y
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Maven установлен успешно!" -ForegroundColor Green
        
        # Обновить PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Host ""
        Write-Host "[6/6] Проверка установки..." -ForegroundColor Yellow
        mvn -version
        
        Write-Host ""
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host "  Maven успешно установлен!" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Не удалось установить Maven" -ForegroundColor Red
        pause
        exit 1
    }
    
} elseif ($choice -eq "2") {
    # ===== РУЧНАЯ УСТАНОВКА =====
    Write-Host ""
    Write-Host "[4/6] Скачивание Maven..." -ForegroundColor Yellow
    
    $mavenVersion = "3.9.6"
    $mavenUrl = "https://dlcdn.apache.org/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip"
    $downloadPath = "$env:TEMP\apache-maven-$mavenVersion-bin.zip"
    $installPath = "C:\Program Files\Apache\Maven"
    
    Write-Host "[INFO] Скачивание с $mavenUrl ..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $mavenUrl -OutFile $downloadPath
        Write-Host "[OK] Maven скачан: $downloadPath" -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Не удалось скачать Maven: $_" -ForegroundColor Red
        pause
        exit 1
    }
    
    Write-Host ""
    Write-Host "[5/6] Распаковка и настройка..." -ForegroundColor Yellow
    
    # Создать папку для установки
    if (-not (Test-Path $installPath)) {
        New-Item -ItemType Directory -Force -Path $installPath | Out-Null
    }
    
    # Распаковать
    Write-Host "[INFO] Распаковка в $installPath ..." -ForegroundColor Cyan
    Expand-Archive -Path $downloadPath -DestinationPath $installPath -Force
    
    $mavenHome = "$installPath\apache-maven-$mavenVersion"
    
    # Установить MAVEN_HOME
    Write-Host "[INFO] Настройка переменных окружения..." -ForegroundColor Cyan
    [System.Environment]::SetEnvironmentVariable('MAVEN_HOME', $mavenHome, 'Machine')
    
    # Добавить в PATH
    $currentPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
    if ($currentPath -notlike "*$mavenHome\bin*") {
        $newPath = $currentPath + ";$mavenHome\bin"
        [System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')
    }
    
    # Обновить PATH в текущей сессии
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    $env:MAVEN_HOME = $mavenHome
    
    # Удалить временный файл
    Remove-Item $downloadPath -Force
    
    Write-Host "[OK] Maven установлен в: $mavenHome" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "[6/6] Проверка установки..." -ForegroundColor Yellow
    mvn -version
    
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "  Maven успешно установлен!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    
} else {
    Write-Host "[ERROR] Неверный выбор!" -ForegroundColor Red
    pause
    exit 1
}

Write-Host ""
Write-Host "Настройка Maven settings.xml..." -ForegroundColor Yellow

# Создать папку .m2
$m2Path = "$env:USERPROFILE\.m2"
if (-not (Test-Path $m2Path)) {
    New-Item -ItemType Directory -Force -Path $m2Path | Out-Null
    Write-Host "[OK] Создана папка: $m2Path" -ForegroundColor Green
}

# Скопировать settings.xml если существует в проекте
$projectSettings = "settings.xml"
if (Test-Path $projectSettings) {
    Copy-Item $projectSettings "$m2Path\settings.xml" -Force
    Write-Host "[OK] settings.xml скопирован в $m2Path" -ForegroundColor Green
} else {
    Write-Host "[INFO] settings.xml не найден в текущей папке" -ForegroundColor Yellow
    Write-Host "[INFO] Скопируйте его вручную позже" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  Установка завершена!" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Maven версия:" -ForegroundColor Green
mvn -version
Write-Host ""
Write-Host "Следующие шаги:" -ForegroundColor Yellow
Write-Host "  1. Закройте и откройте заново PowerShell" -ForegroundColor Cyan
Write-Host "  2. Проверьте: mvn -version" -ForegroundColor Cyan
Write-Host "  3. Соберите проект: mvn clean package" -ForegroundColor Cyan
Write-Host "  4. Запустите приложение: java -jar target\*.jar" -ForegroundColor Cyan
Write-Host ""
Write-Host "Документация: QUICK_START_GUIDE.md" -ForegroundColor Yellow
Write-Host ""

pause

