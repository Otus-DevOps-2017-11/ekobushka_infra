DevOps Homework-11 by Eugeny Kobushka
-------------------------------------

***
<br>

**Задание:** Подход: один плейбук, один сценарий (play)

<br>

Создаем плейбук reddit_app.yml. Выполнил все как описано в домашнем задании. Также выполнил все сопутствующие мелкие задания.

На мой взгляд такой подход совсем не практичный.
1. Не возможно переиспользовать плейбуки без существенной переработки.
2. Пройдет совсем немного времени и забудется использование тегов и лимитов.

Единственный вариант, который я вижу при данном подходе - это вариант подготовки заранее shell-скриптов с уже прописанными тегами и лимитами.

Создание инфраструктуры:
1. на основе сценария терраформа для стейдж-окружения создал сценарий без установки пакетов и приложений.
```note
закоментировать все провижинеры в модулях
+ нам не нужно для тестирования сохранение стейт-файла
```
2. Выполнить следующие команды:
```bash
terraform init
terraform apply -auto-approv=false
# в выводе будет
#  Outputs:
#  app_external_ip = [
#      35.195.158.193,
#      104.199.21.27
#  ]
#  db_external_ip = 35.195.195.117
#  db_internal_ip = 10.132.0.4
# Это заносим в инвентарь и в переменную db_host

# тестовый прогон плейбука с лимитами и тегами
sudo ansible-playbook reddit_app.yml --check --limit db --tags db-tag
sudo ansible-playbook reddit_app.yml --check --limit app --tags app-tag
sudo ansible-playbook reddit_app.yml --check --limit app --tags deploy-tag
# выполняем плейбук, т.к. ошибок не обнаружено
sudo ansible-playbook reddit_app.yml --limit db --tags db-tag
sudo ansible-playbook reddit_app.yml --limit app --tags app-tag
sudo ansible-playbook reddit_app.yml --limit app --tags deploy-tag
```
Проверим правильность выполнения нашего плейбука
Http://app_external_ip:9292

Убеждаемся что все работает и удаляем созданную инфраструктуру
```bash
terraform destroy
```
<br>

**Задание:** Подход: один плейбук, но много сценариев

<br>

Создаем плейбук reddit_app2.yml. Выполнил все как описано в домашнем задании. Также выполнил все сопутствующие мелкие задания.

В этом подходе уже больше порядка, но все же есть существенные ограничения в целом повторяющие предыдущий подход.

Создание инфраструктуры:
1. на основе сценария терраформа для стейдж-окружения создал сценарий без установки пакетов и приложений.
```note
закоментировать все провижинеры в модулях
+ нам не нужно для тестирования сохранение стейт-файла
```
2. Выполнить следующие команды:
```bash
terraform init
terraform apply -auto-approv=false
# в выводе будет
#  Outputs:
#  app_external_ip = [
#      35.195.158.193,
#      104.199.21.27
#  ]
#  db_external_ip = 35.195.195.117
#  db_internal_ip = 10.132.0.4
# Это заносим в инвентарь и в переменную db_host

# тестовый прогон плейбука с лимитами и тегами
sudo ansible-playbook reddit_app2.yml --tags db-tag --check
sudo ansible-playbook reddit_app2.yml --tags app-tag --check
sudo ansible-playbook reddit_app2.yml --tags deploy-tag --check
# выполняем плейбук, т.к. ошибок не обнаружено
sudo ansible-playbook reddit_app2.yml --tags db-tag
sudo ansible-playbook reddit_app2.yml --tags app-tag
sudo ansible-playbook reddit_app2.yml --tags deploy-tag
```
Проверим правильность выполнения нашего плейбука
Http://app_external_ip:9292

Убеждаемся что все работает и удаляем созданную инфраструктуру
```bash
terraform destroy
```

<br>

**Задание:** Подход: много плейбуков

<br>

Переименовываем плейбуки предыдущих подходов:
reddit_app.yml -> reddit_app_one_play.yml
reddit_app2.yml-> reddit_app_multiple_plays.yml

Создаем следующие плейбуки:
* db.yml
* app.yml
* deploy.yml
* site.yml

Здесь уже можно как-то упорядочить структуру плейбуков и появляется возможность переиспользовать готовые плейбуки после некоторой доработки.

Создание инфраструктуры:
1. на основе сценария терраформа для стейдж-окружения создал сценарий без установки пакетов и приложений.
```note
закоментировать все провижинеры в модулях
+ нам не нужно для тестирования сохранение стейт-файла
```
2. Выполнить следующие команды:
```bash
terraform init
terraform apply -auto-approv=false
# в выводе будет
#  Outputs:
#  app_external_ip = [
#      35.195.158.193,
#      104.199.21.27
#  ]
#  db_external_ip = 35.195.195.117
#  db_internal_ip = 10.132.0.4
# Это заносим в инвентарь и в переменную db_host

# тестовый прогон плейбука с лимитами и тегами
sudo ansible-playbook site.yml --check
# выполняем плейбук, т.к. ошибок не обнаружено
sudo ansible-playbook site.yml
```
Проверим правильность выполнения нашего плейбука
Http://app_external_ip:9292

Убеждаемся что все работает и удаляем созданную инфраструктуру
```bash
terraform destroy
```

<br>

**Задание со (*):** Исследуйте возможности использования dynamic inventory для GCP

<br>

Для работы с инстансами Google Cloud Platform нашелся скрипт, написанный на питоне
```bash
wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/gce.py
wget https://raw.githubusercontent.com/ansible/ansible/devel/contrib/inventory/gce.ini
```

Настройка для работы совсем не интуитивная. Пришлось поломать голову что же хотят в ini-файле.

Идем в консоль GCP https://console.developers.google.com/
Создаем service account key. Скачиваем json с ключом и запоминаем идентификатор сервисного аккаунта.

заполняем ini-файл в соответствующих полях.

проверяем что все работает:
```bash
.gce.py --list
```
в выводе должен быть json данными наших инстансов.

Нашел как использовать для наших целей не прибегая к заполению inventory.
Что нужно изменить в наших плейбуках:
```yml
# db.yml
# вместо hosts: db
hosts: reddit-db

# app.yml
# вместо hosts: app
# инстансы создаются через count, поэтому получилось заставить работать вот такую запись
hosts: reddit-app-*

# deploy.yml аналогично
```
Как запустить на исполнение наш плейбук:
```bash
# тестовый прогон
sudo ansible-playbook -i gce.py site.yml --check
# исполнение
sudo ansible-playbook -i gce.py site.yml
```
Убеждаемся что все работает открыв страничку сайта с нашим приложением.

Не забываем удалять наши инстансы после проверки...

Собрал выполненное задание в папку ansible/dynamic-inventory
Может конечно не совсем правильно, но так вроде порядка больше в файлах...

Внес заполненный ini-файл и json с сервисным ключом в .gitignore
Добавил gce.ini.example - какие поля нужно заполнить чтобы все заработало...

А вообще нашлись еще инструменты для парсинга инветори. Например:
Парсинг стейт-файла терраформа
1. Ansible dynamic inventory script for parsing Terraform state files https://github.com/mantl/terraform.py
2. Terraform State → Ansible Dynamic Inventory https://github.com/adammck/terraform-inventory

ну и думаю на этом список себя не исчерпывает...

<br>

**Самостоятельное задание:**
Опишите с помощью модулей Ansible в плейбуках packer_app.yml и packer_db.yml действия, аналогичные bash скриптам, которые сейчас используются в нашей конфигурации Packer. (использовать модули command и shell нежелательно)

<br>

Задание оказалось далеко не простым, как показалось с первого взгляда. Очень долго не мог помирить пакер и ансибл.
Пришлось отлаживать с verbose чтобы понять что не так. Оказалось, что плейбук если просто прописан в провижинере - исполняется на локальной машине и даже не думает подключаться к желаемому хосту... пришлось курить маны, форумы и т.д.
В общем все получилось...

Проверил - все работает. Проверял создание образов как на основе 16.04, так и на основе 17.10...
После деплоя приложение работает, без проблем...

Привожу список команд для создания необходимой инфраструктуры для деплоя приложения:
```bash
# Создание образов для дальнейшей инфраструктуры
packer build -var-file="variables.json" app-ansible.json
packer build -var-file="variables.json" db-ansible.json

# Создание интсансов terraform`om
terraform apply -auto-approve=false

# Деплой с dynamic inventory
sudo ansible-playbook -i ./gce.py site.yml

```
<br>
После проверки - удалим созданную инфраструктуру...

<br><br>
<!-- Домашнее задание 09 завернул под кат -->

***
DevOps Homework-10 by Eugeny Kobushka (выполнено)
-------------------------------------
<details><br>

**Выполнение задания:**

**Установка клиента ansible**

1. создал файл requirements.txt с содержимым:
```bash
ansible>=2.4
```

2. установил ansible
```bash
pip install -r requirements.txt
```

3. Проверил версию ansible после установки:
```bash
$ ansible --version
ansible 2.4.2.0
```
<br>

**Создание конфигурационного файла ansible.cfg**

Создал файл с требуемым содержимым

<br>

**Файл inventory и работа с группами**

1. Создал структуру терраформом и получил ip-адреса инстансов
2. Внес их в файл **inventory** и выделил требуемые группы
3. проверил с помощью модуля ping корретность исполнения по группам
```bash
$ ansible app -m ping
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ ansible db -m ping
bserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ ansible all -m ping
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
все отработало корректно...

<br>

**Использование YAML inventory**

**Задание:** создать файл inventory.yml и перенести в него хосты из ini inventory

<br>

1. Создадим yaml inventory следующего содержимого:
```yaml
all:
  children:
    app:
      hosts:
        appserver-1:
          ansible_host: ip-address

```

привел основную часть получившегося файла

<br>

2. проверим работу клиента с получившимся yaml-файлом. Для этого изменим в ansible.cfg строку:
```bash
#inventory = ./inventory
inventory = ./inventory.yaml
```

<br>

3. проверим корреткность работы получившегося файла inventory
```bash
$ sudo ansible app -m ping
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ sudo ansible db -m ping
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ sudo ansible all -m ping
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

```
как можем увидеть вывод корректный, значит создали корректный yaml-файл...

<br>

**Задание со (*):** Создать json формат инвентори файл и проверить корретность его работы

<br>

1. Создадим файл inventory.json с вот таким содержимым (это значимый кусок содержимого файла)
```json
{
    "all": {
       "children": {
         "app": {
            "hosts": {
              "appserver-1": {
                "ansible_host": "ip-address"
                },
... (тут дальше еще код)
}
```

2. Изменим в файле ansible.cfg строки:
```bash
#inventory = ./inventory
#inventory = ./inventory.yaml
inventory = ./inventory.json
```
<br>

3. Проверим корректность работы клиента с JSON inventory
```bash
$ sudo ansible app -m ping
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ sudo ansible db -m ping
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

$ sudo ansible all -m ping
appserver-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
dbserver | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
appserver-2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

```
Как можем убедиться вывод корреткный, значит файл JSON inventory создан правильно...

<br>

**Выполнение комманд:**
<br>

Каких-то заданий на исполнение комманд указано не было, поэтому я проделал все команды, которые были описаны в файле домашнего задания. Разобрался и увидел разницу в использовании модуля shell и остальных модулей для исполнения удаленных комманд.

<br></details><br>
<!-- Домашнее задание 09 завернул под кат -->

***
DevOps Homework-09 by Eugeny Kobushka (выполнено)
-------------------------------------
<details>

(задание выполнял на одном дыхании, поэтому не стал разбивать на мелкие коммиты - закоммитил сразу все выполненное)
<br>

***
**Самостоятельное задание:**
1. Создаем конфигурационные файлы packer для создания базовых образов с mongoDB и ruby;
2. Разбиваем main.tf на отдельные модули;
3. Параметризируем созданные модули;
4. Создаем Stage&Prod;
5. форматируем конфигурационные файлы

<details>

<br> **Выполнение домашней самостоятельной работы.**
<br><br>В прошлом задании остались некоторые лишние файлы и каталоги, поэтому наведем немного порядка перед выполнением текущего задания. Создана папка backup.
Туда перенесен каталог первого варианта и переименован в first_solution. Создана копия файлов перед изменением - second_solution.<br>
Далее, согласно полученному заданию, main.tf был разбит на части и на основе этих частей были созданы модули. Затем была проведена параметризация созданных модулей.<br>
Создал на основе полученных модулей Stage&Prod и удалил ненужные файлы из корня папки terraform.<br>
Полученные файлы были отформатированы для повышения читаемости.
<br><br>

**P.S.** Решил не удалять load balancer, а попытаться создать модуль на его основе. После нескольких переделок с нуля это удалось. В целом задание очень интересное и заставило подумать и почитать мануалы... <br>
После проверки load balanсer я модуль отключил. Чтобы включить модуль необходимо расскоментировать строки касающиеся модуля lb в файле main.tf и outputs.tf

<br></details>

**Задание со (*):**
<br>
1. Настройте хранение стейт файла на удаленном бекенде, используя Google Cloud Storage в качестве бекенда.
2. Перенесите конфигурационные файлы terraform в другую директорию. Проверьте, что state файл (terraform.tfstate) отсутствует. Запустите terraform в обоих директориях и проконтролируйте, что он "видит" состояние независимо от директории, в которой запускается.
3. Попробуйте запустить применение конфигурации одновременно, чтобы проверить работу блокировок;

<details>

<br> **Выполнение задания:** <br>

Хранение стейт файла настроил без проблем. К сожалению не получилось параметризировать и вынести переменные в другой файл. Пробовал различные варианты, но ничего не вышло из этого. Полез читать мануалы и faq... и оказалось, что это не получиться сделать. <br>
Поэтому сделал просто в лоб... <br>
Попробовал перенести конфиги и проверить работу со стейт файлом на удадленном бекенде - все удалось и заработало как надо. Блокировка работает, если пробовать запустить одновременно применение конфигураций.
<br></details><br>

**Задание со (*):**
<br>
1. Добавьте необходимые provisioner в модули для деплоя и работы приложения. Файлы, используемые в provisioner должны находится в директории модуля.
2. Добавьте описание в README.md.
P.S. Приложение получает адрес БД из переменной окружения DATABASE_URL

<details>

<br> **Выполнение задания:** <br>

Так как у нас обязательно условие -  переменная окружения DATABASE_URL, то из множества возможных решений (использование различных уровней использования и инициализации переменных окружения, например ~/.bashrc; /etc/profile; /etc/environment и т.д.) я выбрал как я думаю самый разумный. Я инициировал переменную окружения в файле сервиса для запуска нашего приложения. В файле **puma.service**, который формируется с помощью шаблона я добавил строку
```bash
Environment=DATABASE_URL=${db_address}:${db_port}
```
В момент парсинга шаблона в эту строку подставляются нужные значения.
<br></details><br>

**Работа с реестром модулей:**

Давайте попробуем воспользоваться модулем storage-bucket для создания бакета в сервисе Storage. Создайте в папке terraform файл storage-bucket.tf с таким содержанием:
```json
provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region = "${var.region}"
  }
module "storage-bucket" {
  source = "SweetOps/storage-bucket/google"
  version = "0.1.1"
  name = ["storage-bucket-test", "storage-bucket-test2"]
  }
output storage-bucket_url {
  value = "${module.storage-bucket.url}"
  }
```
1. Создайте или скопируйте готовые variables.tf и terraform.tfvars для проекта и региона и примените конфигурацию тераформа;
2. Проверьте с помощью gsutil или веб консоли, что бакеты создались и доступны;
3. Ознакомьтесь с кодом реализации данного модуля на GitHub.

<details>

<br> **Выполнение задания:** <br>

Файл storage-bucket.tf с требуемым содержимым создал. Изменил только строку name, так как требования уникальности имен никто не отменял. Применил конфигурацию и проверил в веб-консоли - все создалось без ошибок.<br>
С кодом этого модуля на GitHub ознакомился, он находится по адресу - https://github.com/SweetOps/terraform-google-storage-bucket

</details>

<br></details>
<!-- Домашнее задание 06 завернул под кат -->


***
DevOps Homework-08 by Eugeny Kobushka (выполнено)
-------------------------------------

<details><br>

***
**Самостоятельное задание:**
1. Определите input переменную для приватного ключа, использующегося в определении подключения для провижинеров (connection);
2. Определите input переменную для задания зоны в ресурсе "google_compute_instance" "app". У нее должно быть значение по умолчанию;
3. Отформатируйте все конфигурационные файлы используя команду
```bash
terraform fmt
```
4. Так как в репозиторий не попадет ваш terraform.tfvars, то нужно сделать рядом файл terraform.tfvars.example, в котором будут указаны переменные для образца.

<details><br>

Указанное выше самостоятельное задание - выполнено. В переменные вынес все что посчитал нужным вынести. Заодно разбирался в процессе с созданием переменных.<br><br>
С созданием переменных разобрался. Они могут быть с несколькими вариантами значений: значение по дефолту, пользовательское значение и не иметь значения. Если мы значение не указали или терраформ по каким-то причинам не нашел значение переменной, то он попросит его ввести в момент создания инстанса. Значения переменных, как мы увидели выше, можно:
* записать в файле variables.tf в виде дефолтных значений;
* записать в файле terraform.tfvars в виде пользовательских значений;
* записать в любой другой файл с расширением *.tf но тогда мы должны будем указать этот файл в опции запуска terraform -var-file=FILE;
* присвоить значение переменной в командной строке с помощью опции --var name=value;
* ввести в командной строке в процессе выполнения сценария терраформом;
* ну и наконец присвоить значения переменных через сценарий shell-скрипта в виде записей
  ```bash
  export TF_VAR_name=value
  ```
<br></details><br>

***
**Задание со звездочкой (1):**
* Опишите в коде терраформа добавление ssh ключа пользователя appuser1 в метаданные проекта. Выполните terraform apply и проверьте результат (публичный ключ можно брать пользователя appuser);
* Опишите в коде терраформа добавление ssh ключей нескольких пользователей в метаданные проекта (можно просто один и тот же публичный ключ, но с разными именами пользователей, например appuser1, appuser2 и т.д.). Выполните terraform apply и проверьте результат;
* Добавьте в веб интерфейсе ssh ключ пользователю appuser_web в метаданные проекта. Выполните terraform apply и проверьте результат;
* Какие проблемы вы обнаружили? Добавьте описание в README.md
* Не забудьте закоммитить добавленный код в репозиторий и добавить описание в README.md;

<details><br>

Добавление SSH-ключей в метаданные нашего проекта с помощью терраформа описывается следующим примитивом:

```bash
resource "google_compute_project_metadata" "infra" {
  metadata {
    ssh-keys = "$appuser1:${file("~/.ssh/appuser.pub")}appuser2:${file("~/.ssh/appuser.pub")}"
  }
}
```
При добавлении в веб-интерфейсе любых ключей они будут затерты и перезаписаны терраформом. Это является как плюсом, так и проблемой, так как накладывает ответственность на разработчика по сохранению ключей. Иначе они будут утеряны и придется заново проделать работу по добавлению их в проект. Когда проект состоит из нескольких человек - это не проблема, но если людей много, то это доставит много неприятных минут.

</details><br>

***
**Задание со звездочкой (2):**
* Опишите в коде terraform создание HTTP балансировщика, направляющего трафик на наше развернутое приложение на инстансе reddit-app. Проверьте доступность приложения по адресу балансировщика. Добавьте в output переменные адрес балансировщика;
* Добавьте в код еще один инстанс приложения, например reddit-app2, добавьте его в балансировщик и проверьте, что при остановке на одном из инстансов приложения (например systemctl stop puma), приложение продолжает быть доступным по адресу балансировщика; Добавьте в output переменные адрес второго инстанса;
* Не забудьте закоммитить добавленный код в репозиторий и добавить описание в README.md;

<br><details><br><br>

Чтобы описать в нашем проекте создание HTTP балансировщика, воспользуемся следующими ресурсами:

1. Создаем группу для наших инстансов, она описывается в примитиве **google_compute_instance_group** (в нашем случае группа состоит из дву инстансов).

2. Создаем правила по которым будут проверяться работоспособность наших инстансов, они описываются в примитиве **google_compute_http_health_check** (в нашем случае достаточно описать проверку наших инстансов по порту 9292).

3. Описываем бекенд нашего балансировщика в примитиве **google_compute_backend_service** - нам необходимо указать группу инстансов и по каким правилам мы проверяем работоспособность нашей группы.

4. Описываем правила по которым мы будет отправлять запросы на инстансы в нашей группе в примитиве **google_compute_url_map**

5. Создаем наш балансировщик в примитиве **google_compute_global_forwarding_rule** и указываем ему цели для работы в секции **google_compute_target_http_proxy**

<br>Описал создание балансировщика как я сам это понимаю. <br><br>
После создания второго инстанса и балансировщика для нашей группы инстансов, я проверил работу балансировщика.
<br>Все было корректно, кроме работы самого приложения. Оно не расчитано на работу через балансировщик и возникают проблемы со входом пользователям, так как балансировщик перекидывает нас с одного инстанса на другой...
<br><br>
Для удобства добавил в outputs.ft получение и вывод внешнего ip-адреса нашего балансера после создания.
<br><br>

</details><br>
***
Домашнее задание было уже выполнено, когда я увидел описание создания нод с помощью шаблона и **count**. Решил переделать свое решение под использование **count**, сохранив при этом уже сделанный вариант в папке **first_variant**. Он полностью рабочий, но не такой универсальный как измененный на использование **count**. <br><br>
В этом варианте изменения затронули следущие файлы:
* variables.tf - добавлена переменная для count
* outputs.tf - изменено получение внешних ip-адресов для массива инстансов
* main.tf - здесь основные изменения в этом варианте (создание массива нод, и исправлено создание балансера для этого массива)


Проверил работу установив значение count - 4. После применения созданы четыре инстанса и балансер для них. Все работает корректно - балансер переключает трафик между всеми четырьмя нодами.<br>

</details>

<!-- Домашнее задание 06 завернул под кат -->
<br>

***
DevOps Homework-07 by Eugeny Kobushka (выполнено)
-------------------------------------
Замечания по пулл-реквесту исправил все...
<details><br>
***
**Задание:**
  * Создайте новую ветку в вашем репозитории для выполнения данного ДЗ.
  * Назовите ветку packer-base.
  * Перенесите наработки с предыдущего ДЗ в директорию config-scripts.
  * Создайте в infra репозитории директорию packer.
  * Внутри директории packer создайте файл ubuntu16.json
  * В случае успешного создания образа VM при помощи Packer закомитьте, результаты вашей работы в созданную ранее ветку.

***
**Самостоятельное задание:**<br>
1. Необходимо параметризировать созданный шаблон, используя пользовательские переменные (см. лекцию). Какие опции шаблона должны быть параметризированы:
  * ID проекта (обязательно)
  * source_image_family (обязательно)
  * machine_type
<br><br>"Обязательно" означает, что пользовательская переменная должна быть обязательна для определения и не иметь значения по умолчанию. Если вы будете создавать файл с переменными variables.json, то хорошей практикой считается внести его в .gitignore, а в репозиторий добавить файл variables.json.example с примером заполнения, используя вымышленные значения.

<br><details><br>

<span style="color:red">Здесь и далее мы находимся в каталоге packer и все команды исполняем в нем.</span>


Сборка образа с помощью packer используя наш шаблон. Рассмотрим несколько вариантов:
<br>**Вариант 1** - с помощью передачи переменных в строку packer для создания образа
```bash
packer build \
-var 'gcp_project_id=infra-188905' \
-var 'gcp_source_image_family=ubuntu-1604-lts' \
-var 'gcp_machine_type=f1-micro' ubuntu16.json
```
**Вариант 2** - с помощью передачи переменных в строку packer файлом variables.json (в качестве примера берем variables.json.example)
```bash
packer build -var-file="variables.json" ubuntu16.json
```
</details><br>

2. Исследовать другие опции builder для GCP
(ссылка). Какие опции точно хотелось бы видеть:
* Описание образа
* Размер и тип диска
* Название сети
* Теги

<br><details><br>
С опциями, указанными выше, я разобрался и добавил в шаблон parcker для создания образа. Нам интересна опция описания образа. Остальные опции фактически нужны только в процессе создания виртуальной машины. Мои выводы состоят в том, что скорее всего эти опции для Google Cloud Platform не нужны в образе.
</details><br>

***
**Задание со * первое:**
<br>Чтобы попрактиковать подход к управлению инфраструктурой Immutable infrastructure, о котором говорили на вебинаре, попробуйте “запечь” (bake) в образ VM все зависимости приложения и сам код приложения.
<br>Результат должен быть таким: запускаем инстанс из созданного образа и на нем сразу же имеем запущенное приложение.
<br>Созданный шаблон должен называться **immutable.json** и содержаться в директории packer, image_family у
получившегося образа должен быть reddit-full.
<br>Дополнительные файлы можно положить в директорию **packer/files**.

**Задание со * второе:**
<br>Для ускорения работы предлагается запускать виртуальную машину с помощью командной строки и утилиты gcloud.
<br>Создайте shell-скрипт с названием **create-reddit-vm.sh** в директории **config-scripts**. Запишите в него команду которая запустит виртуальную машину из образа подготовленного вами в рамках этого ДЗ, из семейства reddit-full, если вы выполнили первое задание со звездочкой, или reddit-base, если не выполняли.
<details>

<br>**Выполнение:**
<br> **Создание образа с помощью packer:**

<br>Выполнил данное задание в двух вариантах.
<br><br> * **Вариант 1:** создание полного образа с "запеченным" приложением через базовый образ.<br>
1. Создаем файл с переменными на основе шаблона variables.json
```json
{
    "gcp_project_id": "test-132681",
    "gcp_source_image_family": "ubuntu-1204-lts",
    "gcp_source_image_family_deploy_based": "reddit-base",
    "gcp_machine_type": "f1-micro"
}
```
* gcp_project_id - ID нашего проекта
* gcp_source_image_family - базовый дистрибутив Линукс на основе которого создаем наш образ
* gcp_source_image_family_deploy_based - имя нашего базового образа
* gcp_machine_type - тип создаваемого инстанса на GCP
<br><br>
2. Создаем базовый образ
```bash
packer build -var-file="variables.json" ubuntu16.json
```
После выполнения будет создан пользовательский образ с установленными ruby, bundle, mongodb.

3. Создаем полный образ с приложением на основе нашего базового образа
```bash
packer build -var-file="variables.json" immutable.json
```

<br><br> * **Вариант 2:** создание полного образа без создания базового образа.<br>

* Создаем variables.json как описано выше
* Создаем полный образ
```bash
packer build -var-file="variables.json" immutable_full.json
```
<br>
После выполнения любого из описанных выше вариантов в образ будут интегрированы все необходимые пакеты и будет "запечено" наше приложение со всеми зависимостями.<br><br>


**Использование скрипта для создание инстанса:**
<br> Не стал мудрить и сделал скрипт в лоб. Можно переделать на вариант с передачей по крайней мере ID проекта в опциях, но так как предполагается, что скриптом будем пользоваться только мы и он будет создан раз и надолго, то вариант предложенный вполне подходит.
<br>Правим под себя переменные
```bash
PROJECT_NAME="test-132681"
IMAGE_FAMILY="reddit-full"
```
где,
<br>**PROJECT_NAME** - это ID нашего проекта
<br>**IMAGE_FAMILY** - это наш образ с "запеченным" приложением на основе которого будет создан инстанс

<br>После выполнения скрипта будет выдана информация с адресами нашего инстанса. Заходим в браузере по адресу:<br>
http://EXTERNAL_IP:9292/

и видим работающее приложение...
</details>
</details>

<!-- Домашнее задание 06 завернул под кат -->
<br>

***

DevOps Homework-06 by Eugeny Kobushka (выполнено)
-------------------------------------
Замечания по пулл-реквесту исправил все...
<details><br>
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
<details><br>
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
</details>
</details>

<!-- Домашнее задание 05 завернул под кат -->
<br>

***
DevOps Homework-05 by Eugeny Kobushka (выполнено)
-------------------------------------
Замечания в Readme.md исправил и собрал файлы этого задания в каталог homework-05-vpn...<br>
Обнаружил что тег "details" не работает в Microsoft Edge, а в Google Chrome работает.
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
