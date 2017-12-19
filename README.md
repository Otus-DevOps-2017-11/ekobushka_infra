DevOps Homework-06 by Eugeny Kobushka
-------------------------------------

***
**Задание:**
  * Создайте новую ветку Infra-2 в вашем репозитории в организации DevOps 2017-11 для выполнения данного ДЗ;
  * Добавьте, созданные в ходе работы скрипты в эту ветку;
  * Добавьте информацию о данном ДЗ в README.md;
  * Создайте Pull Request для ветки мастер и добавьте в ревьюверы Nklya
(Nikolay Antsiferov);
  * Добавьте "Labels" gcp и homework-06 к вашему Pull Request

Команды по настройке системы и деплоя приложения нужно завернуть в баш скрипты, чтобы не вбивать эти команды вручную:
* скрипт install_ruby.sh - должен содержать команды по установке руби;
* скрипт install_mongodb.sh - должен содержать команды по установке MongoDB;
* скрипт deploy.sh - должен содержать команды скачивания кода, установки зависимостей через bundler и запуск приложения.

**Дополнительное задание:**<br>
В качестве доп задания используйте созданные ранее
скрипты для создания Startup script, который будет
запускаться при создании инстанса. Передавать Startup
скрипт необходимо как доп опцию уже использованной
ранее команде gcloud. В результате применения данной
команды gcloud мы должны получать инстанс с уже
запущенным приложением. Startup скрипт необходимо
закомитить, а используемую команду gcloud вставить в
описание репозитория (README.md)

***

В ходе выполнения задания созданы скрипты:<br>
* **install_ruby.sh** - устанавливает руби и после установки выдает информацию о версии установленного ruby и bundle;
* **install_mongodb.sh** - устанавливает MongoDB и после выполнения показывает статус службы MongoDB;
* **deploy.sh** - скачивает из репозитория наше приложение, проверяет и устанавливает необходимые зависимости, и после выполнения показывает порт на котором выполняется наше приложение.

После создания виртуального хоста на Google Cloud Platform и получения IP-адреса можно выполнить полученные скрипты без копирования на удаленный сервер. Для этого выполняет следующие команды:
```bash
$ ssh -i ~/work/git/ssh-key-home05/ekobushka ekobushka@35.189.226.248 'bash -s' < ./install_ruby.sh
```
В случае успешного выполнения получим в выводе следующие строки:
```bash
   ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
   Bundler version 1.11.2
```
Далее устанавливаем MongoDB таким же способом:
```bash
$ ssh -i ~/work/git/ssh-key-home05/ekobushka ekobushka@35.189.226.248 'bash -s' < ./install_mongodb.sh
```

В случае успешной установки в выводе получим статус установленной службы:
```bash
● mongod.service - High-performance, schema-free document-oriented database
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2017-12-15 03:24:20 UTC; 236ms ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 9573 (mongod)
   CGroup: /system.slice/mongod.service
           └─9573 /usr/bin/mongod --quiet --config /etc/mongod.conf

Dec 15 03:24:20 reddit-app systemd[1]: Started High-performance, schema-free document-oriented database.
```
Ну и последняя операция - деплой нашего приложения.
```bash
$ ssh -i ~/work/git/ssh-key-home05/ekobushka ekobushka@35.189.226.248 'bash -s' < ./deploy.sh
```
В случае успешного деплоя получим в выводе порт на котором работает наше приложение:
```bash
ekobush+ 10394  0.4  1.5 523624 26932 ?        Sl   03:52   0:00 puma 3.10.0 (tcp://0.0.0.0:9292) [reddit]
```
Открыв web-станичку нашего приложения убеждаемся что все работает...

На основе полученных скриптов создаем startup_script.sh который будем использовать для автоматического создания виртуального хоста полностью настроенного и готового к работе нашего приложения.

Чтобы использовать полученный скрипт нужно в команду gcloud добавить ключ --metadata и добавить наш скрипт прямо из репозитория. Полученная команда указана ниже:
```bash
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --zone=europe-west1-b \
  --metadata "startup-script-url=https://raw.githubusercontent.com/Otus-DevOps-2017-11/ekobushka_infra/Infra-2/startup_script.sh"
```
Для того чтобы использовать скрипт находящийся на локальном хосте, нужно использовать вместо опции startup-script-url использовать startup-script. Предыдущую команду нужно изменить в опции
```bash
--metadata-from-file startup-script=startup_script.sh
```
и запускать ее нужно в папке содержащей скрипт **startup_script.sh**

После выполнения данной команды получим соданный виртуальный хост с полностью рабочим приложением.

***
В процессе выполнения домашнего задания понадобился еще один скрипт, который готовит окружение на Debian-based системах. Этот скрипт установит все необходимые компоненты Google Cloud SDK и выполнит инициализацию
```bash
gcloud init
```
скрипт положил в папку environment/install_gcsdk.sh
<br>Туда же добавил environment/install_pumaserver.sh для создания инстанса на SCP

<!-- Домашнее задание 05 завернул под кат -->
<br><br>

***
DevOps Homework-05 by Eugeny Kobushka (выполнено)
-------------------------------------
Замечания в Readme.md исправил и собрал файлы этого задания в каталог homework-05-vpn...<br>
Обнаружил что тег "details" не работает в Microsoft Edge, а в Google Chrome работает. Исправлять не стал, думаю не критично в этом задании. Исправлю в следующем домашней работе...
<br><details><br>
### Создан стенд для домашнего задания:

**Hostame:** bastion
**Внешний IP:** 35.196.76.8, **Внутренний IP:** 10.142.0.2

**Hostname:** someinternalhost
**Внешний IP:** none, **Внутренний IP:** 10.142.0.3

***
**Задание:** Исследовать способ подключения к internalhost в одну команду из вашего рабочего устройства,
проверить работоспособность найденного решения и внести его в README.md в вашем репозитории
***
<br><details><br>
В моей версии ssh подключиться к хосту за бастионом можно с помощью команды:
```bash
ssh -J ekobushka@35.196.76.8 ekobushka@10.142.0.3
```
на старых версиях ssh -J (Jump host) не прокатит, нужно было использовать примерно такую строку
(вариантов туннелирования возможно несколько - это не единственный)
```bash
ssh -i ~/.ssh/ekobushka -A -o ProxyCommand='ssh -W %h:%p %r@35.196.76.8' ekobushka@someinternalhost
```
</details><br>

***
**Дополнительное задание:**

Предложить вариант решения для подключения из консоли при помощи команды вида **ssh internalhost** из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу **internalhost** и внести его в README.md в вашем репозитории.
***
<br><details><br>
Чтобы упростить подключение к хостам нашего стенда для домашней работы нужно создать файл:
```bash
~/.ssh/config
```
или если он существует, то добавить в него следующие строки
```bash
Host bastion
  Hostname 35.196.76.8
  IdentityFile ~/.ssh/ekobushka
  User ekobushka

Host internalhost
  Hostname 10.142.0.3
  IdentityFile ~/.ssh/ekobushka
  ProxyJump bastion
  User ekobushka
```
</details>
</details>
