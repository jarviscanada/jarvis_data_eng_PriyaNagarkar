# Introduction
This project was an implementation of a DAO in the terms of Customer and Orders demonstrating how they are connected to DTOs and how the abstraction layer is connected. CRUD operations were used on the project and DAOs.

## ER Diagram
![image](https://user-images.githubusercontent.com/80492218/115720954-8b4ebd00-a34b-11eb-8d5f-786dc14363cf.png)

## Design Patterns
DAO's (Data Access Objects) are one of the most common patterns when dealing with databases. They provide an abstraction layer between the raw JDBC code and the business logic. They are useful because they allow us to have a single instance of the database and to compute the joins using the foreign keys, like we did for the Order object.

In contrast, the repository pattern only focuses on single table accesses per class. So joins can be performed in the code after all the data has been selected from the different tables. This is useful when you need to scale your database horizontally, resulting in a more distributed system.

## Test
The database was set up in a dockerized PostgreSQL instance. Inside the JDBCExecutor which is the class acting as the client, manual tests were done inside the main method. Exceptions were logged and handled using the slf4j logger. Using CustomerDAO and OrdersDAO, DTO were returned and their outputs were displayed to compare results.

