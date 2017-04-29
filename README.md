Mora. Личное хранилище электронных книг.
=================================================================

Установка и запуск
------------------

* Скопировать и установить

    ```
    $ git clone git://github.com/7up4/mora.git
    $ cd mora
    $ bundle install
    ```

* Настроить и запустить Postgresql
    ```
    sudo systemctl start postgresql
    ```

* Заполнить базу

    ```
    $ rails db:create
    $ rails db:migrate
    ```

* Запустить сервер и открыть в браузере

* Запуск delayed_job: rake jobs:work или же bin/delayed_job start.
Параллельность организуется добавлением новых работников (workers): bin/delayed_job start -n <number of workers>

О проекте
---------------------------
Приложение в данный момент не готово для работы, но основа для дальнейшей разработки создана.
Предполагается, что финальная версия приложения будет представлять из себя мультипользовательскую библиотеку электронных книг
различных форматов с возможностью шаринга с другими пользователями.

* Система аутентификации: [Devise](https://github.com/plataformatec/devise)
* Файловый загрузчик: [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)
* Оформление: [Bootstrap](https://github.com/twbs/bootstrap-sass)
* Читалка: [EPUB.js](https://github.com/futurepress/epub.js)

Буду рад любой критике, т.к. главной целью является получение опыта в области веб-программирования.
Планируемые задачи перечислены в TODO.
