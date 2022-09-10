# docker image
docker image ls

docker image pull redis:latest

docker image rm redis:latest



# docker container 
docker container ls -a

docker container ls

docker container create --name dummyredis redis:latest

docker container create --name dummyredis2 redis:latest

docker container start dummyredis
docker container start dummyredis2

docker container stop dummyredis
docker container stop dummyredis2

docker container rm dummyredis
docker container rm dummyredis2



# docker container log
docker container create --name dummyredis redis:latest

docker container start dummyredis

docker container logs dummyredis

docker container logs -f dummyredis



# docker container exec
docker container exec -i -t dummyredis /bin/bash



# docker container port
docker image pull nginx:latest

docker container create --name dummynginx --publish 8080:80 nginx:latest



# docker container env
docker image pull mongo:latest

docker container create --name dummymongo --publish 27017:27017 --env MONGO_INITDB_ROOT_USERNAME=james --env MONGO_INITDB_ROOT_PASSWORD=james mongo:latest



# docker container stats
docker container stats



# docker resource limit
docker container create --name smallnginx --memory 100m --cpus 0.5 --publish 8081:80 nginx:latest



# docker bind mounts
docker container create --name mongodata --publish 27018:27017 --mount "type=bind,source=/Users/James/mongo-data,destination=/data/db" --env MONGO_INITDB_ROOT_USERNAME=james --env MONGO_INITDB_ROOT_PASSWORD=james mongo:latest



# docker volume
docker volume ls

docker volume create mongovolume

docker volume rm mongovolume



# docker container volume
docker volume create mongodata

docker container create --name mongodata --publish 27019:27017 --mount "type=volume,source=/mongodata,destination=/data/db" --env MONGO_INITDB_ROOT_USERNAME=james --env MONGO_INITDB_ROOT_PASSWORD=james mongo:latest



# docker volume backup
docker container stop mongovolume

docker container create --name nginxbackup --mount "type=bind,source=/Users/James/backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" nginx:latest

docker container start nginxbackup

docker container exec -i -t nginxbackup /bin/bash

tar cvf /backup/backup.tar.gz /data

docker container stop nginxbackup

docker container rm nginxbackup

docker container start mongovolume

docker image pull ubuntu:latest

docker container stop mongovolume

docker container run --rm --name ubuntubackup --mount "type=bind,source=/Users/James/backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" ubuntu:latest tar cvf /backup/backup2.tar.gz /data

docker container start mongovolume



# docker volume restore
docker volume create mongorestore

docker container run --rm --name ubunturestore --mount "type=bind,source=/Users/James/backup,destination=/backup" --mount "type=volume,source=mongorestore,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backup.tar.gz --strip 1"

docker container create --name mongorestore --publish 27020:27017 --mount "type=volume,source=mongorestore,destination=/data/db" --env MONGO_INITDB_ROOT_USERNAME=james --env MONGO_INITDB_ROOT_PASSWORD=james mongo:latest

docker container start mongorestore



# docker network
docker network ls

docker network create --driver bridge dummynetwork

docker network rm dummynetwork



# docker container network
ocker network create --driver bridge mongonetwork

docker container create --name mongodb --network mongonetwork --env MONGO_INITDB_ROOT_USERNAME=james --env MONGO_INITDB_ROOT_PASSWORD=james mongo:latest

docker image pull mongo-express:latest

docker container create --name mongodbexpress --network mongonetwork --publish 8081:8081 --env ME_CONFIG_MONGODB_URL="mongodb://james:james@mongodb:27017/" mongo-express:latest

docker container start mongodb

docker container start mongodbexpress

docker network disconnect mongonetwork mongodb

docker network connect mongonetwork mongodb



# docker inspect
docker image ls
docker image inspect mongo-express:latest

docker container ls
docker container inspect mongodbexpress

docker network ls 
docker network inspect mongonetwork

docker volume ls 
docker volume inspect mongorestore


# docker prune
docker image prune

docker container prune

docker volume prune

docker network prune

docker system prune