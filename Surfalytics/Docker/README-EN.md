> [Start](../../README.md) >> Docker

# Surfalytics - Docker project

#docker #docker-compose #Dockerfile #wsl  

# Tasks

There will be few tasks:

- Creating a WebApp in a Python-based container
- Creating my own image based on Postgres

---

# Docker?

I think that a short description is needed - what Docker actually is. To put it very briefly - containers. Containers that take up minimal space and run like virtual machines. Advantages - faster deployment than classic virtual machines like VBOX, VMWARE, etc.

What does Docker consist of?

![](_att/Pasted%20image%2020231213194648.png)

Docker has Images. The image is a Linux distribution with nothing superfluous. For example, just the ubuntu operating system with a minimal set of packages and commands to start; you can install everything else yourself after launch.

> Reminds FreeBSD images, the latest bootonly version currently takes 97 Megabytes space only. There isn't even a package installer, but there is an installer for the package installer because it takes up less space xDDDD

Some images may be based on other images. For example, a Postgres database image is based on an image of some Linux operating system + an installed Postgres database. And nothing more.

Every time you start the Image (RUN), a new Container appears, i.e. running virtual machine. Now you work with it. The image will remain intact.

If, for example, you need to launch a web page that will retrieve data from a database, then most likely you will use two images together: an image with Apache (or an analogue) and an image with a database. They can be run as two containers (virtual machines) that run on the same network, but each unit does its own job. This minimizes settings between them and allows software updates and restores, as well as disaster recovery, to be carried out at minimal cost.

You also need to know that each launch of the Image is carried out with parameters; these parameters cannot be changed. But you can delete the created container and restart the image with different parameters.

---

# Creating a WebApp in a Python-based container image

The original task is described here [# Just Enough Docker](https://github.com/surfalytics/analytics-course/tree/main/00_prerequisites/03_just_enough_docker). You should just do it xD.

### Preparation

#### 1.

WebApp (web page) will be hosted using python.

Create a file `app.py` with the following code:

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

We need to create a virtual environment and install the necessary python libraries.

I work on Windows, so I did everything in WSL, first in Ubuntu 22.04, and then in 23.10.

Since we will be using a docker image of python, there is no need to install python itself, only the dependencies for the `flask` library.

Create an environment in the desired directory.

 ```bash
python3 -m venv venv
source venv/bin/activate
```

Download `flask` and collect dependencies.

```bash
pip install flask
pip freeze > requirements.txt
```

Run `app.py` to check the web page is working [http://localhost:80](http://localhost:80). 

```bash
python3 app.py
```

But here was the first problem - my user did not have rights to run flask in WSL, even root. I downloaded a fresh image of WSL Ubuntu 23.10, and there this command was already executed normally - the page started working.

I installed flask on 23.10 with the command below, but when creating the `Dockerfile` I used the command `pip install flask`.

```bash
python3.11 -m pip install flask
```


### Image running

Where to find, how to download images and how to run them - there are a lot of materials on the web. I won't repeat this.

Download the image on which our application will be built.

```bash
docker pull python:3.11
```

Container can be started:

- Run image via a command (for example, `docker run ubuntu`) with parameters.
- Build a new image using Dockerdile and run it.
- Run image using docker compose.

Via a command is not very suitable for us, because we still need to deliver our files there for execution. This case is solved easier for beginners using the Dockerfile.

A Dockerfile is a file that contains a description of what image we will take (as as basis) and what commands we will execute when creating new image.

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

In total, there are three files in our working directory:

```
web-py-app
    ├── Dockerfile
    ├── app.py
    └── requirements.txt
```

Create a new container. The command below will automatically take the Dockerfile as the source of instructions from the current directory.

```bash
docker build -t web-py-app:1.0 .
```

This is what the newly created image from this Dockerfile looks like for me.

```bash
root@DESKTOP-9DNLIPP:~# docker image ls
REPOSITORY      TAG       IMAGE ID       CREATED          SIZE
web-py-app      1.0       e8100985d697   3 days ago       1.05GB
python          3.11      3810972689cf   8 days ago       1.01GB
```

All that remains is to run the container and open [http://localhost:80](http://localhost:80). 

```bash
docker run -p 80:80 web-py-app
```


---

# Creating your own image based on Postgres

I have CSVs for which I have already created a schema during the SQL training process. After the 2nd DataLearn module, the `SuperStore` of 2000 rows is a bit small and it was necessary to test `EXPLAIN analysis` on larger dataset. I chose the analogue - [Cleaned Contoso Dataset](https://www.kaggle.com/datasets/bhanuthakurr/cleaned-contoso-dataset) at 2,5 Gb. You can see the relationship diagram [here](postgres/init.d/sqlfiles/relational_schema.png).

The final task is as follows:

- Create my own image with database
- A schema will be automatically created in the database when the image is running for the first time
- When the container starts, the path to the CSV files from my file system will be mounted
- All CSVs are imported into the database when the image is running for the first time

What will we get? The original CSV is always in one place. If all the CSVs are placed in an image, it will become 2.5 GB thick, which is not acceptable if it is constantly being used again. It is more profitable to get a database image with files for drawing the schema and a CSV import script, but without the CSVs themselves. The schema creation and import will be done only once at the first launch. When the container is launched further, all the data from the CSV will already be in the database and the path to the originals will be mounted.


## Running `docker run` with parameters

Let's test whether my scripts work at all. Contents of my directory:

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

The `init.d` folder contains what will go into the `/docker-entrypoint-initdb.d` directory in the container.

```bash
cat postgres/contosodb.sh

#!/bin/bash

psql -U postgres -c "CREATE DATABASE contoso"
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/create_tables_erdplus.sql
psql --dbname=contoso --username=postgres -f /docker-entrypoint-initdb.d/sqlfiles/insert_data2tables.sql
```

The `contosodb.sh` script is located directly in `init.d`. Docker help writes that everything in this folder will be launched automatically when the container is created - all the scripts that are there, and all .sql files, sorted by name.

Here is the creation of the diagram [create_tables_erdplus.sql](postgres/init.d/sqlfiles/create_tables_erdplus.sql) and import of CSV [insert_data2tables_linux.sql](postgres/init.d/sqlfiles/insert_data2tables_linux.sql).

Download Postgres image.

```bash
docker pull postgres:16.1
```

Run it.

```bash
docker run \
-p 5432:5432 --name postgres_contoso \
-e POSTGRES_PASSWORD=pass123 \
-v /mnt/d/sql:/sql \
-v /home/aikz/03_docker/postgres:/docker-entrypoint-initdb.d \
-d postgres:16.1
```

The container starts immediately, but importing CSV takes quite a lot of time on my machine, more than 20 minutes, because there are more than 30 million lines. You can slowly check the [logs](postgres/docker_posgres16.1_log.txt) (`docker logs postgres_contoso`) until you see the coveted line.

```
PostgreSQL init process complete; ready for start up.
```

After this, you can connect to the database from Ubuntu WSL on its own IP.

```bash
psql -U postgres -h 172.20.44.2 -d postgres 
```

So yes, everything is in place.


### Underwater rocks

When using bind mount you need to understand the following:

- `-v /mnt/d/sql:/sql` here I mount files from my Windows disk - everything is ok here, you can do this.
- `-v /home/aikz/03_docker/postgres:/docker-entrypoint-initdb.d` here I mount the directory from Ubuntu, because the script file created in Windows (even if it is copied subsequently to Ubuntu, and then to the container ) **will not work**. Only abuse in the form of `sed -i -e 's/\r$//' scriptname.sh` will help him, but this is absolutely not suitable for us; due to the encoding, the script does not start automatically when the container is initialized. Therefore, we create all .sh scripts directly from Linux; this does not apply to sql files.
- Nothing from the subfolders will be launched automatically, only from the root `init.d`. In my example, the sql files in `/docker-entrypoint-initdb.d/sqlfiles/` will remain untouched during initialization.


## Building image using Dockerfile

Contents of `Dockerfile`.

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

Create image.

```bash
docker build -t pg-contoso:1.0 .
```

Run container

```bash
docker run \
-p 5432:5432 --name postgres_contoso \
-v /mnt/d/sql:/sql \
-d pg-contoso:1.0
```

Wait for the treasured line in the logs.

```
PostgreSQL init process complete; ready for start up.
```


### Underwater rocks

- In the Dockerfile, the line `RUN --mount=type=bind,source=/mnt/d/sql,target=/sql` remains commented out. Docker help describes the command above as equivalent to `-v /mnt/d/sql:/sql`. However, in fact, it does not work like a bind mount, it copies all the contents into the image and it gets fatter. (If I'm wrong, write to me.)
- `COPY` wants relative paths, but does not accept absolute paths. The image must be built from the project directory. I don’t know whether this is a problem or not, but it’s a little strange. Perhaps this is only in WSL.


## Building image using docker-compose

Contents of `docker-compose-postgres.yaml`.

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

Run container.

```bash
docker-compose -f docker-compose-postgres.yaml up
```

Wait, the logs are showing, they look beautiful <3.

```bash
root@DESKTOP-9DNLIPP:/home/aikz/03_docker# docker ps

CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS                    NAMES
4fac944b5273   postgres:16.1   "docker-entrypoint.s…"   37 minutes ago   Up 37 minutes   0.0.0.0:5432->5432/tcp   pg-contoso-compose
```

Done.

---

# WSL and free disk space

While I was creating and deleting databases, I ran out of disk space...

First I deleted almost all containers.

![](_att/Pasted%20image%2020231213192218.png)

![](_att/Pasted%20image%2020231213190545.png)

But local volumes still have 16+ GB of space, despite the fact that there are no containers where anything is mounted.

![](_att/Pasted%20image%2020231213192046.png)

And the WSL Docker data folder has generally grown by 22+ GB.

```bash
root@DESKTOP-9DNLIPP:~# ls -al /mnt/c/Users/Yurii/AppData/Local/Docker/wsl/data/
total 22697984
drwxrwxrwx 1 root root         512 Dec  8 11:10 .
drwxrwxrwx 1 root root         512 Dec 13 16:35 ..
-rwxrwxrwx 1 root root 23242735616 Dec 14 13:49 ext4.vhdx
```

There are commands to clear data:

- `docker container prune` - remove all stopped installed containers
- `docker image prune` - delete images that are not referenced by any of the running containers
- `docker volume prune` - delete volumes
- `docker builder prune` - clear the build cache

I did that:

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

This helped me with volumes, but didn't help with data. The commands found did not help to clear the data. But the data can be cleared through the Docker Desktop application itself.

```
Troubleshoot > [Clean / Purge data] > (checkbox) [WSL 2] > [Delete]
```


---

# Docker commands

- `docker images` - list of images
- `docker image ls` - list of images

---

- `docker pull image-name-like-postgres` - download image from Docker Hub
- `docker run image-name-like-postgres` - first run of the container
- `docker stop <container id>/<container name>` - stop the container
- `docker start <container id>/<container name>` - restart the container
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

- `docker ps` - list of running containers
- `docker ps -a` - list of all containers
- `docker rm <container id>` - delete container

---

- `docker exec -it <container id> bash` - launch a terminal (command) inside container
- 
```bash
docker exec -it <container id> psql -U postgres -d contoso -c "SELECT SUM(sales_amount) AS total_sales FROM fact_sales"

  total_sales
----------------
 12413657287.90
(1 row)
```

- `docker-compose -f docker-compose-postgres.yaml up` run the container with settings from the yaml file

---

- `docker system df` - disk memory usage
- `docker container prune`
- `docker image prune`
- `docker volume prune`
- `docker builder prune`


---

# Useful links

- [TechWorld with Nana - Docker Tutorial for Beginners [FULL COURSE in 3 Hours]](https://www.youtube.com/watch?v=3c-iBn73dDE)
- [habr - Запускаем PostgreSQL в Docker: от простого к сложному](https://habr.com/ru/articles/578744/)
- [habr - Перенос Docker на другой диск в Windows](https://habr.com/ru/articles/766498/)
- [habr - Docker Tips: Очистите свою машину от хлама](https://habr.com/ru/articles/486200/)
- [habr - Bash-скрипты: начало](https://habr.com/ru/companies/ruvds/articles/325522/)



---

> [Start](../../README.md) >> Docker