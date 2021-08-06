# Pandas-SQL-Like-Commands

This is a short list of commands in Pandas that mimic common SQL queries when working with tables or dataframes, which can serve as quick reference. <br><br>
A direct comparison is provided by first displaying a SQL query, followed by its equivalent command in Pandas. <br><br>
When working with joins, the default join type in SQL is an inner join. However, the default operation in Pandas *merge* and *join* methods is a left join.  Therefore, it might be best to always explicitly state the type of join required. 


## <centre> PREVIEW DATA </center>
Example 1 - see the top 5 records:

*SQL*
```SQL
SELECT * FROM users
LIMIT 5;
```
![image](https://user-images.githubusercontent.com/61554673/128571417-4d17265d-52d2-4e4a-9c6a-ad2c7d7a4ee8.png)

*Python*
```python
users.head()
```
![image](https://user-images.githubusercontent.com/61554673/128571377-4a043c40-1c56-496e-88b5-044f491c3ba4.png)

Example 2 - see the bottom 5 records:

*SQL*
```SQL
SELECT * FROM users
ORDER BY id DESC
LIMIT 5;
```
![image](https://user-images.githubusercontent.com/61554673/128571250-8880b80e-8ea6-46ca-b18c-2a1ac39c3bec.png)

*Python*
```python
users.tail()
```
![image](https://user-images.githubusercontent.com/61554673/128571318-bf918b35-bfde-4514-84c6-2abd1cced75a.png)

## <center> SELECT ROWS WITH SPECEFIC VALUE </center>
Example - select all orders that were made by user_id 17: 

*SQL*
```SQL
SELECT * FROM orders
WHERE user_id = 17;
```
![image](https://user-images.githubusercontent.com/61554673/128571140-a17d6d42-9ded-4c48-a668-5e1bee1ab739.png)


*Python*
```python
orders.loc[orders['user_id']==17.0]
```
![image](https://user-images.githubusercontent.com/61554673/128571203-6733d423-fdd6-434d-bc97-2426446160cc.png)

## <center> COUNT UNIQUE COLUMN ELEMENTS </center>
Example - count the number of instances belonging to each unique value in the paid column:

*SQL*
```SQL
SELECT paid,COUNT(*)
FROM orders
GROUP BY paid;
```
![image](https://user-images.githubusercontent.com/61554673/128571104-9f49e5d0-43be-4afb-a398-55fef6d0e708.png)


*Python*
```python
orders['paid'].value_counts()
```
![image](https://user-images.githubusercontent.com/61554673/128571063-21cc81e2-9635-439c-92e4-beb2b27cceaa.png)


## <center> GROUP BY + HAVING </center>
Example - select the departments with product counts greater than 5:

*SQL*
```SQL
SELECT department, COUNT(*) AS num_of_products
FROM products
GROUP BY department
HAVING COUNT(*)>5
ORDER BY COUNT(*) DESC;
```
![image](https://user-images.githubusercontent.com/61554673/128571010-4b377812-0d86-438e-8500-c03c700efe01.png)

*Python*
```python
department_counts = products.groupby(['department']).count()[['id']].rename(columns={'id':'count'})
department_counts[department_counts>5].dropna().sort_values(by='count',ascending=False)
```
![image](https://user-images.githubusercontent.com/61554673/128570972-d208967b-f20e-4df8-8b3b-4d8d0dcd5d2c.png)

## <center> ORDERING BY MULTIPLE COLUMNS </center>
Example - order the products table by price first, then by weight in descending order:

*SQL*
```SQL
SELECT name, price, weight
FROM products
ORDER BY price DESC, weight DESC;
```
![image](https://user-images.githubusercontent.com/61554673/128570844-d77924f4-048b-4d72-bba9-3e30eab46616.png)

*Python*
```python
products.sort_values(by=['price','weight'], ascending=False)
```
![image](https://user-images.githubusercontent.com/61554673/128570932-e7e3b625-8aa7-465e-b1e4-e71377a8dc08.png)

## <center> SIMPLE JOIN </center>
Example - select *first_name*, *last_name*, *product_name*, *paid* columns of all people who made orders:

*SQL*
```SQL
SELECT first_name, last_name, product_id, paid 
FROM orders
LEFT JOIN users ON users.id = orders.user_id;
```

*Python*
```python
pd.merge(orders, users, left_on ='user_id', right_on = 'id', how='left')[['first_name','last_name',
                                                                          'product_id', 'paid']]
```

## <center> INNER JOIN + GROUP BY + ORDER BY </center>
Example - find the product that has been ordered most frequently:


*SQL*
```SQL
SELECT products.name, COUNT(*) as units_sold
FROM orders
JOIN products ON products.id = orders.product_id
GROUP BY products.name
ORDER BY COUNT(*) DESC;
```
![image](https://user-images.githubusercontent.com/61554673/128570765-798f0c87-a206-4723-b067-183aa6701f6b.png)

*Python*
```python
pd.merge(orders, products, left_on ='product_id', right_on = 'id', how='inner').\
               groupby(['name']).count().sort_values(by='id_x', ascending=False)[['id_x']]
```
![image](https://user-images.githubusercontent.com/61554673/128570733-6989b8ae-9e8a-41ea-9d5e-330cb070f40a.png)


## <center> JOIN + SUBQUERY + GROUP BY + ORDER BY </center>
Example - find the names of people with the most orders:

*SQL*
```SQL
SELECT users.first_name, users.last_name, o.num_of_orders
FROM users
JOIN 
(SELECT user_id, COUNT(*) AS num_of_orders
FROM orders
GROUP BY user_id) AS o
ON o.user_id = users.id
ORDER BY o.num_of_orders DESC;
```
![image](https://user-images.githubusercontent.com/61554673/128570670-4de36ae1-adb8-4a4b-8e59-8e3e3854685a.png)

*Python*
```python

# first group the orders table by user id
grouped_orders = orders.groupby(['user_id'])

# count the elements in each group
grouped_counts = grouped_orders.count()

# merge the aggregated and grouped table with users table
pd.merge(grouped_counts, users, left_on ='user_id', right_on = 'id', how='inner')\
[['first_name','last_name','id_x']].sort_values(by='id_x', ascending=False).\
rename(columns={'id_x':'num_of_orders'})
```
![image](https://user-images.githubusercontent.com/61554673/128570614-0db810fc-b3ef-4eba-8166-0fee79c84395.png)

## <center> THREE WAY JOIN </center>
Example - select the product name, names of customers and paid columns from products, users, and orders tables:

*SQL*

```SQL
SELECT products.name as product, first_name, last_name, paid
FROM orders
JOIN users on users.id = orders.user_id
JOIN products on products.id = orders.product_id;
```
![image](https://user-images.githubusercontent.com/61554673/128570072-d2ecc0fa-8011-480b-be20-eeb2b5f3ad5b.png)

*Python*
```python
orders_users = pd.merge(orders, users, left_on ='user_id', right_on = 'id', how='inner')\
[['product_id','first_name','last_name','paid']]

products_orders_users = pd.merge(orders_users, products, left_on ='product_id', right_on = 'id',how='inner')\
[['name','first_name','last_name','paid']]

products_orders_users
```
![image](https://user-images.githubusercontent.com/61554673/128570010-a8270e8a-1d44-4dab-b500-7b89d0833825.png)

## <center> INTERSECTION </center>
Example - select name, price, weight of products where price > 500 AND weight > 27:

*SQL*
```SQL
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
)
```
![image](https://user-images.githubusercontent.com/61554673/128569823-1c5ab478-64b7-4679-9815-2b8d503213a9.png)

*Python*
```python
query_1 = products[products.price > 500][['name', 'price', 'weight']]
query_2 = products[products.weight > 27][['name', 'price', 'weight']]
pd.merge(query_1, query_2, how='inner')
```
![image](https://user-images.githubusercontent.com/61554673/128569868-92590e58-1d4f-4c87-ab97-5a1e01838fd3.png)
