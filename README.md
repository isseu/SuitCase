# SuitCase

Sistema web de seguimiento de los casos judiciales que se conecta y actualiza constantemente con las distintas páginas web de [poderjudicial.cl](http://poderjudicial.cl), organizando la información y notificando a los abogados cuando es necesario.

## Deployment
### Requerimientos
- Ruby 4.2
- PostgreSQL
- Linux / MacOSX

### Configuración
Se puede configurar la base de datos a travez del archivo ubicado en `config/database.yml`. Aunque con configurar las variables de entorno siguientes basta:
- POSTGRE_USER
- POSTGRE_PASS

### Instalación
Es necesario una variable de entorno RAILS_ENV=production si se quiere ejecutar en ese modo especifico.

Para instalar las gemas necesarias a travez del Gemfile y crear la base de datos:
```bash
$ bundle install
$ rake db:create db:migrate db:seed
```
Para iniciar el servidor:
```bash
$ rails server
```
Para iniciar el crawler y que empieze a sacar casos desde la pagina de poderjudicial
```bash
$ rake crawler:start
```
Para ingresar al servidor hay que ir a [localhost:3000](http://localhost:3000) y ingresar con la contraseñas correspondientes o revisar el archivo `db/seeds/00_users.rb`.
