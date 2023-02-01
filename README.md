# Phalcon Devtools

 ## Requisitos
- Docker Desktop
- **Opcional:** Saber apache

## Instalación

Para la instalación hay que tener en cuenta la versión del proyecto que se va a dockerizar en el caso de requerir phalcon en su versión 3.4.x la rama debe ser ```main```, si se requiere en su versión 4.0.x la rama es ```4.0.x```

- Clonar el repositorio
```git clone https://github.com/melendez-dev/phalcon.git```
o añadiendo la rama
```git clone https://github.com/melendez-dev/phalcon.git -b 4.0.x```

- Abrir el archivo ```install.sh``` y agregar solo el nombre del proyecto como se encuentra en cada uno de sus repositorios de github, ej: si el repo es ```https://github.com/myorg/myproject.git``` solo se agregaría al install ```myproject``` y el dominio que generaría la instalación para ese proyecto sería ```myproject.local/```

```bash
#!/bin/bash
PROJECTS=(myproyect)
```

- Luego ejecutamos el archivo install, en caso de que no sea ejecutable hacemo lo siguiente
```bash
chmod +x install.sh # Solo si no es ejecutable
./install.sh # Esta es una opción
sh install.sh # Otra opción para ejecutarlo
```

- (Opcional) El proyecto hace un composer install en caso de que no se ejecute correctamente lo forzamos usando el siguiente comando
```bash
docker exec phalcon bash -c "cd /var/www/html/[nombre de la carpeta del proyecto] && composer install"
```


## Errores comunes

- Al ejecutar el comando `docker exec phalcon ls /var/www/html` no aparecen los proyectos
	- **Solución:** ejecutamos los siguientes comandos
	```bash
	rm -rf ~/phalcon/projects
	ln -s ~/Desktop/BODYTECH_PROJECTS ~/phalcon/projects
	```

## Versiones

- **1.0.0.**
	- Se agrega xdebug al contenedor para ambas versiones
	- Se generan los dominios locales automáticamente