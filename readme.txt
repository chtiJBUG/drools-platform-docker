


To create image:


#to create image
sudo docker build -t="imagename" .

#to run container as a service
sudo docker run -d --name container-name -h="hostname" -p 10080:8080 -p 10022:22 -p 10432:5432 -p 10616:61616 imagename


#to verify if container is running:
sudo docker  ps 

#to get all the information about container:
sudo docker inspect <containar-name>

#to copy files to the host-machine 
sudo docker cp container-name:/source  destination



