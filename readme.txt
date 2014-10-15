


To create image:


#to create image
sudo docker build -t="imagename" .

#to run container as a service
sudo docker run -d --name container-name -h="hostname" -p 8080 -p 22 -p 5432 image1 (or -p 49155:8080 to avoid random port)


#to verify if container is running:
sudo docker  ps 

#to get all the information about container:
sudo docker inspect <containar-name>

#to copy files to the host-machine 
sudo docker cp container-name:/source  destination



