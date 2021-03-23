#!/bin/bash

#Variable Declaration
command=$1
username=$2
password=$3

#check docker status and if docker daemon is not running then start docker
sudo systemctl status docker || system start docker

#validate arguments
case $command in
  create)
    #check if the container already exists
    if [ "$(docker container ls -a -f name=jrvs-psql | wc -l)" -eq 2 ]; then
      echo "Container is already created"
      exit 1
    fi

    #validate username and password
    if [ "$username" == "" ]  || [ "$password" == "" ] ; then
      echo "No username or password entered"
      exit 1
    fi

    #create docker volume
    docker volume create pgdata

    #create psql container
    docker run --name jrvs-psql -e POSTGRES_PASSWORD=${db_password} -e POSTGRES_USER=${db_username} -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 postgres
    exit $?

    #check if the container exists
    if [ "$(docker container ls -a -f name=jrvs-psql | wc -l)" -eq 1 ]; then
      echo "Container was not created"
      exit 1
    fi

  ;;

  start)
    #start the container
    docker start jrvs-psql
    exit $?
  ;;

  stop)
    #stop the container
    docker stop jrvs-psql
    exit $?
  ;;

  *)
    echo "Invalid arguments"
    exit 1

esac

exit 0