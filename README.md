# Pandas.DataFrame-SQL-Like-Commands

## <centre> PREVIEW DATA </center>

Example 1 - see the top 5 records:

*SQL*
```SQL
SELECT * FROM users
LIMIT 5;
```

*Python*
```python
users.head()
```

Example 2 - see the bottom 5 records:

*SQL*
```SQL
SELECT * FROM users
ORDER BY id DESC
LIMIT 5;
```

*Python*
```python
users.tail()
```
<br>

## <center> SELECT ROWS WITH SPECEFIC VALUE </center>
Example - select all orders that were made by user_id 17: 

*SQL*
```SQL
SELECT * FROM orders
WHERE user_id = 17;
```

*Python*
```python
orders.loc[orders['user_id']==17.0]
```

## <center> COUNT UNIQUE ELEMENTS IN A COLUMN </center>
Example - count the number of instances beloning to each unique value in the paid column:

*SQL*
```SQL
SELECT paid,COUNT(*)
FROM orders
GROUP BY paid;;
```

*Python*
```python
orders['paid'].value_counts()
```

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

*Python*
```python
pd.merge(orders, products, left_on ='product_id', right_on = 'id', how='inner').\
               groupby(['name']).count().sort_values(by='id_x', ascending=False)[['id_x']]
```

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

## <center> THREE WAY JOIN </center>
Example - select the product name, names of customers and paid columns from products, users, and orders tables:

*SQL*

```SQL
SELECT products.name as product, first_name, last_name, paid
FROM orders
JOIN users on users.id = orders.user_id
JOIN products on products.id = orders.product_id;
```

*Python*
```python
orders_users = pd.merge(orders, users, left_on ='user_id', right_on = 'id', how='inner')\
[['product_id','first_name','last_name','paid']]

products_orders_users = pd.merge(orders_users, products, left_on ='product_id', right_on = 'id',how='inner')\
[['name','first_name','last_name','paid']]
```
