# Example to-do List Application

This repository is a simple to-do list manager that runs on Node.js.

## Getting started

Download [Docker Desktop](https://www.docker.com/products/docker-desktop) for Mac or Windows. Docker Compose will be automatically installed. 
On Linux, make sure you have the latest version of [Compose](https://docs.docker.com/compose/install/).

## Clone the repository

Open a terminal and clone this sample application.

```
 git clone https://github.com/dockersamples/todo-list-app
```

## Run the app

Navigate into the todo-list-app directory:

```
docker compose up -d --build
```

When you run this command, you should see an output like this:

```
[+] Running 4/4
✔ app 3 layers [⣿⣿⣿]      0B/0B            Pulled           7.1s
  ✔ e6f4e57cc59e Download complete                          0.9s
  ✔ df998480d81d Download complete                          1.0s
  ✔ 31e174fedd23 Download complete                          2.5s
[+] Running 2/4
  ⠸ Network todo-list-app_default           Created         0.3s
  ⠸ Volume "todo-list-app_todo-mysql-data"  Created         0.3s
  ✔ Container todo-list-app-app-1           Started         0.3s
  ✔ Container todo-list-app-mysql-1         Started         0.3s
```

## List the services

```
docker compose ps
NAME                    IMAGE            COMMAND                  SERVICE   CREATED          STATUS          PORTS
todo-list-app-app-1     node:18-alpine   "docker-entrypoint.s…"   app       24 seconds ago   Up 7 seconds    127.0.0.1:3000->3000/tcp
todo-list-app-mysql-1   mysql:8.0        "docker-entrypoint.s…"   mysql     24 seconds ago   Up 23 seconds   3306/tcp, 33060/tcp
```

If you look at the Docker Desktop GUI, you can see the containers and dive deeper into their configuration.




<img width="1330" alt="image" src="https://github.com/dockersamples/todo-list-app/assets/313480/d85a4bcf-e2c3-4917-9220-7d9b9a78dc54">


## Access the app

The to-do list app will be running at [http://localhost:3000](http://localhost:3000).

