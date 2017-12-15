## DevOps Homework-05 by Eugeny Kobushka

### Создан стенд для домашнего задания:

**Hostame:** bastion  
**Внешний IP:** 35.196.76.8, **Внутренний IP:** 10.142.0.2

**Hostname:** someinternalhost  
**Внешний IP:** none, **Внутренний IP:** 10.142.0.3
 
***
**Задание:** Исследовать способ подключения к internalhost в одну команду из вашего рабочего устройства,
проверить работоспособность найденного решения и внести его в README.md в вашем репозитории
***  

В моей версии ssh подключиться к хосту за бастионом можно с помощью команды:  
```
ssh -J ekobushka@35.196.76.8 ekobushka@10.142.0.3
```
на старых версиях ssh -J (Jamp host) не прокатит, нужно было использовать примерно такую строку  
(вариантов туннелирования возможно несколько - это не единственный)
```
ssh -i ~/.ssh/ekobushka -A -o ProxyCommand='ssh -W %h:%p %r@35.196.76.8' ekobushka@someinternalhost 
```

***
**Дополнительное задание:** 
Предложить вариант решения для подключения из консоли при помощи команды вида **ssh internalhost** из локальной консоли рабочего устройства, чтобы подключение выполнялось по алиасу **internalhost** и внести его в README.md в вашем репозитории.
***  

Чтобы упростить подключение к хостам нашего стенда для домашней работы нужно создать файл:
```
~/.ssh/config
```
или если он существует, то добавить в него следующие строки
```
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

