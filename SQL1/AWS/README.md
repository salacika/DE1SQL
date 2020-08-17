# 10 steps of the holy grail - Creating a free instance of MySQL in AWS.

## 1. Login to AWS

## 2. Select RDS (Relational Database Service) as Service 

## 3. Create a new database
![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/0.png?raw=true)

## 4. Configure a free database with the settings below.

Notes: 
- you might need to wait a few seconds until "Free Tier" is offered (sneaky Amazon) 
- naturally use your name as database name (not mine)  
- make sure, you remember the password you set
- I know, it is a long setup, stay strong - you can do it!

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/1.png?raw=true)

## 5. Wait until the DB is created. You will get a green notification on the top. Until then you should see this:

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/2.png?raw=true)

## 6. When it is ready, you need to give access trough the firewall. In technical terms you need to opne port 3306, which is the default port for MySQL. First you should open the settings of the newly created DB by clicking the DB name and then click on the VPC Security group:

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/3.png?raw=true)

## 7. Scroll down and open Inbound rules

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/4.png?raw=true)

## 8. Click Edit Inbound rules

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/5.png?raw=true)


## 9. Set the following rules and click Save rules

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/6.png?raw=true)

## 10. Now you are set! It is time to check from MySQL workbench. For this you need the DB endpoint . Open the DB configration again and copy the DB endpoint

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/7.png?raw=true)


