--Example - see the top 5 records:

SELECT * FROM users
LIMIT 5;

--Example - see the bottom 5 records:

SELECT * FROM users
ORDER BY id DESC
LIMIT 5;

--Example - select all orders that were made by user_id 17: 

SELECT * FROM orders
WHERE user_id = 17;

--Example - count the number of instances belonging to each unique value in the paid column:

SELECT paid,COUNT(*)
FROM orders
GROUP BY paid;

--Example - select the departments with product counts greater than 5:

SELECT department, COUNT(*) AS num_of_products
FROM products
GROUP BY department
HAVING COUNT(*)>5
ORDER BY COUNT(*) DESC;

--Example - order the products table by price first, then by weight in descending order:

SELECT name, price, weight
FROM products
ORDER BY price DESC, weight DESC;

--Example - select *first_name*, *last_name*, *product_name*, *paid* columns of all people who made orders:

SELECT first_name, last_name, product_id, paid 
FROM orders
LEFT JOIN users ON users.id = orders.user_id;

--Example - find the product that has been ordered most frequently:

SELECT products.name, COUNT(*) as units_sold
FROM orders
JOIN products ON products.id = orders.product_id
GROUP BY products.name
ORDER BY COUNT(*) DESC;

--Example - find the names of people with the most orders:

SELECT users.first_name, users.last_name, o.num_of_orders
FROM users
JOIN 
(SELECT user_id, COUNT(*) AS num_of_orders
FROM orders
GROUP BY user_id) AS o
ON o.user_id = users.id
ORDER BY o.num_of_orders DESC;

--Example - select the product name, names of customers and paid columns from products, users, and orders tables:

SELECT products.name as product, first_name, last_name, paid
FROM orders
JOIN users on users.id = orders.user_id
JOIN products on products.id = orders.product_id;

--Example - select name, price, weight of products where price > 500 AND weight > 27:
(
SELECT name, price, weight
FROM products
WHERE price > 500
)
INTERSECT
(
SELECT name, price, weight
FROM products
WHERE weight > 27
);
