# Process Monitoring Solution

## Описание
Решение для мониторинга процесса `test` в Linux среде с отправкой HTTP запросов и логированием событий.

## Требования
- Linux с systemd
- curl
- root доступ для установки

## Структура проекта
monitoring-task/
├── monitoring.sh # Основной скрипт мониторинга
├── monitoring.service # Systemd service файл
├── monitoring.timer # Systemd timer файл
├── install.sh # Скрипт установки
├── test_process.sh # Mock процесс для тестирования
└── README.md # Документация

## Установка
```bash
# Сделайте скрипты исполняемыми
chmod +x install.sh monitoring.sh test_process.sh

# Запустите установку
sudo ./install.sh