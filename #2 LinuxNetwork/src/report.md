
# Сети в Linux

Настройка сетей в Linux на виртуальных машинах.


## Contents
1. [Инструмент ipcalc](#part-1-инструмент-ipcalc) \
2. [Статическая маршрутизация между двумя машинами](#part-2-статическая-маршрутизация-между-двумя-машинами) \
3. [Утилита iperf3](#part-3-утилита-iperf3) \
4. [Сетевой экран](#part-4-сетевой-экран) \
5. [Статическая маршрутизация сети](#part-5-статическая-маршрутизация-сети) \
6. [Динамическая настройка IP с помощью DHCP](#part-6-динамическая-настройка-ip-с-помощью-dhcp) \
7. [NAT](#part-7-nat) \
8. [Допополнительно. Знакомство с SSH Tunnels](#part-8-дополнительно-знакомство-с-ssh-tunnels)

## Part 1. Инструмент **ipcalc**

#### 1.1. Сети и маски
Для установки вводим `sudo apt-get ipcalc`
1) Адрес сети [*192.167.38.54/13*] равен *192.160.0.0/13* \
    ![Host](https://sun9-west.userapi.com/sun9-68/s/v1/ig2/Ajzz6ebqTYPWcj37JA6vBF0e2UIJ4mzViN04JAKlU2VWdBbmGmEc0Np9VjwPXKoGBE2CdHon9tVJ5jbQd7Wr_HLU.jpg?size=555x165&quality=96&type=album)
2) Перевод маски
    1. [*255.255.255.0*]: \
    в префиксную - */24*, \
в двоичную запись *11111111.11111111.11111111.00000000*; \
    ![Translate](https://sun9-east.userapi.com/sun9-44/s/v1/ig2/3rUN4iQ1w428segOBlGbfjUcoP1TuBlVuBt13sjZPF6mis0NgFn4ANf-X2CxnxqPpzEBRjU-gVEbVYE2nzWtkbRE.jpg?size=559x67&quality=96&type=album)
    2. [*/15*]: \
    в обычную *255.254.0.0*, \
    в двоичную 11111111.11111110.00000000.00000000; \
    ![Translate](https://sun9-west.userapi.com/sun9-54/s/v1/ig2/8TQDTEYSA2YAQCYB9jd_GFn_8gNmOnHi37-JkknpLyhw1SMVau_GO3_dO59kQKAZbiPVSgK9EEoK1lxjihV6yb28.jpg?size=553x67&quality=96&type=album)
    3. [*11111111.11111111.11111111.11110000*]: \
    в обычную *255.255.255.240*, \
    в префиксную /28. \
    ![Translate](https://sun1.userapi.com/sun1-93/s/v1/ig2/O89rTU18Cycjq8VihtNLrcsbyqRTKorWim1iNQx_xHPIsBzPpIjmHsGV9BlUeyQqji8GjEBoxPdbwbtMNGqWob33.jpg?size=602x64&quality=96&type=album)
3) Минимальный и максимальный хост в сети [*12.167.38.4*] при масках:
    1. */8* - [12.0.0.1 - 12.255.255.254];
    2. *11111111.11111111.00000000.00000000* - [12.167.0.1 - 12.167.255.254];
    3. *255.255.254.0* - [12.167.38.1 - 12.167.39.254];
    4. */4* - [0.0.0.1 - 15.255.255.254]. \
    ![Hosts](https://sun9-west.userapi.com/sun9-38/s/v1/ig2/GxFzzYwyodJrfZtpX0tuDas6bsfjy-ssn0pPVhl1kDSnvXvUqJCm7Z12UjtWj6Bu3CSXlsaN3gvd2spCKioKYg7F.jpg?size=559x698&quality=96&type=album)

#### 1.2. localhost
- Можно ли обратиться к приложению, работающему на localhost, со следующими IP:
    1. [194.34.23.100] - нет;
    2. [127.0.0.2] - да;
    3. [127.1.0.1] - да;
    4. [128.0.0.1] - нет. \
    ![LocalHost](https://sun9-west.userapi.com/sun9-49/s/v1/ig2/0-JDP8bEfxglTxbvIr97zMfvKvLDAh4-JSqHx6ln9u179CLAPrdsJCCPiackys2aCite2TqgTmitW4mhuxVU_NaJ.jpg?size=519x438&quality=96&type=album)

#### 1.3. Диапазоны и сегменты сетей
1) Какие из перечисленных IP можно использовать в качестве публичного, а какие только в качестве частных: \
    [10.0.0.45] - частный \
    [134.43.0.2] - публичный \
    [192.168.4.2] - частный \
    [172.20.250.4] - частный \
    [172.0.2.1] - публичный \
    [192.172.0.1] - публичный \
    [172.68.0.2] -  публичный \
    [172.16.255.255] - частный (но не используется как адрес - broadcast) \
    [10.10.10.10] - частный \
    [192.169.168.1] -  публичный
2) Какие из перечисленных IP адресов шлюза возможны у сети *10.10.0.0/18*:   \
    [10.0.0.1] - нет \
    [10.10.0.2] - да \
    [10.10.10.10] - да \
    [10.10.100.1] - нет \
    [10.10.1.255] - да

## Part 2. Статическая маршрутизация между двумя машинами
1) Поднять две виртуальные машины (далее -- ws1 и ws2) \
С помощью команды `ip a` посмотреть существующие сетевые интерфейсы \
    **ws1** \
    ![ip-a-ws1](https://sun9-west.userapi.com/sun9-15/s/v1/ig2/J9BkNgZ4NkUoxs86eq_cgBXoFFUTzptrJ1SfxFNEDg4qOFb6xXBaBCVMk5uUcvYrLj2LjlB_sBMTAKhkKcDSU9xY.jpg?size=801x358&quality=96&type=album) \
    **ws2** \
    ![ip-a-ws2](https://sun9-east.userapi.com/sun9-74/s/v1/ig2/Xe9xFVL5-dm6eNk94hncwt-UUEl8Z44Q-LVaRGXKpL2MmX5WG_BTrwJGWSNwH0QL21oWrC4HAf9UYzQo_aj7c3xO.jpg?size=801x358&quality=96&type=album)
2) Описать сетевой интерфейс, соответствующий внутренней сети, на обеих машинах и задать следующие адреса и маски: ws1 - 192.168.100.10, маска /16, ws2 - 172.24.116.8, маска /12 \
    **ws1** \
    ![yaml-ws1](https://sun9-west.userapi.com/sun9-5/s/v1/ig2/e4IpiuZ9QAGXX1CGax4Y3bEXiDD9R8oKchssHe-aJFwoGws5hzjm6YzhXRl6uB3_KY9XM-RUjxMbKmj7p4UYK3yM.jpg?size=436x179&quality=96&type=album) \
    **ws2** \
    ![yaml-ws2](https://sun1.userapi.com/sun1-13/s/v1/ig2/NXMZy6JPePoGbw9VvPpRbKfgRvpT6gXazbyKTP1-_MRnmODueQW9ErwKk-e3adqjsmzv1acVNgXRa7TgU5DB1Wkl.jpg?size=432x178&quality=96&type=album)
3) Выполнить команду netplan apply для перезапуска сервиса сети \
    **ws1** \
    ![netplan-apply-ws1](https://sun9-east.userapi.com/sun9-74/s/v1/ig2/kfhJE-5ICzE3kI52htw-3oNb2kmyULNjCUnBlQS9MY7_wt3Du0gZkpPzS1LkRUQ306xw_i4EhJ1lSBSVU-6nUYM1.jpg?size=238x50&quality=96&type=album) \
    **ws2** \
    ![netplan-apply-ws2](https://sun9-west.userapi.com/sun9-68/s/v1/ig2/zjwALLpztqfRnKpJfrdOdZpiHVQlnWqlVPYux6IGWqPWa5snFDCtUg3FC3vcJOQjF-ijzrlOHum41oHkvHxT-0yN.jpg?size=239x49&quality=96&type=album)
### 2.1 Добавление статического маршрута вручную
1) Добавить статический маршрут от одной машины до другой и обратно при помощи команды вида ip r add, пропинговать соединение между машинами \
    **ws1** \
    ![ip-r-add-ws1](https://sun9-west.userapi.com/sun9-55/s/v1/ig2/yZLqxLl_E6IQ-jVfXmBYpouTr2twbuZhFo-c39Ifq3LDJYnhvTtXCStt5poMHEfZwFhkCkVRzJHgB1t0zs2WPB9v.jpg?size=558x274&quality=96&type=album) \
    **ws2** \
    ![ip-r-add-ws2](https://sun9-west.userapi.com/sun9-63/s/v1/ig2/5BUgvmUjuxmENqfNJKnAJwgVkWC_i3JufVyjFdC4sZJLgoUoeshsK1RvKQycgLPLwf9n8MegXzfw9GWm-uleoJ4B.jpg?size=549x275&quality=96&type=album)
### 2.1 Добавление статического маршрута с сохранением
1) Перезапустить машины
2) Добавить статический маршрут от одной машины до другой с помощью файла etc/netplan/00-installer-config.yaml \
    **ws1** \
    ![netplan-route-ws1](https://sun9-west.userapi.com/sun9-53/s/v1/ig2/Cn62Thhl4gNFjWiJe8JwGOIMvqMfHMSw6lV6QMoICYNsooAAoFabtrQ32KfKPCwg_l-j0RSzvkxQcoi6lUVo0X0H.jpg?size=424x224&quality=96&type=album) \
    **ws2** \
    ![netplan-route-ws2](https://sun9-west.userapi.com/sun9-14/s/v1/ig2/RpldjIrYQVfAoMoLZqoDcakhEX_sVhu9I5FUv4csQtXJ8zdTrYZAMLx1sZl1fLKFWfZhedmJc3L5jRZaROwww2VA.jpg?size=418x224&quality=96&type=album)

3) Пропинговать соединение между машинами \
    **ws1** \
    ![netplan-route-ws1](https://sun9-east.userapi.com/sun9-17/s/v1/ig2/MZ3TnSJ4f0nmnmxgex9IKKylVnDYIhN2Ei9H6_177tsPzJV7KaWqHI7EJI8j61dUEof6w7HYKvRxBPgwPxr39YxH.jpg?size=514x150&quality=96&type=album) \
    **ws2** \
    ![netplan-route-ws2](https://sun9-west.userapi.com/sun9-13/s/v1/ig2/jSBz7o7EIrulQuychnZmhLAuPiTbHhQWgOxpRxssdAV5XpT95xAOjz0ZCpfY__Hlsn0OBFqukA41jQUONU5RCjA3.jpg?size=514x179&quality=96&type=album)

## Part 3. Утилита iperf3
### 3.1. Скорость соединения
`8Mpbs = 1MB/s; 100 MB/s = 819200 Kbps; 1Gbps = 1024 Mbps`
### 3.2. Утилита **iperf3**
**Установка** - `sudo apt install iperf3`
1) Запуск сервера на одной машине с помощью `iperf3 -s`
2) Подключение к серверу на другой машине с помощью `iperf3 -c <ip>`
3) Полученная скорость соединения: \
    ![iperf3](https://sun9-north.userapi.com/sun9-85/s/v1/ig2/uNSLUOvo-B2kYxrLsJhnfgtsbo15pHcLv-T7-JnxMJTvObGbSXHVklf0hhw-oYpA-eeN2b_CvJ-lO1QSW1pTNvAU.jpg?size=1280x372&quality=96&type=album)
## Part 4. Сетевой экран
#### 4.1. Утилита **iptables**
* Для того чтобы создать имитацию `firewall` создадим **bash** скрипт с помощью `sudo nano /etc/firewall.sh`
* На ws1 применить стратегию когда в начале пишется запрещающее правило, а в конце пишется разрешающее правило 
* На ws2 применить стратегию когда в начале пишется разрешающее правило, а в конце пишется запрещающее правило
* Открываем порты для доступа с помощью `iptables -A INPUT -p tcp --dport <NUMBER> -j ACCEPT`
* Правила задаем с помощью `iptables -A INPUT -p icmp --icmp-type echo-reply -j (ACCEPT/REJECT)`
* Написанные скрипты: \
    **ws1** \
    ![firewall-ws1](https://sun9-west.userapi.com/sun9-53/s/v1/ig2/RZg3TREerNR5tdx8OpX1AlAVsngJTq3gY8BZ1hK8zCo20joX-_R_e9nUDUuZnRw-zvShy8grxvaD-KauPSJ_HszA.jpg?size=478x210&quality=96&type=album) \
    **ws2** \
    ![firewall-ws2](https://sun9-west.userapi.com/sun9-39/s/v1/ig2/vqsU1L9BgqUGQJxbqOHou6UL866-MGZwsB8YDjZKKZUdK1ys-V1t6sB6kQ6TwkD2fawg6l-tBByNTelS6VMmz6C4.jpg?size=486x209&quality=96&type=album)
* Результат ping: \
    **ws1** \
    ![Ping-ws1](https://sun9-west.userapi.com/sun9-16/s/v1/ig2/rpy1fdXIun088VGVVcuB_fTAi9RHLGvsgInlN1fj5tQRrowT_yhJs1kVPmdbGgtdd8lxLLnGopjLC1cY5MP67OnI.jpg?size=527x115&quality=96&type=album) \
    **ws2** \
    ![Ping-ws2](https://sun9-north.userapi.com/sun9-88/s/v1/ig2/bYg2LQStUU7r4Y4HVi5VVjg98gZ9dE89Pmnxk11TgamTDl9HI1TmLxx7zzs0yPy4Mt3z4NyR-ujHVTk_8taPlQDQ.jpg?size=514x148&quality=96&type=album)
#### 4.2. Утилита **nmap**
Установим nmap командой `sudo apt install nmap`
* Командой ping проверить машину **ws2**, которая не "пингуется", после чего утилитой nmap показать, что хост машины запущен: \
![nmap](https://sun1.userapi.com/sun1-56/s/v1/ig2/npsDTOnM-zym3kp-Z7ES8VYrkp_MJ2yF0OvRRHA4BeiDprtguRAsLnONj-qgxdnO2jAruNGgDKRqx18ehBcsWGVY.jpg?size=518x226&quality=96&type=album)

## Part 5. Статическая маршрутизация сети

`-` Пока что мы соединяли всего две машины, но теперь пришло время для статической маршрутизации целой сети.

Сеть: \
<img src="../misc/images/part5_network.png" alt="part5_network" width="500"/>

#### 5.1. Настройка адресов машин
##### Настройка конфигурации машин в *etc/netplan/00-installer-config.yaml* согласно сети на рисунке.
- ws11 netplan \
![netplan-part-5-1](https://sun9-east.userapi.com/sun9-44/s/v1/ig2/PYurutaSzCLBHHrIzjhBeoh5YkTVnHqNuxNv0xA8XZJSOhMMmN4IJZoyc-6LuMlCXMhb9S8C_ij9y3THZ_GV1yjA.jpg?size=467x196&quality=96&type=album)
- r1 netplan \
![netplan-part-5-1](https://sun9-east.userapi.com/sun9-26/s/v1/ig2/_9kRRdhW-gET8ErX-5D4LTMMM-B0aPPgMGNeYr2aTGto_apBrKR8NOW5rkiXMU55gIzVjaiOuWOiim5NK9btGpSQ.jpg?size=462x290&quality=96&type=album)
- r2 netplan \
![netplan-part-5-1](https://sun9-east.userapi.com/sun9-59/s/v1/ig2/jZrvhdeSA2xckW-2RtodRYFS3GAMPjbolbiy1OrBIOkxx2FouhTAQZGNcw_hcvQa5dEmeybEJXtfa6VRg0ARGPZs.jpg?size=460x323&quality=96&type=album)
- ws21 netplan \
![netplan-part-5-1](https://sun9-east.userapi.com/sun9-76/s/v1/ig2/JswWheUkFBMS4FSneiQ5C6-pdjQTe7voz0AUgcRJQ1Hu_NbI2shsbDz_gje7EHJfvxfEughyIWE_rBHa_PG-119l.jpg?size=479x194&quality=96&type=album)
- ws22 netplan \
![netplan-part-5-1](https://sun9-east.userapi.com/sun9-32/s/v1/ig2/XyzU_m9qyRFwP3iTU7Eocw0hqrwgjo2SBCBzJbFjsdZFHuij0OwauuDLjeUSBM1_au5M0kAasnrflKST10avi43z.jpg?size=475x193&quality=96&type=album)
    
##### Перезапускаем сервис сети. Ошибок нет, теперь командой `ip -4 a` проверим, что адрес машины задан верно. Также пропинговать ws22 с ws21. Аналогично пропинговать r1 с ws11.
- ws11 `ip -4 a` \
![ip-4-a](https://sun9-west.userapi.com/sun9-15/s/v1/ig2/45PxUl3AeNB9cIseEizakrYp4J4QznxSaWW9k5j4vU8zuijwHTIYr_8N2psVOtPQEAALEBF0wwC6vWpiM12_dTB2.jpg?size=800x148&quality=96&type=album)
- r1 `ip -4 a` \
![ip-4-a](https://sun1.userapi.com/sun1-88/s/v1/ig2/YO55OOFGOMotN7AMpn6SSz2j0wy9LxPEd83UB8sWAa4SfJ3V1S7PX6AY-wv41Xpqp94rA5-2AAGLWtaspDiNlw88.jpg?size=801x213&quality=96&type=album)
- r2 `ip -4 a` \
![ip-4-a](https://sun9-west.userapi.com/sun9-47/s/v1/ig2/74Q7CgQeR0qXPAAFGevMjoOgVeKcMsNqp7h738c4bx9sH9jSoI2PCq6V3HcKUCOBB5RiNApRaUu4eNT9Fv2QxmSO.jpg?size=800x212&quality=96&type=album)
- ws21 `ip -4 a` \
![ip-4-a](https://sun9-west.userapi.com/sun9-13/s/v1/ig2/m2erJF0taFJ96mM-8w07Xh-nw-9PUh385aKQHClNIOVtQRqLfG0okJecPbrmxxqp-Hrk-CJhjcJvHjD6P3_r4WtV.jpg?size=800x155&quality=96&type=album)
- ws22 `ip -4 a` \
![netpip-4-a](https://sun1.userapi.com/sun1-17/s/v1/ig2/rEQpf02b3WKY_LTT44sO9b7B3ga5epOwmuj8eE1fXgUuuNQO-LjLNiK_3AdcXLayVbEnE1CAVhcqnXVBfx3-qWXc.jpg?size=800x157&quality=96&type=album)

#### 5.2. Включение переадресации IP-адресов.
##### Для включения переадресации IP, выполним команду на роутерах:
`sysctl -w net.ipv4.ip_forward=1`
- r1 \
![net.ipv4.ip_forward](https://sun1.userapi.com/sun1-97/s/v1/ig2/clYmfBmu0Wql7BDQkIcQc6TnmhEC8fzh4UXkCpOFVwO-cWR64-UtiFci7KA6ktescw1tLtVthkl0XDUHj7p72Vd4.jpg?size=421x52&quality=96&type=album)
- r2 \
![net.ipv4.ip_forward](https://sun9-west.userapi.com/sun9-64/s/v1/ig2/oKgWKREj9WQ39rP9sbyx8deXBhQja5UGbTK3biUAcJT7NJZI9Bdx4fzhNfiEptu3mPSSMrAwoeK3kVSE-0c6w8iq.jpg?size=428x51&quality=96&type=album)
##### Откройте файл */etc/sysctl.conf* и добавьте в него следующую строку:
`net.ipv4.ip_forward = 1`
- r1 \
![etc-sysctl](https://sun1.userapi.com/sun1-83/s/v1/ig2/UpNRq4OszpjYM5zMc_S8QzUr8MLNw2g3ZuxzKDp1TYLmKr1CH4hn1XfbuwVY_6IxZLNdQHgLRH-4kqSAvee0lOoT.jpg?size=802x672&quality=96&type=album)
- r2 \
![etc-sysctl](https://sun9-east.userapi.com/sun9-59/s/v1/ig2/J5WqQBXQe8Irderia4Fwn27wqyYen7G039hn6YO5lgtaMyBb0NYnGWd3S39chJDoJMf27ksteACaPVj1YhPox5AO.jpg?size=802x672&quality=96&type=album)

#### 5.3. Установка маршрута по-умолчанию
##### Настроим маршрут по-умолчанию(шлюз) для рабочих станций. Для этого добавим `default` вместо IP роутера в файле конфигураций
- ws21 \
![default-ws21](https://sun9-north.userapi.com/sun9-78/s/v1/ig2/elsT760Mhf77FaU0CyOHowtDE0qVPfy1d3ycgIebyMtvYsQ_T1r5TLyBv-S80iBWSGp8O7RMgPvcV7qpkfidsf9B.jpg?size=478x197&quality=96&type=album)
- ws22 \
![default-ws22](https://sun9-west.userapi.com/sun9-9/s/v1/ig2/VY2VdOWAyOEismCflkxZqReo2uJBZTiKuM34_RB9_wHut-7X4g49uRWj6iliX08nhYVM9VuTBe5Iq2usae1Uw-kE.jpg?size=468x199&quality=96&type=album)
##### Вызовем `ip r` и покажем, что добавился маршрут в таблицу маршрутизации
- ws21 \
![ip-r-ws21](https://sun1.userapi.com/sun1-21/s/v1/ig2/KmWQpPbJ259iUgvzOKdr8zmXWL4A6RYte1i_xFIc9_HEP6Kmew843mlexotmNzjpp-PdYSyHyvmm0S2T9KYVSpzt.jpg?size=512x67&quality=96&type=album)
- ws22 \
![ip-r-ws22](https://sun9-east.userapi.com/sun9-57/s/v1/ig2/-dG88m1vpUTctbXS-vysauHuJXFjZEUoYB8W_az5qLu_duBADcSGVp_KQSYH4Dwj4JcGKlrqanvyQLUYQgy2Zd3E.jpg?size=511x71&quality=96&type=album)
##### Пропингуем с ws11 роутер r2 и покажем на r2, что пинг доходит. Для этого используем команду:
`tcpdump -tn -i eth1`
- ping с ws11 до r2 \
![ping-ws11-r2](https://sun9-west.userapi.com/sun9-46/s/v1/ig2/lUsV7LVlBH7AMHG9wC6-FvvQ_NslH3R8EoNv-t-mpqXz8Y79nPb1QopZYfIxgeIXVeK-uv7ssw8yqWMC4iFv-adv.jpg?size=1024x260&quality=96&type=album)
- tcpdump на r2 \
![tcpdump](https://sun1.userapi.com/sun1-92/s/v1/ig2/Oa0vgXsGO-HVweWmh47C-Jqu3mrYButy99qNlGtVmq56yPWmLytZuGG4Lq4IWkch58BfwOk4KWSDPUrMuz8cAZpE.jpg?size=1280x435&quality=96&type=album)


#### 5.4. Добавление статических маршрутов
##### Добавить в роутеры r1 и r2 статические маршруты в файле конфигураций.
- netplan r1 \
![netplan-r1](https://sun9-east.userapi.com/sun9-18/s/v1/ig2/1aHmAzHvIFr9gZMV08YZa0dDseiBeg4Oxelt-KQbHYatHGMIXcnuYCQ5O6rS29eFpApA742yAm3Qs01kY9p9Yy8W.jpg?size=452x262&quality=96&type=album)
- netplan r2 \
![netplan-r2](https://sun9-west.userapi.com/sun9-66/s/v1/ig2/tgT-PQ3fCJPwbBY-0jMFqg3MoTCF6i36D2wtybHHHv00q2hESich-ENgagvlTGgdWxDATs5prdN8FnbaKKSnb_pA.jpg?size=468x260&quality=96&type=album)
##### Вызвать `ip r` и показать таблицы с маршрутами на обоих роутерах.
- r1 `ip r` \
![ip-r-r1-part-5-4](https://sun9-west.userapi.com/sun9-39/s/v1/ig2/S3XolsUS9RQvw8OnfPhWs_kHhqEnjHPDWIgiD9OGMT9TlMzCmT0Elgbkx3xmD51pMfpfJ0r54mQ9bTuDBhYmy4Yl.jpg?size=518x82&quality=96&type=album)
- r2 `ip r` \
![ip-r-r2-part-5-4](https://sun9-east.userapi.com/sun9-33/s/v1/ig2/xHOkWfDgXdt6_6kCP9kBJItfUP4kZuGh9mL0ijiHKRtsP841m3kE8GUkj1yLsifegSt7UfDPpmKIMfiIz67xhcTv.jpg?size=518x84&quality=96&type=album)

##### Запустить команды на ws11:
- `ip r list 10.10.0.0/[маска сети]` и `ip r list 0.0.0.0/0` \
![part-5-4-ws11](https://sun9-west.userapi.com/sun9-54/s/v1/ig2/mxGZvGC4C60Z6xqtmZkW22dNXM9lYGAEozAvObRsM1h1kZ1B5hlMViKnoQ4gAVoMH4WeEz28UuIND6adRLG9L_pX.jpg?size=501x99&quality=96&type=album) \
Для адреса 10.10.0.0/[порт сети] был выбран маршрут, отличный от 0.0.0.0/0, потому что маска /18 описывает маршрут к сети точнее, в отличие от маски /0.

#### 5.5. Построение списка маршрутизаторов
- Запустим на r1 команду `tcpdump -tnv -i eth0`
- Вывод команды `traceroute 10.20.0.10`: \
![part-5-5-ws11](https://sun9-west.userapi.com/sun9-56/s/v1/ig2/5eRGGffItRFE-Hv6VWfnR_A7wvoeuMqp8fLw3xzA-xkOX5p6h1CZCBD-4P2SBFBzqMNVKo9Xu9r5OOCy7zPIRcvZ.jpg?size=542x99&quality=96&type=album)
- Вывод дампа на r1: \
![part-5-5-r1](https://sun9-west.userapi.com/sun9-5/s/v1/ig2/6dOTxdOSWQxW6FKIZm-MXLdDgQqglOUlKD7ethABEi54l8LJ3x7fr8XXegq9TEtDcRf1IsEhJVKvKMCnv1yhgnrh.jpg?size=800x600&quality=96&type=album)

- Принцип работы: каждый пакет проходит на своем пути определенное количество узлов, пока достигнет своей цели. Причем, каждый пакет имеет свое время жизни. Это количество узлов, которые может пройти пакет перед тем, как он будет уничтожен. Этот параметр записывается в заголовке TTL, каждый маршрутизатор, через который будет проходить пакет уменьшает его на единицу. При TTL=0 пакет уничтожается, а отправителю отсылается сообщение Time Exceeded.Команда traceroute linux использует UDP пакеты. Она отправляет пакет с TTL=1 и смотрит адрес ответившего узла, дальше TTL=2, TTL=3 и так пока не достигнет цели. Каждый раз отправляется по три пакета и для каждого из них измеряется время прохождения. Пакет отправляется на случайный порт, который, скорее всего, не занят. Когда утилита traceroute получает сообщение от целевого узла о том, что порт недоступен трассировка считается завершенной.

#### 5.6. Использование протокола **ICMP** при маршрутизации
##### Запустить на r1 перехват сетевого трафика, проходящего через eth0 с помощью команды:
`tcpdump -n -i eth0 icmp`
##### Пропинговать с ws11 несуществующий IP *10.30.0.111*
- Вывод команды `ping -c 1 10.30.0.111`: \
![part-5-6-ws11](https://sun9-west.userapi.com/sun9-5/s/v1/ig2/GyLIi_u-JgNJus_rAsOwMUZq_sGRfjoiNnu_QHRVmMVCEjcxrVDmtADGzD7XHwJ0_eezV2Vpr9AfoZbj5xB46H9q.jpg?size=581x129&quality=96&type=album)
- Вывод дампа на r1: \
![part-5-6-r1](https://sun9-west.userapi.com/sun9-45/s/v1/ig2/bL4TSQW8IPZhfrJt20V8wpkckoDq6SarCZ9NcNxpURm_PS2GJXNBvL4nnQFSAvQade0bK8WH5_g9936rE_4aLIxq.jpg?size=689x88&quality=96&type=album)

## Part 6. Динамическая настройка IP с помощью **DHCP**

##### Для r2 настроим в файле */etc/dhcp/dhcpd.conf* конфигурацию службы **DHCP**:
##### 1) Укажем адрес маршрутизатора по-умолчанию, DNS-сервер и адрес внутренней сети. 
**r2** *dhcpd.conf* \
![dhcpd-conf-r2](https://sun9-north.userapi.com/sun9-79/s/v1/ig2/iHVa_wmeO6iPMtKxkP-hysbdVEfk_L5Uw5VUyDk2s_bMGL8JskdYUTwOa8uo71K-S6zzxFigO8ilFuJNw3FPU_Zc.jpg?size=360x150&quality=96&type=album) \
**ws21** `netplan` \
![part-6-netplan-ws21](https://sun9-east.userapi.com/sun9-32/s/v1/ig2/bzSfsuUC9FgeUMsw6yVHGPgv1OzjrQUZMlBHkoDqImoUzn6QAbLr01Oh3nzFe2H145e2t918cT1kCsugQ6r0WcM3.jpg?size=482x242&quality=96&type=album)
##### 2) в файле *resolv.conf* прописать `nameserver 8.8.8.8.`
![part-6](https://sun9-west.userapi.com/sun9-51/s/v1/ig2/hiyzygnF9FULSrj2uFsZv7agRzN4wVMD-dcKtG4IIBJy3eBQotEdRZcATA3MyuWMoSBpSgJldWLL6fBj4DIXFR0u.jpg?size=642x98&quality=96&type=album)
##### Перезагрузим службу **DHCP** командой `systemctl restart isc-dhcp-server`. Машину ws21 перезагрузим при помощи `reboot`.
**ws21** из `ip a` видим что ip изменился \
![part-6](https://sun9-east.userapi.com/sun9-25/s/v1/ig2/bXkZp8VWq0e8CHs3WFzkyGZogRiqGYDEZnFZEtU7HZhi3crONWz0Kugmh5QFwP_rzyO1s1jieuffkLUc2F3Efaif.jpg?size=800x241&quality=96&type=album) \
**ws21** пингуем до ws22 \
![part-6](https://sun9-west.userapi.com/sun9-72/s/v1/ig2/sh45eeaJ_BRKVpNtRpBZ1Yveg2t5Qaoix4iKbyN6-ytlNFg7674fFpIU4phFZ9kT8X0t_yI8LAk5U08f810WFaf5.jpg?size=509x163&quality=96&type=album)


##### Укажем MAC адрес у ws11, для этого в *etc/netplan/00-installer-config.yaml* надо добавить строки: `macaddress: 10:10:10:10:10:BA`, `dhcp4: true`
![part-6](https://sun9-north.userapi.com/sun9-84/s/v1/ig2/vXHI1zP6ARe73v65NrMHwxn9s23tLHzYDj4YXW_3BrM6CGik89uad5QI8zOBqnT2yM4G_7pc01pMJVb7mgNWXO1m.jpg?size=421x276&quality=96&type=album)
##### Для r1 настроим аналогично r2, но сделаем выдачу адресов с жесткой привязкой к MAC-адресу (ws11). Проведем аналогичные тесты.
**r1** *dhcpd.conf* \
![part-6](https://sun9-west.userapi.com/sun9-1/s/v1/ig2/YcD5qYMJ1Ji21o3PC6vHtT88PjvWS16QuxdiitQ_oa5PtmWuXEDBk-zRgU5A6Esp5rU6fadWhgf4J42fiSU1IdXf.jpg?size=368x227&quality=96&type=album) \
**r1** *resolv.conf* \
![part-6](https://sun9-west.userapi.com/sun9-51/s/v1/ig2/UzGD9Kwp4HBtKkQslkk0us4NHq4bx2wmMbO0bzDrQSWNaLdFZ-a9gCGugvfwY8zNlOdzM7_blabYsyXwPqrPtvgx.jpg?size=188x68&quality=96&type=album) \
**ws11** MAC \
![part-6](https://sun9-north.userapi.com/sun9-78/s/v1/ig2/rRa0NCvdbWleZjHCMHzPb8tlLk23gAFV1Oa43w0M7-vtx1dZfF-CrBU-xG3L54E3cubuY7G3-KeDYvgEzzcVA9pO.jpg?size=800x355&quality=96&type=album)
##### Запросить с ws21 обновление ip адреса
**ws21** вводим команду `ip a` \
![part-6-ip-a-ws21-ip-old](https://sun9-west.userapi.com/sun9-12/s/v1/ig2/cZuvuDBp0uxJJHM8w23OZV19I_JVgTEoJu2rFWEh2Bp8OQjwKHKyq2XLjJP-A9_z0k989ilHtKvP9ERi0Ldgz5rT.jpg?size=800x245&quality=96&type=album) \
**ws21** вводим команду `sudo dhclient enp0s8` для получения другого ip \
**ws21** вводим команду `ip a` \
![part-6-ip-a-ws21-ip-new](https://sun9-east.userapi.com/sun9-19/s/v1/ig2/eH5qqaASkfVJBvy-z1Rw9n51tlEmzprsrPanNJWsc9eWtctupYMy1gprAvn0spiCwEkcmT9Qd1ZWBVbtQvtg4eF-.jpg?size=800x244&quality=96&type=album)

## Part 7. **NAT**
##### В файле */etc/apache2/ports.conf* на ws22 и r1 изменим строку `Listen 80` на `Listen 0.0.0.0:80`, то есть сделаем сервер Apache2 общедоступным
**r1** \
![part-7-r1-apache-port](https://sun9-east.userapi.com/sun9-24/s/v1/ig2/xTr83M-2qhldeCgDly2BjMTCr2M5BNkw83P2l6TV_BA-TwgHx1dobO4w19OJDmcs4atPoYHV1lPqe_TsrdnxJcB9.jpg?size=366x319&quality=96&type=album) \
**ws22** \
![part-7-ws22-apache-port](https://sun9-east.userapi.com/sun9-76/s/v1/ig2/6-3QgxVaCpJ4GZ96LiDxpdd7dvOq5zrZwFVtoKawY06BQYvAPNjPR7dYyPJT-poMQ0pMjEmmwdIsCMrI1ngyaDWT.jpg?size=370x312&quality=96&type=album)

##### Запустим веб-сервер Apache командой `service apache2 start` на ws22 и r1
**r1** \
![part-7-r1-apache](https://sun9-east.userapi.com/sun9-20/s/v1/ig2/CARuPrzst6NSqXHRCZD-AjVbS-vtIdGOF8-NKDSa_1tkX6OImnDuBK5Eje460G8ggWPGwPpqDpFvCWX_zz_FKWBX.jpg?size=524x116&quality=96&type=album) \
**ws22** \
![part-7-ws22-apache](https://sun9-north.userapi.com/sun9-83/s/v1/ig2/wTfymgqQO4yaCwbSL6qn5-V70dkHkaKA-cfRVh_J1M2MQYLt2UUv8dqdHpyjxGsxDKwqgTSl9VThndhzxOQc2i4a.jpg?size=531x114&quality=96&type=album)
##### Добавим в фаервол, созданный по аналогии с фаерволом из Части 4, на r2 следующие правила:
##### 1) Удаление правил в таблице filter - `iptables -F`
##### 2) Удаление правил в таблице "NAT" - `iptables -F -t nat`
##### 3) Отбрасывать все маршрутизируемые пакеты - `iptables --policy FORWARD DROP`
**r2** *firewall.sh* \
![part-7-firewall-sh-r2](https://sun9-north.userapi.com/sun9-82/s/v1/ig2/L40Hb53DdMev5w26KoKO4RGSVo5uzO92GUbHqyX0Swo0CYeufUaARCxGi5YivqCgyDgiUjns5w0fKi0MM7ETb9-c.jpg?size=301x126&quality=96&type=album)
##### Запустим файл также, как в Части 4
**r2** \
![part-7-chmod-bash](https://sun9-east.userapi.com/sun9-32/s/v1/ig2/sWC1VYCQzC_AQvZDQ5LGQ_xeLu1m51x1vBPk6OpH5svx-iOH3JeprFDOG5sa_E9G9Pb1DD21E-XYVMZtwXzBrv_H.jpg?size=385x52&quality=96&type=album)
##### Проверим соединение между ws22 и r1 командой `ping`
**r1** \
![part-7-ping-r1](https://sun9-west.userapi.com/sun9-50/s/v1/ig2/QKNPh-FwyhEIySREvNj58JihdtY85RpRFXA1MPAmKqxwDE5kWzwVnKXnGpET0LDcLHxsGl2fsulNSU5x9t2Egv8f.jpg?size=516x114&quality=96&type=album)

##### Добавим в файл ещё одно правило:
##### 4) Разрешим маршрутизацию всех пакетов протокола **ICMP**
**r2** \
![part-7-firewall](https://sun9-east.userapi.com/sun9-74/s/v1/ig2/fvAUkiXheDAIuT_kMUkXFX8kiqZvtt9TlUjLAly9z7G5VY4MwNNWuFY8o7n-YSg6kVb4oR60NdEtl4ub3dPNdkha.jpg?size=318x170&quality=96&type=album)
##### Запустим файл также, как в Части 4
**r2** \
![part-7-chmod-bash](https://sun9-east.userapi.com/sun9-32/s/v1/ig2/sWC1VYCQzC_AQvZDQ5LGQ_xeLu1m51x1vBPk6OpH5svx-iOH3JeprFDOG5sa_E9G9Pb1DD21E-XYVMZtwXzBrv_H.jpg?size=385x52&quality=96&type=album)
##### Проверим соединение между ws22 и r1 командой `ping`
**ws22** \
![part-7-ping-ws22](https://sun1.userapi.com/sun1-20/s/v1/ig2/gqzQ5TtGErjMr7yJysmZfoq2p7hNq_vc3qfnTd0_xUWEW-Reuav5eqTttzXUAujj_eFXFpvatPuoczYlpSe9IwIt.jpg?size=490x132&quality=96&type=album)
##### Добавим в файл ещё два правила:
- Включить **SNAT**, а именно маскирование всех локальных ip из локальной сети, находящейся за r2 (по обозначениям из Части 5 - сеть 10.20.0.0)
- Включить **DNAT** на 8080 порт машины r2 и добавить к веб-серверу Apache, запущенному на ws22, доступ извне сети \
**r2** \
![part-7-snat-dnat](https://sun9-east.userapi.com/sun9-41/s/v1/ig2/s80rBo4LUgKktC6L17kWDnip8jjvKgvP5wP06XeQ13oOpV9FjfaWkYiJw8cF-_pwhrFrIplGYk7kDZBDaM76ywpa.jpg?size=791x217&quality=96&type=album)
##### Проверим соединение по TCP для **SNAT**, для этого с ws22 подключимся к серверу Apache на r1:
**ws22** \
![part-7-snat](https://sun9-east.userapi.com/sun9-20/s/v1/ig2/uQJhzZyPqmKZRQijjCi0jR_TZ0gOE2NiU4duZDnUidulQuvLUt1Q0-GSYepIrkIpUvs60qP2W7XyhfNa25jsig-H.jpg?size=324x86&quality=96&type=album)
##### Проверим соединение по TCP для **DNAT**, для этого с r1 подключиться к серверу Apache на ws22:
**r1** \
![part-7-dnat](https://sun9-west.userapi.com/sun9-55/s/v1/ig2/D8mkA4kpob7XYIxzSDQtQceSLo-J5x5KF6OzRvTeg7P7Cxv34d_OcbHDblfiCjP4HaNETTcl6LghrHqWbE83cKz8.jpg?size=291x81&quality=96&type=album)
