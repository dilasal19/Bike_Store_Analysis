USE bike_store;

SELECT *
FROM customers;

-- Customers in each city
SELECT 
    city, COUNT(city) AS count
FROM
    customers
GROUP BY city
ORDER BY count DESC;

-- Customers in each state  
SELECT 
    state, COUNT(state) AS count
FROM
    customers
GROUP BY state
ORDER BY count DESC;

-- How many categories of bicycles are sold?
SELECT DISTINCT (category_name)
FROM categories;

-- Full names of the 3 staff with the highest number of customers along with the number of customers
SELECT *
FROM staffs;
SELECT *
FROM orders;

SELECT 
    ord.staff_id,
    COUNT(ord.Staff_id) AS total_customer,
    st.first_name,
    st.last_name,
    st.email,
    CONCAT(st.first_name, ' ', st.last_name) AS full_name_of_staff
FROM
    orders AS ord
        JOIN
    staffS AS st ON st.staff_id = ord.staff_id
GROUP BY ord.staff_id
ORDER BY total_customer DESC;

/*create case condition
when shipped date > required = 1 --> late 
else 0 --> on time */ 

SELECT 
    *,
    CASE
        WHEN shipped_date > required_date THEN 1
        ELSE 0
    END AS shipped_late
FROM
    orders;

/* How many orders are late? */
SELECT 
    SUM(shipped_late) AS count_order_late
FROM
    (SELECT 
        customer_id,
            required_date,
            shipped_date,
            store_id,
            staff_id,
            CASE
                WHEN shipped_date > required_date THEN 1
                ELSE 0
            END AS shipped_late
    FROM
        orders) AS subquery
WHERE
    shipped_late = 1;

-- Calculate processing time (day)
SELECT 
    cust.first_name,
    cust.last_name,
    cust.city,
    cust.email,
    ord.order_id,
    ord.order_status,
    ord.order_date,
    ord.shipped_date,
    DATEDIFF(shipped_date, order_date) AS processing_time,
    CONCAT(first_name, ' ', last_name) AS full_name
FROM
    customers AS cust
        JOIN
    orders AS ord ON ord.customer_id = cust.customer_id
ORDER BY processing_time DESC
LIMIT 1000;


SELECT*FROM order_items; 
SELECT*FROM products; 

-- Calculate final price(after discount)
SELECT 
    oi.product_id,
    oi.quantity,
    oi.list_price,
    oi.discount,
    ROUND((1 - discount) * (oi.list_price) * oi.quantity,2) AS final_price, 
	pd.product_name
FROM
    order_items AS oi
		JOIN
    products AS pd ON oi.product_id = pd.product_id
GROUP BY product_id
ORDER BY final_price DESC
LIMIT 100;

-- 10 most sold products
SELECT 
    oi.product_id,
    prod.product_name,
    prod.list_price,
    SUM(quantity) AS total_quantity
FROM
    order_items AS oi
        JOIN
    products AS prod ON prod.product_id = oi.product_id
GROUP BY product_name
ORDER BY total_quantity DESC
LIMIT 10;


/* What product, categories, and brand name that have highest price */
SELECT*FROM order_items; 
SELECT*FROM products; 
SELECT*FROM categories; 
SELECT*FROM brands; 

SELECT oi.list_price, oi.discount, 
ROUND(((1-discount)*(oi.list_price)),2) AS price_after_discount, 
pd.product_name, 
CASE 
	WHEN category_id= 1 THEN 'Children Bicycles'
	WHEN category_id= 2 THEN 'Comfort Bicycless'
    WHEN category_id= 3 THEN 'Cruisers Bicycles'
    WHEN category_id= 4 THEN 'Cyclocross Bicycles'
    WHEN category_id= 5 THEN 'Electric Bikes'
    WHEN category_id= 6 THEN 'Mountain Bikes'
    WHEN category_id= 7 THEN 'Road Bikes'
END AS category_name, 
CASE
	WHEN brand_id= 1 THEN 'Electra'
    WHEN brand_id= 2 THEN 'Haro'
    WHEN brand_id= 3 THEN 'Heller'
    WHEN brand_id= 4 THEN 'Pure Cycles'
    WHEN brand_id= 5 THEN 'Ritchey'
    WHEN brand_id= 6 THEN 'Strider'
    WHEN brand_id= 7 THEN 'Sun Bicycles'
    WHEN brand_id= 8 THEN 'Surly'
    WHEN brand_id= 9 THEN 'Trek'
END AS brand_name 
FROM order_items AS oi
JOIN products AS pd ON pd.product_id = oi.product_id
GROUP BY product_name
ORDER BY price_after_discount DESC;