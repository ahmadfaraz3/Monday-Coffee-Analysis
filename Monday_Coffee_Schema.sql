create database monday_coffee
use monday_coffee;

CREATE TABLE city
(
	city_id	INT PRIMARY KEY,
	city_name VARCHAR(50),	
	population	bigint,
	estimated_rent	FLOAT,
	city_rank INT
);
CREATE TABLE customers
(
	customer_id INT PRIMARY KEY,	
	customer_name VARCHAR(50),	
	city_id INT,
	CONSTRAINT fk_city FOREIGN KEY (city_id) REFERENCES city(city_id)
);

create table products (
product_id int primary key,
product_name varchar(50),
price float );

create table sales (
sale_id int primary key,
sale_date date,
product_id int, 
customer_id int,
total float,
rating int,
constraint fk_products foreign key (product_id) references products (product_id),
constraint fk_customers foreign key (customer_id) references customers (customer_id) 
)