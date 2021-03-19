#Script to create, start and stop docker-psql container
#Declaration
command=$1
username=$2
password=$3
echo"Type command $1"
echo "Username : $2"
echo "password : $3"
# check docker status, start if not running
  systemctl status docker || systemctl start docker
  docker pull postgres

#create docker psql container
  if [ "$1" == "create" ]; then
    #check if container is already created
    check_status=$(docker container ls -a -f name=jrvs-psql | wc -l)
      if [ "$check_status" == "2" ]; then
        echo "Container already created"
        exit 1
      fi

    docker volume create pgdata
    docker run --name jrvs-psql -e POSTGRES_PASSWORD=$password -d -v pgdata:/var/lib/postgresql/data -p 5432:5432 $username
    exit 0
  fi

#check username and password
    if [ "$2" == "" ] || [ "$3" == "" ]; then
      echo "Invalid Username or Password"
    fi

#check if container is already created
    check_status2=$(docker container ls -a -f name=jrvs-psql | wc -l)
      if [ "check_status2" == "1" ]; then
      echo"container has not been created"
      exit 1
      fi

#start docker container
  if [ "$1" == "start" ]; then
    docker container start jarvis_psql
    exit 0
  fi

#stop docker container
  if [ "$1" == "stop" ]; then
    docker container stop jarvis_psql
    exit 0
  fi

