# Управление периодическими задачами (opencode-scheduler)

Система для автоматического выполнения задач по расписанию с использованием systemd timers.

## Быстрый старт

```bash
# Просмотр задач
opencode list-jobs
systemctl --user list-timers | grep opencode

# Создание задачи
opencode schedule-job --name "my-task" --schedule "0 9 * * *" --prompt "Выполнить задачу"

# Управление
systemctl --user start opencode-job-<name>.timer    # Запустить
systemctl --user enable opencode-job-<name>.timer   # Автозапуск
systemctl --user status opencode-job-<name>.timer   # Статус
opencode delete-job <name>                          # Удалить
```

## Формат расписания (cron)

```
* * * * *
│ │ │ │ └─── День недели (0-7)
│ │ │ └───── Месяц (1-12)
│ │ └─────── День месяца (1-31)
│ └───────── Час (0-23)
└─────────── Минута (0-59)
```

| Расписание | Описание |
|------------|----------|
| `0 9 * * *` | Каждый день в 9:00 |
| `0 17 * * 5` | Пятница в 17:00 |
| `0 20 * * 0` | Воскресенье в 20:00 |
| `0 19 15 * *` | 15-го числа в 19:00 |
| `0 */6 * * *` | Каждые 6 часов |

## Структура файлов

Задачи хранятся в `~/.config/systemd/user/`:

**Таймер** (`opencode-job-<name>.timer`):
```ini
[Unit]
Description=Timer for: my-task

[Timer]
OnCalendar=*-*-* 09:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

**Сервис** (`opencode-job-<name>.service`):
```ini
[Unit]
Description=OpenCode Job: my-task

[Service]
Type=oneshot
WorkingDirectory=%h/git/project
ExecStart=/bin/bash -c '%h/.local/bin/opencode run -- "Ваш промпт"'
StandardOutput=append:%h/.config/opencode/logs/my-task.log
StandardError=append:%h/.config/opencode/logs/my-task.log

[Install]
WantedBy=default.target
```

## Отладка

```bash
# Логи
journalctl --user -u opencode-job-<name>.service -n 50

# Ручной запуск
systemctl --user start opencode-job-<name>.service

# Перезагрузка конфигурации
systemctl --user daemon-reload
systemctl --user restart opencode-job-<name>.timer
```

## Лучшие практики

- **Именование**: `daily-backup`, `weekly-report` вместо `job1`, `task2`
- **Логи**: Всегда указывайте `StandardOutput/Error` с путём к логу
- **Пути**: В systemd используйте `%h` для home директории (например `%h/git/project`)
- **Промпты**: Для сложных промптов используйте `ExecStart=/bin/bash -c '...'`
- **Скрипты**: Для сложной логики создавайте отдельный `.sh` скрипт в `~/.config/opencode/jobs/`

## Создание задачи со скриптом

Для сложных задач (чтение файлов, обработка данных):

```bash
cd .opencode/tools/periodic-jobs
./create_job_with_script.sh my-task "0 9 * * *" ~/project "*.md"
```

Или используй вспомогательные скрипты:

| Скрипт | Описание |
|--------|----------|
| `create_job.sh` | Создать простую задачу |
| `create_job_with_script.sh` | Создать задачу с кастомным скриптом |
| `list_jobs.sh` | Показать все задачи |
| `delete_job.sh` | Удалить задачу |

## Важные нюансы bash-скриптов

### 1. Обработка файлов с пробелами
```bash
# ❌ Неправильно — разбивает по пробелам
for file in $FILES; do cat "$file"; done

# ✅ Правильно — сохраняет целостность имён
while IFS= read -r file; do cat "$file"; done <<< "$FILES"
```

### 2. Спецсимволы в промптах
```bash
# ❌ Неправильно — скобки () интерпретируются bash
PROMPT="Текст (с скобками)"

# ✅ Правильно — используйте heredoc
PROMPT=$(cat <<EOF
Текст (с скобками)
EOF
)
```

### 3. Проверка синтаксиса
```bash
bash -n ~/.config/opencode/jobs/my-task.sh
echo $?  # 0 = OK
```

## Устранение неполадок

```bash
# Проверка синтаксиса
systemd-analyze --user verify opencode-job-<name>.service

# Таймер не стартует
systemctl --user daemon-reload
systemctl --user enable opencode-job-<name>.timer
systemctl --user start opencode-job-<name>.timer
```

## Ссылки

- [systemd.timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- [crontab.guru](https://crontab.guru/)
