> [Начало](../../README.md) >> Docker

# Surfalytics - Docker project

#docker #docker-compose #Dockerfile #wsl  

# Задания

Их будет несколько:

- Создание WebApp в контейнере на базе Python
- Создание собственного образа на базе Postgres

---

# Docker?

Считаю, что необходимо небольшое описание - что вообще такое Docker. Если очень кратко - контейнеры. Контейнеры, которые занимают минимальное количество места и работают как виртуальные машины. Преимущества - быстрое развертывание, нежели классические виртуальные машины по типу VBOX, VMWARE и т.п.

Из чего состоит Docker?

![](_att/Pasted%20image%2020231213194648.png)

У Docker'а есть Images (образы). Образ - это Linux дистрибутив, в котором нет ничего лишнего. Например, просто операционная система ubuntu с минимальным набором пакетов и команд для старта, все остальное можете поставить самостоятельно после запуска. 

> Напоминает образы FreeBSD, последняя версия bootonly на текущий момент занимает всего 97 Мегабайт. Там даже нет установщика пакетов, но есть установщик для установщика пакетов, потому что он занимает меньше места xDDDD

Одни образы, могут базироваться на других образах. Например, образ базы данных Postgres базируется на образе некоторой операционной системе Linux + установленная база данных Postgres. И больше ничего. 

Каждый раз при запуске Образа (RUN) появляется новый Контейнер, т.е. запущенная виртуальная машина. Теперь Вы работаете с ним. Образ останется нетронутым.

Если вам, например, нужно запустить вебстраницу, которая будет брать данные в базе данных, то скорее всего Вы будете использовать вместе два образа: образ с Apache (или аналог) и образ с базой данный. Их можно запустить как два контейнера (виртуальные машины), которые работают в одной сети, но каждый unit выполняет свою работу. Это минимизирует настройки между ними и позволяет минимальными затратами проводить обновления и восстановления ПО, а также восстановление после сбоев.

Еще нужно знать, что каждый запуск Образа выполняется с параметрами, изменить эти параметры нельзя. Но можно удалить созданный контейнер и запустить заново образ с другими параметрами. 

---

# Создание WebApp в контейнере на базе Python image

Оригинальная задача описана здесь [# Just Enough Docker](https://github.com/surfalytics/analytics-course/tree/main/00_prerequisites/03_just_enough_docker). Все что нужно было сделать - это выполнить xD.

### Подготовка

#### 1.

WebApp (вебстраничка) будет хоститься с помощью python. 

Создаем файл `app.py` с вот таким кодом:

```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)
```

#### 2.

Нам нужно сделать окружение (virtual environment) и установить нужные библиотеки python.

Я работаю на Windows, поэтому все действия делал в WSL, сначала в Ubuntu 22.04, а потом в 23.10. 

Поскольку мы будем использовать docker-образ python, то сам python устанавливать не надо, только зависимости для библиотеки `flask`.

В нужной директории создаем окружение.

 ```bash
python3 -m venv venv
source venv/bin/activate
```

Качаем `flask` и собираем зависимости.

```bash
pip install flask
pip freeze > requirements.txt
```

Запускаем `app.py` для проверки работы вебстраницы [http://localhost:80](http://localhost:80). 

```bash
python3 app.py
```

Но тут был первый косяк - для запуска flask'a в WSL у моего пользователя не было прав, даже у root'a. Я накатил свежий образ WSL Ubuntu 23.10, и там уже эта команда выполнилась нормально - страничка заработала. 

Ставил flask на 23.10 командой ниже, но при формировании `Dockerfile` использовал команду `pip install flask`.

```bash
python3.11 -m pip install flask
```


### Запуск образа

Где искать, как качать образы и как их запускать - материалов в сети навалом. Я не буду это повторять. 

Качаем образ, на котором будет построено наше приложение.

```bash
docker pull python:3.11
```

Запустить контейнер можно:

- Запустить образ через команду (например, `docker run ubuntu`) с параметрами.
- Создать новый образ, используя Dockerdile, и запустить его.
- Запустить образ, используя docker compose.

Через команду нам не очень подходит, потому что еще надо туда доставить наши файлы на выполнение. Через  Dockerfile для новичков этот вопрос решается проще.

Dockerfile - это файл, в котором есть описание какой образ мы возьмем (как основу) и какие команды выполним при создании нового образа.

```bash
nano Dockerfile
```

```dockerfile
# Use and official Python runtime as a parent iamge
FROM python:3.11

# Set the working directory in the containers
WORKDIR /app

#Cope the current directory contents into the container at /app
COPY . /app

# Install ant needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.py then the container launches
CMD ["python", "app.py"]
```

Итого в нашей рабочей директории есть три файла:

```
web-py-app
    ├── Dockerfile
    ├── app.py
    └── requirements.txt
```

Создаем новый контейнер. Команда ниже автоматически возьмет Dockerfile, как источник инструкций, из текущей директории.

```bash
docker build -t web-py-app:1.0 .
```

Вот так новый созданный образ из этого Dockerfile'a выглядят у меня.

```bash
root@DESKTOP-9DNLIPP:~# docker image ls
REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
web-py-app      1.0       e8100985d697   3 days ago       1.05GB
python          3.11      3810972689cf   8 days ago       1.01GB
```

Осталось запустить контейнер и открыть [http://localhost:80](http://localhost:80). 

```bash
docker run -p 80:80 web-py-app
```


---

# Создание собственного образа на базе Postgres

У меня есть CSV, для которых я уже создал схему в процессе тренировки SQL. После 2 модуля DataLearn `SuperStore` в 2000 строк немного маловат и надо было потестировать `EXPLAIN analyse` на чем-то более большом. Я выбрал аналог - [Cleaned Contoso Dataset](https://www.kaggle.com/datasets/bhanuthakurr/cleaned-contoso-dataset) на 2,5 Гб. Схему отношений можно посмотреть [тут](postgres/init.d/sqlfiles/relational_schema.png).

Итоговая задача стоит следующая: 

- Создать свой образ с БД
- Автоматически будет создаваться схема в БД при первом запуске образа
- При запуске контейнера будет монтироваться путь к CSV файлам из моей файловой системы
- Производится импорт всех CSV в БД при первом запуске образа

Что мы получим? Оригинал CSV всегда находится в одном месте. Если все CSV поместить в образ, то он потолстеет на 2,5 Гб, что не приемлемо, при постоянном его новом использовании. Выгоднее получить образ БД с файлами для отрисовки схемы и скриптом импорта CSV, но без самих CSV. Создание схемы и импорт будут производится только один раз при первом запуске. При дальнейшем запуске контейнера в БД уже будут находится все данные из CSV и путь к оригиналам будет смонтирован. 


## Запуск `docker run` с параметрами

Тестируем, работают ли вообще мои скрипты. Содержание моей директории:

```bash
postgres/
├── Dockerfile
├── docker-compose-postgres.yaml
├── docker_posgres16.1_log.txt
└── init.d
    ├── contosodb.sh
    └── sqlfiles
        ├── create_tables_erdplus.sql
        ├── insert_data2tables_linux.sql
        └── relational_schema.png
```

В папке `init.d` - находится то, что попадет в директорию `/docker-entrypoint-initdb.d` в контейнере.

```bash
cat postgres/contosodb.sh

#!/bin/bash

psql -U postgres -c "CREATE DATABASE contoso"
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/create_tables_erdplus.sql
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/insert_data2tables.sql
```

Скрипт `contosodb.sh` находится прямо в `init.d`. Справка Docker'a пишет что все что в этой папке - будет запущено автоматически при создании контейнера - все скрипты, что там находятся, и все .sql файлы в порядке сортировки по имени.

Тут создание схемы [create_tables_erdplus.sql](postgres/init.d/sqlfiles/create_tables_erdplus.sql) и импорт CSV [insert_data2tables_linux.sql](postgres/init.d/sqlfiles/insert_data2tables_linux.sql).

Качаем образ Postgres.

```bash
docker pull postgres:16.1
```

Запускаем его.

```bash
docker run \
-p 5432:5432 --name postgres_contoso \
-e POSTGRES_PASSWORD=pass123 \
-v /mnt/d/sql:/sql \
-v /home/aikz/03_docker/postgres:/docker-entrypoint-initdb.d \
-d postgres:16.1
```

Контейнер запускается сразу, но импорт CSV занимает на моей машине достаточно много времени, более 20 минут, т.к. там более 30 миллионов строк. Можно неспеша проверять [логи](postgres/docker_posgres16.1_log.txt) (`docker logs postgres_contoso`) пока не увидите заветную строку.

```
PostgreSQL init process complete; ready for start up.
```

После этого можно подключатся к БД из Ubuntu WSL на ее же IP.

```bash
psql -U postgres -h 172.20.44.2 -d postgres 
```

Таки да, все на месте.


### Подводные камни

Используя bind mount надо понимать следующее:

- `-v /mnt/d/sql:/sql` здесь я монтирую файлы с моего Windows диска - тут все ок, так можно делать.
- `-v /home/aikz/03_docker/postgres:/docker-entrypoint-initdb.d` здесь я монтирую директорию из Ubuntu, потому что файл скрипта, созданный в Windows (даже если будет скопирован впоследствии в Ubuntu, а потом в контейнер) **не будет работать**. Ему поможет только надругательство в виде `sed -i -e 's/\r$//' scriptname.sh`, а нам такое категорически не подходит, из-за кодировки скрип не стартует автоматом при инициализации контейнера. Поэтому все скрипты .sh создаем непосредственно из Linux, sql файлов это не касается.
- Из подпапок ничего автоматом не запустится, только из корня `init.d`. В моем примере sql файлы в `/docker-entrypoint-initdb.d/sqlfiles/` останутся нетронутыми при инициализации.


## Создание образа с использованием Dockerfile

Содержание `Dockerfile`'a.

```dockerfile
FROM postgres:16.1

#   New passwork for root-uwer 'postgres'
ENV POSTGRES_PASSWORD=pass123

#   Copy init script and sql files
COPY ./bash-scripts /docker-entrypoint-initdb.d

#   Bind Mount source with CSV files - In Fact > copies all CSV to image, not good
#   Absolute path doesn't works
#   Solution - bind mount when running image first time with "-v /path:/path/on/image"
#RUN --mount=type=bind,source=/mnt/d/sql,target=/sql

#   Container will listen that port for incoming connections
EXPOSE 5432

#
CMD ["postgres"]
```

Создаем образ.

```bash
docker build -t pg-contoso:1.0 .
```

Стартуем контейнер.

```bash
docker run \
-p 5432:5432 --name postgres_contoso \
-v /mnt/d/sql:/sql \
-d pg-contoso:1.0
```

Ждем заветную строку в логах.

```
PostgreSQL init process complete; ready for start up.
```


### Подводные камни

- В Dockerfile строка `RUN --mount=type=bind,source=/mnt/d/sql,target=/sql` осталась закомментирована. Справка Docker'a описывает команду выше равносильной `-v /mnt/d/sql:/sql`. Однако по факту она не работает как bind mount, она копирует все содержимое в образ и он толстеет. (Если я ошибаюсь, напишите мне.)
- `COPY` хочет относительные пути, абсолютные не кушает. Сборку образа делать надо из директории проекта. Проблема это или нет, не знаю - но это малость странно. Возможно это только в WSL.


## Создание образа с использованием docker-compose

Содержание `docker-compose-postgres.yaml`.

```dockerfile
services:
  postgres:
    container_name: pg-contoso-compose:1.0
    image: postgres:16.1
    environment:
#      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=pass123
#      - POSTGRES_DB=${POSTGRES_DB} #optional (specify default database instead of $POSTGRES_DB)
#      - PGDATA=/var/lib/postgresql/data/pgdata
    ports:
      - "5432:5432"
    volumes:
      - /mnt/d/sql:/sql
      - /home/aikz/03_docker/bash-scripts:/docker-entrypoint-initdb.d
```

Запускаем контейнер.

```bash
docker-compose -f docker-compose-postgres.yaml up
```

Ждем, показывает логи, выглядят красиво <3.

```bash
root@DESKTOP-9DNLIPP:/home/aikz/03_docker# docker ps

CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                    NAMES
4fac944b5273   postgres:16.1   "docker-entrypoint.s…"   37 minutes ago   Up 37 minutes   0.0.0.0:5432->5432/tcp   pg-contoso-compose
```

Готово.

---

# WSL и свободное место на диске

Пока я создавал базы и удалял, закончилось место на диске...

Сначала удалил почти все контейнеры.

![](_att/Pasted%20image%2020231213192218.png)

![](_att/Pasted%20image%2020231213190545.png)

Но в локальных томах все равно висит 16+ Гб места, при том что нет контейнеров, где смонтировано хоть что-то.

![](_att/Pasted%20image%2020231213192046.png)

А папка данных WSL Docker'а вообще потолстела на 22+ Гб.

```bash
root@DESKTOP-9DNLIPP:~# ls -al /mnt/c/Users/Yurii/AppData/Local/Docker/wsl/data/
total 22697984
drwxrwxrwx 1 root root         512 Dec  8 11:10 .
drwxrwxrwx 1 root root         512 Dec 13 16:35 ..
-rwxrwxrwx 1 root root 23242735616 Dec 14 13:49 ext4.vhdx
```

Есть такие команды, для очистки данных:

- `docker container prune` - удалить все остановленные установленные контейнеры
- `docker image prune` - удалить образы, на которые не ссылается ни один из запущенных контейнеров
- `docker volume prune` - удалить тома
- `docker builder prune` - почистить кэш сборки

Я выполнил это:

```bash
root@DESKTOP-9DNLIPP:~# docker volume prune

WARNING! This will remove anonymous local volumes not used by at least one container.
Are you sure you want to continue? [y/N] y
Deleted Volumes:
06f6ed81fe98a5d76d6b1ef752912198e98b9f5df2f3033f7b0c6e8d8c02570f
...
f341fb74b80efc74767cf15b1b175c3ed3b958ddc6ee5f91eb8611f99921b7b5

Total reclaimed space: 16.52GB
```

Это помогло мне с томами, но не помогло с данными. Для очистки данных найденные команды не помогли. Но данные можно очистить через само приложение Docker Desktop.

```
Troubleshoot > [Clean / Purge data] > (checkbox) [WSL 2] > [Delete]
```


---

# Docker команды

- `docker images` - список образов
- `docker image ls` - список образов

---

- `docker pull image-name-like-postgres` - скачать образ из Docker Hub
- `docker run image-name-like-postgres` - первый запуск контейнера
- `docker stop <container id>/<container name>` - остановка контейнера
- `docker start <container id>/<container name>` - повторный запуск контейнера
- 
```bash
docker run \
-p 5432:5432 --name postgres_contoso \
-e POSTGRES_PASSWORD=pass123 \
-v /mnt/d/sql:/sql \
-v /home/aikz/03_docker/bash-scripts:/docker-entrypoint-initdb.d \
-d postgres:16.1
```

```
-p - проброс портов
-e - указание переменных окружения
-v - монтирование томов
-d - Detached mode / Отдельный режим - запуск контейнера в фоновом режиме
--name - имя контейнера
```

---

- `docker ps` - список запущенных контейнеров
- `docker ps -a` - список всех контейнеров
- `docker rm <container id>` - удалить контейнер

---

- `docker exec -it <container id> bash` - запуск терминала(команды) внутри контейнера
- 
```bash
docker exec -it <container id> psql -U postgres -d contoso -c "SELECT SUM(sales_amount) AS total_sales FROM fact_sales"

  total_sales
----------------
 12413657287.90
(1 row)
```

- `docker-compose -f docker-compose-postgres.yaml up` запуск контейнера с настройками из yaml файла

---

- `docker system df` - использование памяти на дисках
- `docker container prune`
- `docker image prune`
- `docker volume prune`
- `docker builder prune`


---

# Полезные ссылки

- [TechWorld with Nana - Docker Tutorial for Beginners [FULL COURSE in 3 Hours]](https://www.youtube.com/watch?v=3c-iBn73dDE)
- [habr - Запускаем PostgreSQL в Docker: от простого к сложному](https://habr.com/ru/articles/578744/)
- [habr - Перенос Docker на другой диск в Windows](https://habr.com/ru/articles/766498/)
- [habr - Docker Tips: Очистите свою машину от хлама](https://habr.com/ru/articles/486200/)
- [habr - Bash-скрипты: начало](https://habr.com/ru/companies/ruvds/articles/325522/)



---

> [Начало](../../README.md) >> Docker