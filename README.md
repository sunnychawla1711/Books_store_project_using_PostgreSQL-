# 📚 Book Store Management — SQL Analysis

A relational database project using **PostgreSQL** to model and analyze a Book Store's operations — from schema design to business-driven queries.

## 📌 About

This project showcases SQL-based data analysis using a Book Store Management dataset in PostgreSQL. The database was designed with relational tables for **Books, Customers, and Orders**, followed by solving real-world business problems using SQL queries.

It demonstrates practical SQL concepts including table creation, data import, filtering, joins, aggregation, grouping, sorting, and business analysis to generate meaningful insights from transactional data.

## 🗂️ Database Schema

**Books**
```sql
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
```

**Customers**
```sql
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
```

**Orders**
```sql
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
```

Data was loaded into each table from CSV files using PostgreSQL's `COPY` command.

## 🛠️ Tools Used
- PostgreSQL / pgAdmin

## 🔍 Questions & Queries

**1. Retrieve all books in the "Fiction" genre.**
```sql
SELECT * FROM Books WHERE genre = 'Fiction';
```

**2. Find books published after the year 1950.**
```sql
SELECT * FROM Books WHERE Published_Year >= 1950;
```

**3. List all customers from Canada.**
```sql
SELECT * FROM customers WHERE country = 'Canada';
```

**4. Show orders placed in November 2023.**
```sql
SELECT * FROM Orders 
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';
```

**5. Retrieve the total stock of books available.**
```sql
SELECT SUM(stock) FROM Books;
```
> Result: **25,056** books in stock

**6. Find the details of the most expensive book.**
```sql
SELECT * FROM Books ORDER BY price DESC LIMIT 1;
```

**7. Show all customers who ordered more than 1 quantity of a book.**
```sql
SELECT Customers.name, orders.quantity 
FROM Customers 
JOIN Orders ON Customers.customer_id = Orders.customer_id 
WHERE quantity > 1;
```

**8. Retrieve all orders where the total amount exceeds $20.**
```sql
SELECT * FROM orders WHERE total_amount > 20;
```

**9. List all genres available in the Books table.**
```sql
SELECT DISTINCT genre FROM Books;
```
> Result: Romance, Biography, Mystery, Fantasy, Fiction, Non-Fiction, Science Fiction

**10. Find the book with the lowest stock.**
```sql
SELECT * FROM Books ORDER BY stock ASC LIMIT 5;
```

**11. Calculate the total revenue generated from all orders.**
```sql
SELECT SUM(Total_Amount) AS Revenue FROM Orders;
```
> Result: **$75,628.66**

**12. Retrieve the total number of books sold for each genre.**
```sql
SELECT Books.genre, SUM(orders.quantity) AS Total_Quantity 
FROM Books 
JOIN Orders ON Books.book_id = Orders.book_id 
GROUP BY Books.genre 
ORDER BY Total_Quantity DESC;
```
> Result: Mystery (504), Science Fiction (447), Fantasy (446), Romance (439), Non-Fiction (351), Biography (285), Fiction (225)

**13. Find the average price of books in a genre (e.g. Fantasy).**
```sql
SELECT AVG(price) AS Average_Price 
FROM Books 
WHERE genre = 'Fantasy';
```
> Result: **$25.98**

**14. List customers who have placed at least 2 orders.**
```sql
SELECT orders.customer_id, Customers.name, COUNT(orders.order_id) 
FROM orders 
JOIN Customers ON orders.customer_id = Customers.customer_id 
GROUP BY Customers.name, orders.customer_id 
HAVING COUNT(orders.order_id) >= 2 
ORDER BY orders.customer_id ASC;
```

**15. Find the most frequently ordered book.**
```sql
SELECT Books.title, COUNT(orders.book_id) AS Total_Book_Ordered 
FROM Books 
JOIN Orders ON Books.book_id = Orders.book_id 
GROUP BY Books.title 
ORDER BY Total_Book_Ordered DESC;
```

**16. Show the top 3 most expensive books of the 'Fantasy' genre.**
```sql
SELECT * FROM Books 
WHERE genre = 'Fantasy' 
ORDER BY price DESC LIMIT 3;
```

**17. Retrieve the total quantity of books sold by each author.**
```sql
SELECT Books.author, SUM(orders.quantity) AS Total_Quantity 
FROM Books 
JOIN Orders ON Books.book_id = Orders.book_id 
GROUP BY Books.author 
ORDER BY Total_Quantity DESC;
```

**18. List the cities where customers who spent over $30 are located.**
```sql
SELECT DISTINCT(Customers.city), orders.total_amount 
FROM Customers 
JOIN Orders ON orders.customer_id = Customers.customer_id 
WHERE total_amount > 30;
```

**19. Find the customer who spent the most on orders.**
```sql
SELECT Customers.customer_id, Customers.name, SUM(orders.total_amount) AS Total_Spent 
FROM Customers 
JOIN Orders ON orders.customer_id = Customers.customer_id 
GROUP BY Customers.customer_id, Customers.name 
ORDER BY Total_Spent DESC LIMIT 1;
```
> Result: Kim Turner — **$1,398.90**

**20. Calculate the stock remaining after fulfilling all orders.**
```sql
SELECT Books.book_id, Books.title, Books.stock,
    COALESCE(SUM(Orders.quantity), 0) AS Order_Quantity,
    Books.stock - COALESCE(SUM(Orders.quantity), 0) AS Remaining_Quantity
FROM Books
LEFT JOIN Orders ON Books.book_id = Orders.book_id
GROUP BY Books.book_id
ORDER BY Books.book_id;
```

## 📊 Key Insights
- The store holds **25,056 books** in stock across 7 genres, generating **$75,628.66** in total revenue.
- **Mystery** is the best-selling genre by quantity, followed closely by Science Fiction and Fantasy.
- **Kim Turner** is the top customer by total spend, at $1,398.90.
- Several books have **zero stock remaining** after fulfilling orders — a signal for restocking priorities.
- Average Fantasy book price sits around **$25.98**, useful for genre-level pricing benchmarks.

## 🚀 Future Improvements
- Build a live dashboard (Power BI / Tableau) on top of this schema.
- Add a `Reviews` or `Returns` table to enrich customer behavior analysis.
- Automate low-stock alerts using triggers or scheduled queries.

---
⭐ If you found this useful, feel free to star the repo!

**Author:** Sunny Chawla
