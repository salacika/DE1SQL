## The holy grail of creating free instance of MySQL in AWS Cloud

1. Login to AWS

2. Select RDS (Relational Database Service) as Service 

3. Create a new database
![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/0.png?raw=true)

4. Configure a free database with the settings below.

Notes: 
- you might need to wait a few seconds until "Free Tier" is offered (sneaky Amazon) 
- naturally use your name as database name (not mine)  
- I know, it is a long setup, stay strong - you can do it!

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/1.png?raw=true)

5. Wait until the DB is created. You will get a green notification on the top. Until then you should see this:

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/2.png?raw=true)

6. When it is ready, you need to give access trough the firewall. In technical terms you need to opne port 3306, which is the default port for MySQL

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/3.png?raw=true)

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/4.png?raw=true)

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/5.png?raw=true)

![alt text](https://github.com/salacika/DE1SQL/blob/master/SQL1/AWS/6.png?raw=true)
