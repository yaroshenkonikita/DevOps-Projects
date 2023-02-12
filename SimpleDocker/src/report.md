# Simple Docker

Введение в докер. Разработка простого докер образа для собственного сервера.


## Contents
  1. [Готовый докер](#part-1-готовый-докер)
  2. [Операции с контейнером](#part-2-операции-с-контейнером)
  3. [Мини веб-сервер](#part-3-мини-веб-сервер)
  4. [Свой докер](#part-4-свой-докер)
  5. [Dockle](#part-5-dockle)
  6. [Базовый Docker Compose](#part-6-базовый-docker-compose)


## Part 1. Готовый докер

В качестве конечной цели своей небольшой практики вы сразу выбрали написание докер образа для собственного веб сервера, а потому в начале вам нужно разобраться с уже готовым докер образом для сервера.
Ваш выбор пал на довольно простой **nginx**.

##### Возьмем официальный докер образ с **nginx** и выкачаем его при помощи
`docker pull nginx` \
![docker-pull-part-1](./images/docker-pull-part-1.png)
##### Проверим наличие докер образа через `docker images`
![docker-images-part-1](./images/docker-images-part-1.png)
##### Запустим докер образ через `docker run -d nginx`
![docker-run-image-id-nginx-part-1](./images/docker-run-image-id-nginx-part-1.png)
##### Проверим, что образ запустился через `docker ps`
![docker-ps-part-1](./images/docker-ps-part-1.png)
##### Посмотрим информацию о контейнере через `docker inspect container_id`
![docker-inspect-part-1](./images/docker-inspect-part-1.png)
##### По выводу команды определим размер контейнера, список замапленных портов и ip контейнера
ShmSize \
![docker-inspect-shm-size-part-1](./images/docker-inspect-shm-size-part-1.png) \
Port: 80 \
IP 172.17.0.2 \
![docker-inspect-port-ip-part-1](./images/docker-inspect-port-ip-part-1.png) \
`docker ps -as` \
![docker-container-size-part-1](./images/docker-container-size-part-1.png)
##### Остановим докер образ через `docker stop container_name`
![docker-stop-part-1](./images/docker-stop-part-1.png)
##### Проверим, что образ остановился через `docker ps`
![docker-ps-2-part-1](./images/docker-ps-2-part-1.png)
##### Запустим докер с замапленными портами 80 и 443 на локальную машину через команду:
![docker-container-run-part-1](./images/docker-container-run-part-1.png)
##### Проверим, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**
![localhost-nginx-part-1](./images/localhost-nginx-part-1.png)
##### Перезапустим докер контейнер через `docker restart container_id`
##### Проверим что контейнер запустился
![docker-restart-ps-part-1](./images/docker-restart-ps-part-1.png)

## Part 2. Операции с контейнером

Докер образ и контейнер готовы. Теперь можно покопаться в конфигурации **nginx** и отобразить статус страницы.

##### Прочитаем конфигурационный файл *nginx.conf* внутри докер контейнера через команду *exec*
![docker-exec-nginx-conf-part-2](./images/docker-exec-nginx-conf-part-2.png)
##### Создадим на локальной машине файл *nginx.conf* и настроим в нем по пути */status* отдачу страницы статуса сервера **nginx**
![docker-nginx-conf-status-part-2](./images/docker-nginx-conf-status-part-2.png)
##### Скопируем созданный файл *nginx.conf* внутрь докер образа через команду `docker cp`
![docker-cp-nginx-conf-part-2](./images/docker-cp-nginx-conf-part-2.png)
##### Перезапустим **nginx** внутри докер образа через команду *exec*
![docker-nginx-reload-part-2](./images/docker-nginx-reload-part-2.png)
##### Проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx**
Браузер: \
![docker-nginx-localhost-part-2](./images/docker-nginx-localhost-part-2.png) \
Curl: \
![docker-nginx-curl-part-2](./images/docker-nginx-curl-part-2.png)
##### Экспортируем контейнер в файл *container.tar* через команду *export*
![docker-export-container-part-2](./images/docker-export-container-part-2.png)
##### Остановим контейнер
![docker-stop-container-part-2](./images/docker-stop-container-part-2.png)
##### Удалим образ через `docker rmi repository`, не удаляя перед этим контейнер
![docker-rmi-image-part-2](./images/docker-rmi-image-part-2.png)
##### Удалим остановленный контейнер
![docker-rm-container-part-2](./images/docker-rm-container-part-2.png)
##### Импортируем контейнер обратно через команду *import*
![docker-import-image-part-2](./images/docker-import-image-part-2.png)
##### Запустим импортированный контейнер
![docker-run-import-container-part-2](./images/docker-run-import-container-part-2.png)
##### Проверим, что по адресу *localhost:80/status* отдается страничка со статусом сервера **nginx** командой curl:
![docker-curl-import-nginx-status-part-2](./images/docker-curl-import-nginx-status-part-2.png)

## Part 3. Мини веб-сервер

Настало время немного оторваться от докера, чтобы подготовиться к последнему этапу. Настало время написать свой сервер.

##### Напишем мини сервер на **C** и **FastCgi**, который будет возвращать простейшую страничку с надписью `Hello World!`
Установим нужные пакеты \
`sudo apt-get install libfcgi-dev` \
`sudo apt-get install spawn-fcgi`
##### Запустим написанный мини сервер через *spawn-fcgi* на порту 8080
`gcc fast_cgi.c -lfcgi -o hello` \
`spawn-fcgi -a 127.0.0.1 -p 8080 -f -n hello`
##### Напишем свой *nginx.conf*, который будет проксировать все запросы с 81 порта на *127.0.0.1:8080*
![nginx-conf-part-3](./images/nginx-conf-part-3.png)

##### Проверим, что в браузере по *localhost:81* отдается написанная нами страничка
Curl: \
![curl-localhost-81-part-3](./images/curl-localhost-81-part-3.png) \
Браузер: \
![browser-localhost-80-part-3](./images/browser-localhost-80-part-3.png)

## Part 4. Свой докер

Теперь всё готово. Можно приступать к написанию докер образа для созданного сервера.

#### Напишем свой докер образ, который:
##### 1) собирает исходники мини сервера на FastCgi из [Части 3](#part-3-мини-веб-сервер)
##### 2) запускает его на 8080 порту
##### 3) копирует внутрь образа написанный *./nginx/nginx.conf*
##### 4) запускает **nginx**.
Dockerfile: \
![Dockerfile-part-4](./images/Dockerfile-part-4.png) \
main.sh: \
![ENTRYPOINT-Dockerfile-part-4](./images/ENTRYPOINT-Dockerfile-part-4.png)

##### Соберем написанный докер образ через `docker build -t mod-nginx-fcgi:0.1 .`
##### Проверим через `docker images`, что все собралось корректно
![docker-images-part-4](./images/docker-images-part-4.png)
##### Запустим собранный докер образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**'а командой:
`docker run -d -p 80:81 mod-nginx-fcgi:0.1`
##### Проверим, что по localhost:80 доступна страничка написанного мини сервера
Браузер: \
![localhost-80-part-4](./images/localhost-80-part-4.png)
##### Допишем в *./nginx/nginx.conf* проксирование странички */status*, по которой надо отдавать статус сервера **nginx**
![nginx-conf-part-4](./images/nginx-conf-part-4.png)
##### Перезапустим докер образ
![restart-container-part-4](./images/restart-container-part-4.png)
##### Приверим, что теперь по *localhost:80/status* отдается страничка со статусом **nginx**
Браузер: \
![localhost-80-status-part-4](./images/localhost-80-status-part-4.png)

## Part 5. **Dockle**

После написания образа никогда не будет лишним проверить его на безопасность.

##### Просканируем образ из предыдущего задания через `dockle -ak NGINX_GPGKEY mod-nginx-fcgi:0.1`
![dockle-errors-part-5](./images/dockle-errors-part-5.png)
##### Исправим образ так, чтобы при проверке через **dockle** не было ошибок и предупреждений
![dockle-image-part-5](./images/dockle-image-part-5.png)

## Part 6. Базовый **Docker Compose**

Вот вы и закончили вашу разминку. А хотя погодите...
Почему бы не поэкспериментировать с развёртыванием проекта, состоящего сразу из нескольких докер образов?

##### Напишем файл *docker-compose.yml*, с помощью которого:
##### 1) Поднимем докер контейнер из [Части 5](#part-5-инструмент-dockle)
##### 2) Поднимем докер контейнер с **nginx**, который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера
##### Замапим 8080 порт второго контейнера на 80 порт локальной машины
![docker-compose-build-part-6](./images/docker-compose-part-6.png)

##### Остановим все запущенные контейнеры и соберем проект с помощью команды `docker-compose build` 
![docker-compose-build-part-6](./images/docker-compose-build-part-6.png)
##### Запустим проект с помощью команды `docker-compose up`
![docker-compose-up-part-6](./images/docker-compose-up-part-6.png)
##### И проверим, что в браузере по *localhost:80* отдается написанная нами страничка, как и ранее
Curl: \
![curl-localhost-part-6](./images/curl-localhost-part-6.png)
