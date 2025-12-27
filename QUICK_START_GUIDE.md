# 🚀 Quick Start Guide - Smart Campus Navigation System

## Быстрый старт за 5 минут!

### 📦 Что уже создано:

✅ **Jenkinsfile** - CI/CD pipeline конфигурация  
✅ **pom.xml** - Maven проект с зависимостями  
✅ **Spring Boot приложение** - Полностью рабочее API  
✅ **Тесты** - Unit и Integration тесты  
✅ **Docker конфигурация** - Dockerfile и docker-compose  
✅ **Deploy скрипт** - Автоматический деплой  
✅ **Конфигурации** - Nexus, SonarQube, Maven  

---

## 🎯 Вариант 1: Локальный запуск (Быстрый тест)

### Шаг 1: Проверка требований
```bash
# Проверьте Java
java -version
# Должно быть: Java 11 или выше

# Проверьте Maven
mvn -version
# Должно быть: Maven 3.8+
```

### Шаг 2: Сборка и запуск
```bash
# Соберите проект
mvn clean package

# Запустите приложение
java -jar target/smart-campus-navigation-1.0.0-SNAPSHOT.jar

# Или используйте скрипт
chmod +x deploy.sh
./deploy.sh deploy
```

### Шаг 3: Проверка
```bash
# Откройте браузер или используйте curl
curl http://localhost:8888/api/navigation/
curl http://localhost:8888/actuator/health
```

**Готово!** Приложение работает на http://localhost:8888

---

## 🏗️ Вариант 2: CI/CD Pipeline (Production)

### Шаг 1: Подготовка Git репозитория

```bash
# Инициализируйте Git (если еще не сделано)
git init

# Добавьте файлы
git add .

# Сделайте коммит
git commit -m "Initial commit: Smart Campus Navigation System with CI/CD"

# Добавьте remote (ваш Git сервер)
git remote add origin <your-git-repository-url>

# Отправьте код
git push -u origin main
```

### Шаг 2: Настройка Jenkins

1. **Откройте Jenkins**: http://52.202.161.235:8080
2. **Войдите**: admin / q5eLOvPfkXrj8eZw
3. **Создайте Pipeline Job**:
   - Нажмите "New Item"
   - Имя: `ExampleProjectPipeline`
   - Тип: Pipeline
   - В конфигурации выберите "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: [ваш Git URL]
   - Script Path: `Jenkinsfile`
   - Сохраните

4. **Запустите сборку**: Нажмите "Build Now"

### Шаг 3: Мониторинг

- **Jenkins Pipeline**: http://52.202.161.235:8080/job/ExampleProjectPipeline/
- **Application**: http://52.202.161.235:8888
- **SonarQube**: http://52.202.161.235:9000
- **Nexus**: http://52.202.161.235:8081

---

## 🐳 Вариант 3: Docker (Контейнеризация)

```bash
# Сборка и запуск с Docker Compose
docker-compose up -d

# Проверка статуса
docker-compose ps

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

---

## 📡 Тестирование API

### Базовые эндпоинты:

```bash
# 1. Приветствие
curl http://localhost:8888/api/navigation/

# 2. Health Check
curl http://localhost:8888/actuator/health

# 3. Расчет маршрута
curl -X POST http://localhost:8888/api/navigation/route \
  -H "Content-Type: application/json" \
  -d '{
    "from": "Building A",
    "to": "Building B",
    "userId": "user123",
    "accessibilityRequired": false
  }'

# 4. Получить локацию пользователя
curl http://localhost:8888/api/navigation/location/user123

# 5. Проверить доступность комнаты
curl http://localhost:8888/api/navigation/room/room101/availability
```

---

## 🔧 Полезные команды

### Управление приложением
```bash
./deploy.sh deploy    # Полный деплой
./deploy.sh start     # Запуск
./deploy.sh stop      # Остановка
./deploy.sh restart   # Перезапуск
./deploy.sh logs      # Показать логи
./deploy.sh status    # Проверить статус
./deploy.sh build     # Только сборка
```

### Maven команды
```bash
mvn clean           # Очистка
mvn compile         # Компиляция
mvn test            # Тесты
mvn package         # Сборка JAR
mvn install         # Установка в локальный репозиторий
mvn deploy          # Деплой в Nexus
```

### Тестирование и качество кода
```bash
# Запуск тестов с покрытием
mvn clean test jacoco:report

# SonarQube анализ
mvn sonar:sonar \
  -Dsonar.host.url=http://52.202.161.235:9000 \
  -Dsonar.login=developer \
  -Dsonar.password=rwPTHw

# Просмотр отчета о покрытии
open target/site/jacoco/index.html
```

---

## 📊 Структура Pipeline

```
Jenkins Pipeline:
├── 1. Checkout          → Получение кода из Git
├── 2. Build             → Компиляция (mvn compile)
├── 3. Unit Tests        → Тесты (mvn test)
├── 4. SonarQube         → Анализ качества кода
├── 5. Quality Gate      → Проверка стандартов
├── 6. Package           → Создание JAR (mvn package)
├── 7. Deploy to Nexus   → Загрузка в Nexus
├── 8. Deploy App        → Развертывание приложения
└── 9. Health Check      → Проверка работоспособности
```

---

## ⚙️ Конфигурация

### Изменить порт приложения:
```properties
# Файл: src/main/resources/application.properties
server.port=8888  # Измените на нужный порт
```

### Настроить базу данных:
```properties
# H2 (по умолчанию, in-memory)
spring.datasource.url=jdbc:h2:mem:smartcampus

# PostgreSQL (для production)
spring.datasource.url=jdbc:postgresql://localhost:5432/smartcampus
spring.datasource.username=postgres
spring.datasource.password=password
```

### Настроить логирование:
```properties
logging.level.com.smartcampus=DEBUG
logging.file.name=logs/application.log
```

---

## 🐛 Решение проблем

### Проблема: Порт 8888 уже занят
```bash
# Найти процесс
netstat -ano | findstr :8888  # Windows
lsof -i :8888                 # Linux/Mac

# Остановить процесс
./deploy.sh stop
```

### Проблема: Maven не находит зависимости
```bash
# Очистить кеш Maven
mvn clean
mvn dependency:purge-local-repository

# Проверить settings.xml
cat ~/.m2/settings.xml
```

### Проблема: Тесты падают
```bash
# Запустить с детальным выводом
mvn test -X

# Посмотреть отчет
cat target/surefire-reports/*.txt
```

### Проблема: Jenkins pipeline не запускается
1. Проверьте, что Maven и JDK настроены в Jenkins
2. Имена должны совпадать: `Maven-3.8.1` и `JDK-11`
3. Проверьте консоль Jenkins для деталей

---

## 📁 Важные файлы и директории

```
Project 1/
├── Jenkinsfile                    # Jenkins Pipeline
├── pom.xml                        # Maven конфигурация
├── settings.xml                   # Maven settings для Nexus
├── sonar-project.properties       # SonarQube конфигурация
├── Dockerfile                     # Docker образ
├── docker-compose.yml             # Docker Compose
├── deploy.sh                      # Скрипт деплоя
├── README.md                      # Документация
├── JENKINS_SETUP_INSTRUCTIONS.md  # Инструкции по Jenkins
├── src/
│   ├── main/
│   │   ├── java/                  # Исходный код
│   │   └── resources/             # Конфигурация
│   └── test/                      # Тесты
└── target/                        # Скомпилированные файлы
```

---

## ✅ Чеклист первого запуска

- [ ] Java 11+ установлена
- [ ] Maven 3.8+ установлен
- [ ] Проект собирается: `mvn clean package`
- [ ] Тесты проходят: `mvn test`
- [ ] Приложение запускается: `java -jar target/*.jar`
- [ ] API доступен: `curl http://localhost:8888/api/navigation/`
- [ ] Health check работает: `curl http://localhost:8888/actuator/health`
- [ ] Git репозиторий настроен
- [ ] Jenkins pipeline создан
- [ ] Pipeline успешно отработал
- [ ] Приложение задеплоено: http://52.202.161.235:8888

---

## 🎓 Следующие шаги

1. **Изучите API**: Посмотрите `NavigationController.java`
2. **Добавьте функциональность**: Создайте новые endpoints
3. **Напишите тесты**: Добавьте тесты для новых функций
4. **Настройте мониторинг**: Добавьте метрики Prometheus
5. **Улучшите CI/CD**: Добавьте уведомления, деплой stages

---

## 📞 Поддержка

- **Документация**: README.md
- **Jenkins Setup**: JENKINS_SETUP_INSTRUCTIONS.md
- **Логи приложения**: `application.log` или `./deploy.sh logs`
- **Jenkins логи**: Console Output в Jenkins UI
- **SonarQube отчеты**: http://52.202.161.235:9000

---

## 🎉 Готово!

Ваш CI/CD pipeline готов к использованию! 

**Главные URL:**
- 🚀 Application: http://52.202.161.235:8888
- 🏗️ Jenkins: http://52.202.161.235:8080
- 📦 Nexus: http://52.202.161.235:8081
- 🔍 SonarQube: http://52.202.161.235:9000

**Happy Coding! 🚀**

