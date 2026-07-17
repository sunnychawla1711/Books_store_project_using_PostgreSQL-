

-- Create Database
CREATE DATABASE Bookstore;

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT );



DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
  Order_ID SERIAL PRIMARY KEY,
  Customer_ID INT REFERENCES Customers(Customer_ID),
  Book_ID INT REFERENCES Books(Book_ID),
  Order_Date DATE,
  Quantity INT,
  Total_Amount NUMERIC(10, 2)
);


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock) 
FROM 'C:\Users\Lenovo\Desktop\SQL\Project 2\SQL PRACTICE\Excel Files\Books.csv' 
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Users\Lenovo\Desktop\SQL\Project 2\SQL PRACTICE\Excel Files\Customers.csv' 
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount) 
FROM 'C:\Users\Lenovo\Desktop\SQL\Project 2\SQL PRACTICE\Excel Files\Orders.csv' 
CSV HEADER;


-- 1) Retrieve all books in the "Fiction" genre:



SELECT * FROM Books WHERE genre = 'Fiction' ;





-- 2) Find books published after the year 1950:



SELECT * FROM Books WHERE  Published_Year >= 1950;




-- 3) List all customers from the Canada:


SELECT * FROM customers WHERE  country = 'Canada';


-- 4) Show orders placed in November 2023:


SELECT * FROM Orders 
WHERE  Order_Date BETWEEN '2023-11-01' AND '2023-11-30';



-- 5) Retrieve the total stock of books available:

SELECT SUM(stock) FROM Books

-- 6) Find the details of the most expensive book:

select * from Books order by price desc limit 1;


-- 7) Show all customers who ordered more than 1 quantity of a book:

select Customers.name, orders.quantity from Customers join Orders 
on Customers.customer_id = Orders.customer_id where quantity > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:

select * from orders where total_amount > 20;

-- 9) List all genres available in the Books table:

select DISTINCT genre from Books; 


-- 10) Find the book with the lowest stock:

select * from Books order by stock ASC limit 5;


-- 11) Calculate the total revenue generated from all orders:


SELECT SUM(Total_Amount) AS Revenue FROM Orders;






-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select Books.genre, SUM(orders.quantity) AS Total_Quantity from 
Books join Orders on Books.book_id = Orders.book_id 
GROUP BY Books.genre ORDER BY Total_Quantity DESC;

-- 2) Find the average price of books in the genre:

SELECT AVG(price) AS Average_Price 
FROM Books
WHERE genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT orders.customer_id,Customers.name, COUNT(orders.order_id) FROM orders 
join Customers ON orders.customer_id = Customers.customer_id
GROUP BY Customers.name, orders.customer_id
HAVING COUNT(orders.order_id) >= 2 ORDER BY orders.customer_id ASC;

-- 4) Find the most frequently ordered book:

select Books.title, COUNT(orders.book_id) AS Total_Book_Ordered from 
Books join Orders on Books.book_id = Orders.book_id 
GROUP BY Books.title ORDER BY Total_Book_Ordered DESC;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre:

SELECT * from Books WHERE genre = 'Fantasy' 
ORDER BY price DESC LIMIT 3; 

-- 6) Retrieve the total quantity of books sold by each author:

select Books.author, SUM(orders.quantity) AS Total_Quantity from Books join Orders 
on Books.book_id = Orders.book_id GROUP BY Books.author ORDER BY Total_Quantity DESC;

-- 7) List the cities where customers who spent over $30 are located:

select DISTINCT(Customers.city), orders.total_amount 
from Customers join Orders 
on orders.customer_id = Customers.customer_id
WHERE total_amount > 30;







-- 8) Find the customer who spent the most on orders:


select Customers.customer_id,Customers.name, SUM(orders.total_amount) AS Total_Spent 
from Customers join Orders on orders.customer_id = Customers.customer_id
GROUP BY Customers.customer_id, Customers.name ORDER BY Total_Spent DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT  Books.book_id,Books.title,Books.stock, COALESCE(SUM(Orders.quantity),0) AS Order_Quantity,
Books.stock- COALESCE(SUM(Orders.quantity),0) AS Remaining_Quantity FROM  Books 
LEFT JOIN Orders ON Books.book_id = Orders.book_id
GROUP BY Books.book_id ORDER BY Books.book_id;








