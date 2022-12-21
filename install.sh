#!/bin/bash

PHALCON_PATH="$HOME/phalcon"
PROJECTS_FOLDER_PATH="$HOME/Desktop/BODYTECH_PROJECTS"
GITHUB_ORG="git@github.com:BodyTech-Dev"
PROJECTS=(
    "API-WEBATH-v2"
    "Api-BodyTech"
    "API-WEBPERU-v2"
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
docker-compose up -d

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
        echo -e "127.0.0.1\t$DOMAIN.local" | sudo tee -a /etc/hosts
    fi

    if [[ ! -f $PHALCON_PATH/httpd/vhosts/$DOMAIN.local.conf ]];
    then
        echo -e "<VirtualHost *:80>
        ServerName $DOMAIN.local
        DocumentRoot /var/www/html/$project

        ErrorDocument 404 /var/www/html/404.html

        ErrorLog /var/log/apache2/$DOMAIN.local-error.log
        CustomLog /var/log/apache2/$DOMAIN.local-access.log combined

        <Directory /var/www/html/$project>
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Require all granted
        </Directory>
        </VirtualHost>" | sudo tee $PHALCON_PATH/httpd/vhosts/$DOMAIN.local.conf
    fi
done

docker restart phalcon