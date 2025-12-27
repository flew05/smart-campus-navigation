# 📦 Установка Apache Maven на Windows

## Быстрая установка Maven

---

## 🎯 Вариант 1: Автоматическая установка (РЕКОМЕНДУЕТСЯ)

### Шаг 1: Запустите PowerShell от имени администратора

1. Нажмите `Win + X`
2. Выберите **"Windows PowerShell (администратор)"** или **"Терминал (администратор)"**

### Шаг 2: Установите Maven через Chocolatey

```powershell
# Установите Chocolatey (если еще не установлен)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Установите Maven
choco install maven -y

# Проверьте установку
mvn -version
```

**Готово!** Maven установлен автоматически.

---

## 🔧 Вариант 2: Ручная установка (если нужен контроль)

### Шаг 1: Скачайте Maven

1. Откройте браузер
2. Перейдите на: https://maven.apache.org/download.cgi
3. Скачайте **"apache-maven-3.9.6-bin.zip"** (или последнюю версию)
4. Или используйте прямую ссылку: https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip

### Шаг 2: Распакуйте Maven

1. Создайте папку: `C:\Program Files\Apache\Maven`
2. Распакуйте скачанный ZIP в эту папку
3. Должна получиться структура: `C:\Program Files\Apache\Maven\apache-maven-3.9.6\`

### Шаг 3: Настройте переменные окружения

#### Способ A: Через графический интерфейс

1. **Откройте системные переменные:**
   - Нажмите `Win + Pause` или
   - Правой кнопкой на "Этот компьютер" → "Свойства"
   - Нажмите "Дополнительные параметры системы"
   - Нажмите кнопку "Переменные среды"

2. **Создайте MAVEN_HOME:**
   - В разделе "Системные переменные" нажмите "Создать"
   - **Имя переменной**: `MAVEN_HOME`
   - **Значение переменной**: `C:\Program Files\Apache\Maven\apache-maven-3.9.6`
   - Нажмите "ОК"

3. **Добавьте Maven в PATH:**
   - В разделе "Системные переменные" найдите переменную `Path`
   - Выберите её и нажмите "Изменить"
   - Нажмите "Создать"
   - Добавьте: `%MAVEN_HOME%\bin`
   - Нажмите "ОК" везде

#### Способ B: Через PowerShell (от администратора)

```powershell
# Установите MAVEN_HOME
[System.Environment]::SetEnvironmentVariable('MAVEN_HOME', 'C:\Program Files\Apache\Maven\apache-maven-3.9.6', 'Machine')

# Добавьте Maven в PATH
$currentPath = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
$newPath = $currentPath + ';%MAVEN_HOME%\bin'
[System.Environment]::SetEnvironmentVariable('Path', $newPath, 'Machine')

# Перезагрузите переменные окружения
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine')
```

### Шаг 4: Проверьте установку

1. **Закройте и откройте заново** PowerShell
2. Выполните:

```powershell
mvn -version
```

**Должны увидеть:**
```
Apache Maven 3.9.6 (...)
Maven home: C:\Program Files\Apache\Maven\apache-maven-3.9.6
Java version: 1.8.0_401, vendor: Oracle Corporation
...
```

---

## ⚠️ ВАЖНО: Обновление Java

Ваша текущая версия Java: **1.8.0_401**  
Для проекта рекомендуется: **Java 11+**

### Установка Java 11 (OpenJDK)

```powershell
# Через Chocolatey
choco install openjdk11 -y

# Или через Chocolatey (Temurin - рекомендуется)
choco install temurin11 -y

# Проверка
java -version
```

---

## ✅ Проверка установки

После установки Maven выполните:

```powershell
# Проверьте Maven
mvn -version

# Проверьте Java
java -version

# Перейдите в папку проекта
cd "C:\Users\Леонид\Desktop\Project 1"

# Попробуйте собрать проект
mvn clean compile
```

---

## 🔧 Настройка Maven settings.xml

После установки Maven настройте файл `settings.xml`:

```powershell
# Создайте папку .m2 (если её нет)
New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.m2"

# Скопируйте settings.xml из проекта
Copy-Item "settings.xml" "$env:USERPROFILE\.m2\settings.xml"
```

Или вручную:
1. Откройте папку: `C:\Users\Леонид\.m2\`
2. Если папки нет, создайте её
3. Скопируйте файл `settings.xml` из проекта в эту папку

---

## 🚀 Быстрый тест проекта

После установки Maven:

```powershell
# В папке проекта
cd "C:\Users\Леонид\Desktop\Project 1"

# Очистка и компиляция
mvn clean compile

# Запуск тестов
mvn test

# Сборка JAR
mvn package

# Запуск приложения
java -jar target\smart-campus-navigation-1.0.0-SNAPSHOT.jar
```

---

## 🐛 Решение проблем

### Проблема 1: "mvn не распознано"

**Решение:**
```powershell
# Перезагрузите переменные окружения
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

# Или перезапустите PowerShell
```

### Проблема 2: "JAVA_HOME не установлена"

**Решение:**
```powershell
# Найдите путь к Java
where.exe java

# Установите JAVA_HOME (измените путь на ваш)
[System.Environment]::SetEnvironmentVariable('JAVA_HOME', 'C:\Program Files\Java\jdk-11', 'Machine')
```

### Проблема 3: Maven не может скачать зависимости

**Решение:**
```powershell
# Очистите локальный репозиторий
Remove-Item -Recurse -Force "$env:USERPROFILE\.m2\repository"

# Попробуйте снова
mvn clean install
```

---

## 📊 Полезные команды Maven

```powershell
# Проверка версии
mvn -version

# Очистка проекта
mvn clean

# Компиляция
mvn compile

# Запуск тестов
mvn test

# Создание JAR
mvn package

# Установка в локальный репозиторий
mvn install

# Пропустить тесты
mvn package -DskipTests

# Показать зависимости
mvn dependency:tree

# Обновить зависимости
mvn clean install -U

# Показать effective POM
mvn help:effective-pom
```

---

## 📝 Конфигурация Maven в проекте

После установки Maven используйте файлы из проекта:

- ✅ `pom.xml` - уже создан
- ✅ `settings.xml` - скопируйте в `C:\Users\Леонид\.m2\settings.xml`
- ✅ Nexus уже настроен в settings.xml

---

## 🎯 Что делать после установки

1. ✅ Проверьте: `mvn -version`
2. ✅ Скопируйте `settings.xml` в `~/.m2/`
3. ✅ Соберите проект: `mvn clean package`
4. ✅ Запустите приложение: `java -jar target\*.jar`
5. ✅ Протестируйте API: `curl http://localhost:8888/api/navigation/`

---

## 🌟 Готово!

Maven установлен и готов к использованию!

Теперь вы можете:
- Собирать проект: `mvn clean package`
- Запускать тесты: `mvn test`
- Использовать Jenkins CI/CD pipeline
- Загружать артефакты в Nexus

**Следующий шаг**: См. `QUICK_START_GUIDE.md` для запуска проекта

