#!/bin/bash

PHALCON_PATH="$HOME/phalcon"
PROJECTS_FOLDER_PATH="$HOME/Desktop/BODYTECH_PROJECTS"
GITHUB_ORG="git@github.com:BodyTech-Dev"
PROJECTS=(

)

./build.sh

if [[ ! -d $PROJECTS_FOLDER_PATH ]];
then
    mkdir $PROJECTS_FOLDER_PATH
fi

if [[ ! -d $PHALCON_PATH ]];
then
    mkdir $PHALCON_PATH
fi

cp ./docker-compose.yml $PHALCON_PATH/docker-compose.yml
docker-compose -f $PHALCON_PATH/docker-compose.yml up -d

if [[ ! -d $PHALCON_PATH/projects ]];
then
    ln -s $PROJECTS_FOLDER_PATH $PHALCON_PATH/projects
fi

for project in "${PROJECTS[@]}"
do
    DOMAIN=$(echo $project | tr '[:upper:]' '[:lower:]')
    DOMAIN=$(echo $DOMAIN | sed -E -e 's/api\-|-v2//g')

    echo $DOMAIN

    if [[ -d $PROJECTS_FOLDER_PATH/$project ]];
    then
        cd $PROJECTS_FOLDER_PATH/$project
        git pull
    else
        git clone $GITHUB_ORG/$project.git -b develop $PROJECTS_FOLDER_PATH/$project
        if ! grep "/$DOMAIN.local/" /etc/hosts;
        then
            echo -e "127.0.0.1\t$DOMAIN.local" | sudo tee -a /etc/hosts
        fi
    fi

    if [[ ! -f $PHALCON_PATH/httpd/vhosts/$DOMAIN.local.conf ]];
    then
        echo -e "<VirtualHost *:80>
        ServerName $DOMAIN.local
        DocumentRoot /var/www/html/$project

        ErrorLog /var/log/apache2/$DOMAIN.local-error.log
        CustomLog /var/log/apache2/$DOMAIN.local-access.log combined

        <Directory /var/www/html/$project>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Require all granted
        </Directory>
        </VirtualHost>" | sudo tee $PHALCON_PATH/httpd/vhosts/$DOMAIN.local.conf
    fi

    docker exec phalcon3 bash -c "cd /var/www/html/$project && composer install"
done

docker restart phalcon3
