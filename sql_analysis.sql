-- loading whole dataset
CREATE DATABASE MUZAN;
USE MUZAN;


CREATE TABLE fuzzy (
    table_name VARCHAR(255) NOT NULL,
    field_name VARCHAR(255) NOT NULL,
    description TEXT
);
DESCRIBE fuzzy;
CREATE TABLE web_sessions (
    website_session_id INT,
    created_at DATETIME,
    user_id INT,
    is_repeat_session INT,
    utm_source VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_content VARCHAR(100),
    device_type VARCHAR(50),
    http_referer VARCHAR(500)
);


DESCRIBE web_sessions;




SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA LOCAL INFILE 'C:/Users/wedne/Downloads/Maven+Fuzzy+Factory/website_sessions.csv'
INTO TABLE web_session
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


CREATE TABLE web_pageview (
    website_pageview_id INT PRIMARY KEY,
    created_at DATETIME NOT NULL,
    website_session_id INT NOT NULL,
    pageview_url VARCHAR(255)
);

LOAD DATA LOCAL INFILE 'C:/Users/wedne/Downloads/Maven+Fuzzy+Factory/website_pageviews.csv'
INTO TABLE web_pageview
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

describe products;
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    created_at DATETIME NOT NULL,
    product_name VARCHAR(255) NOT NULL
);

CREATE TABLE order_item_refunds (
    order_item_refund_id INT PRIMARY KEY,
    created_at DATETIME NOT NULL,
    order_item_id INT NOT NULL,
    order_id INT NOT NULL,
    refund_amount_usd DECIMAL(10,2) NOT NULL
);
CREATE TABLE order_items (
    order_id INT NOT NULL,
    created_at DATETIME NOT NULL,
    website_session_id INT NOT NULL,
    user_id INT NOT NULL,
    primary_product_id INT NOT NULL,
    items_purchased INT NOT NULL,
    price_usd DECIMAL(10,2) NOT NULL,
    cogs_usd DECIMAL(10,2) NOT NULL
);
LOAD DATA LOCAL INFILE 'C:/Users/wedne/Downloads/Maven+Fuzzy+Factory/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT COUNT(*) FROM orders;



LOAD DATA LOCAL INFILE 'C:/Users/wedne/Downloads/Maven+Fuzzy+Factory/website_sessions.csv'
INTO TABLE web_sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- dataset got uploaded now we will move towars table to table analysis

-- websession and pageviews analysis

describe fuzzy;
describe web_sessions;
describe web_pageview;
describe products;
describe orders;
describe order_items;

-- fuzzy

SELECT * from fuzzy; 
select count(*) from fuzzy;

-- web_sessions
select count(*) from web_sessions;
select * from web_sessions;
select distinct utm_source
from web_sessions;
SELECT 
    utm_source, 
    COUNT(website_session_id) AS total_sessions
FROM web_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;

-- utm_source consist of 4 categories , among them gsearch is on top , than niul ,phit bsearch and at end is socialbook
SELECT 
    COALESCE(utm_source, 'direct_or_organic') AS source, 
    COUNT(website_session_id) AS total_sessions
FROM web_sessions
GROUP BY COALESCE(utm_source, 'direct_or_organic')
ORDER BY total_sessions DESC;

SELECT 
    utm_source, 
    utm_campaign, 
    utm_content, 
    COUNT(website_session_id) AS total_sessions
FROM web_sessions
WHERE utm_source IS NOT NULL
GROUP BY utm_source, utm_campaign, utm_content
ORDER BY total_sessions DESC;

SELECT *
FROM web_sessions
WHERE utm_source = 'gsearch'
LIMIT 100;
select *
from web_sessions
where utm_source = 'direct_or_organic'
limit 200;
select* from web_sessions
where utm_source='bsearch'
limit 200;
select * from web_sessions
where utm_source='socialbook'
limit 100;
SELECT *
FROM web_sessions
WHERE utm_source IS NULL
LIMIT 200;
SELECT *
FROM web_sessions
WHERE COALESCE(utm_source, 'direct_or_organic') = 'direct_or_organic'
LIMIT 200;

-- utm_campaign

select distinct utm_campaign
from web_sessions;

select utm_campaign,
count(website_session_id)as total_sessions
from web_sessions
group by utm_campaign
order by total_sessions desc;
-- utm_campaign consist of 5 categories most common is nonbrans, than null , than brand, desktop_targeted and at last pilot
SELECT 
    utm_source, 
    utm_campaign, 
    utm_content, 
    COUNT(website_session_id) AS total_sessions
FROM web_sessions
WHERE utm_campaign IS NOT NULL
GROUP BY utm_source, utm_campaign, utm_content
ORDER BY total_sessions DESC;

select * from web_sessions
where utm_campaign='nonbrand'
limit 100;

select * from web_sessions
where utm_campaign = 'brand'
limit 100;

-- utm_sourse and utm_campaign ka mutual connection 
select
 utm_source,
 utm_campaign,
 count(website_session_id) as total_count
 from web_sessions
group by utm_source ,utm_campaign
order by total_count desc;
-- UTM Analysis: Most website traffic came from gsearch nonbrand campaigns (282,706 sessions),
 -- making it the dominant traffic source. bsearch nonbrand was the second-largest source (54,909).
--  Brand campaigns generated considerably less traffic than nonbrand campaigns for both gsearch and bsearch.
--  socialbook contributed relatively little traffic. 83,328 sessions had no UTM source/campaign recorded, 
--  so their marketing origin is unknown from these fields.

-- utm_content
select distinct utm_content
from web_sessions;

select utm_content,
count(website_session_id)as total_sessions
from web_sessions
group by utm_content
order by total_sessions desc;

-- Search advertising was the major source of identifiable traffic, particularly g_ad_1.
--  Social advertising contributed relatively little traffic. However, a substantial number of sessions had missing campaign information, 
--  so campaign performance cannot be evaluated completely from this field alone.

SELECT
utm_source,
utm_campaign,
utm_content,
count(website_session_id)as total_count
from web_sessions
group by utm_source, utm_campaign, utm_content
order by total_count desc;

-- Analysis: Search traffic, particularly Google nonbrand (gsearch / nonbrand / g_ad_1), 
-- was the dominant identifiable source of website sessions.
-- Comparison: Nonbrand campaigns generated substantially more traffic than brand campaigns,
--  while social campaigns contributed relatively little traffic.
-- Data limitation: 83,328 sessions have missing UTM information,
--  so the complete distribution of traffic sources cannot be determined from this analysis alone.

-- device type
select distinct device_type
from web_sessions;
SELECT
device_type,
utm_source,
utm_campaign,
utm_content,
count(website_session_id)as total_count
from web_sessions
group by utm_source, utm_campaign, utm_content, device_type
order by total_count desc;

--  

select distinct http_referer
from web_sessions;

SELECT
device_type,
http_referer,
utm_source,
utm_campaign,
utm_content,
count(website_session_id)as total_count
from web_sessions
group by utm_source, utm_campaign, utm_content, device_type, http_referer
order by total_count desc;

-- Google is the strongest identifiable traffic referrer,
--  with desktop users generating considerably more sessions than mobile users.
--  Bing is a secondary source, while social traffic is relatively small.
--  Some sessions have a referrer but no UTM campaign information,
--  and others have no referrer at all, so the two fields provide complementary—not
--  identical—information about traffic acquisition.
SELECT
    DATE(created_at) AS session_date,
    COUNT(*) AS sessions
FROM web_sessions
GROUP BY DATE(created_at)
ORDER BY session_date;
SELECT
    DATE_FORMAT(created_at, '%Y-%m') AS month,
    COUNT(*) AS sessions
FROM web_sessions
GROUP BY month
ORDER BY month;

SELECT
    user_id,
    COUNT(*) AS sessions
FROM web_sessions
GROUP BY user_id
ORDER BY sessions DESC;
SELECT
    is_repeat_session,
    COUNT(*) AS sessions
FROM web_sessions
GROUP BY is_repeat_session;
SELECT
    session_count,
    COUNT(*) AS number_of_users
FROM (
    SELECT
        user_id,
        COUNT(*) AS session_count
    FROM web_sessions
    GROUP BY user_id
) AS user_sessions
GROUP BY session_count
ORDER BY session_count;
SELECT
    is_repeat_session,
    COUNT(*) AS sessions,
    COUNT(DISTINCT user_id) AS users
FROM web_sessions
GROUP BY is_repeat_session;

-- web_pageview
select * from web_pageview;
SELECT 
    pageview_url,
    COUNT(website_pageview_id) AS wp_count
FROM web_pageview
GROUP BY pageview_url
ORDER BY wp_count DESC;

-- Pageview Analysis: /products was the most-viewed page, followed by 
-- /the-original-mr-fuzzy and /home. Product and landing pages generated 
-- substantial browsing activity, while /cart, /shipping, and
--  /billing show significant traffic reaching later stages of the purchase journey. 
--  The large differences in product-page views suggest that customer interest varies considerably 
--  across products. Further analysis should examine how page visits translate into orders and where
--  users drop off in the purchase funnel.
SELECT
    website_session_id,
    COUNT(website_pageview_id) AS pageviews
FROM web_pageview
GROUP BY website_session_id
ORDER BY pageviews DESC;

SELECT
    pageviews,
    COUNT(*) AS total_sessions
FROM (
    SELECT
        website_session_id,
        COUNT(website_pageview_id) AS pageviews
    FROM web_pageview
    GROUP BY website_session_id
) AS session_pageviews
GROUP BY pageviews
ORDER BY pageviews;


select
pageviews,
count(*) as total_sessions
from
(select
website_session_id,
count(website_pageview_id) as pageviews
from web_pageview
group by website_session_id)
as session_pageviews
group by pageviews
order by pageviews;

-- cPageviews per Session: A large share of sessions contained
--  only one pageview, indicating many visitors left without exploring further
-- Sessions with three pageviews were also substantial, while 32,313 sessions 
--  reached seven pageviews, suggesting deeper engagement among a smaller group of visitors.

select date(created_at) as visit_date,
count(website_pageview_id)as total_pageviews
from web_pageview
group by date(created_at)
order by visit_date;


SELECT
    HOUR(created_at) AS visit_hour,
    COUNT(website_pageview_id) AS total_pageviews
FROM web_pageview
GROUP BY HOUR(created_at)
ORDER BY visit_hour;

-- Time-of-Day Analysis: Website activity was lowest during the early morning hours 
-- and increased sharply after 8 AM. Traffic peaked between 10 AM and 4 PM, with
--  the highest pageview volume at 12 PM (79,678). Activity gradually declined after 
--  4 PM, indicating that daytime hours generated the strongest website engagement.


-- orders and products

select * from orders;
use orders;
select distinct items_purchased
from orders;
select distinct primary_product_id
from orders;
-- primary product id is 0_4
-- item purchased are 1,2,30,46,50,60,
select distinct price_usd
from orders;
select distinct cogs_usd
from orders;
-- price and cogs are also lying in a small field maybe they are relevent to poducts
SELECT 
    primary_product_id,
    SUM(items_purchased) AS total_items_purchased
FROM orders
GROUP BY primary_product_id
ORDER BY total_items_purchased DESC;



select * from products;
--  here is an issue primary products are 4 than how primary product is  id 5
SELECT 
    primary_product_id,
    SUM(items_purchased) AS total_items_purchased
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    price_usd,
    cogs_usd
FROM orders
GROUP BY
    primary_product_id,
    price_usd,
    cogs_usd
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    AVG(price_usd) AS avg_price_usd,
    AVG(cogs_usd) AS avg_cogs_usd
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    SUM(items_purchased * price_usd) AS revenue,
    SUM(items_purchased * cogs_usd) AS total_cogs,
    SUM(items_purchased * (price_usd - cogs_usd)) AS gross_profit
FROM orders
GROUP BY primary_product_id
ORDER BY gross_profit DESC;

select  website_session_id,
count(*) as order_count
from orders
group by website_session_id;

SELECT COUNT(DISTINCT website_session_id) AS total_sessions
FROM orders;
SELECT COUNT(DISTINCT website_session_id) AS purchasing_sessions
FROM orders;
SELECT 
    website_session_id,
    COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY website_session_id
ORDER BY orders DESC;

SELECT 
    website_session_id,
    SUM(items_purchased) AS total_items
FROM orders
GROUP BY website_session_id
ORDER BY total_items DESC;

SELECT 
    website_session_id,
    SUM(items_purchased * price_usd) AS revenue
FROM orders
GROUP BY website_session_id
ORDER BY revenue DESC;

SELECT 
    user_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT website_session_id) AS total_buying_sessions,
    COUNT(DISTINCT primary_product_id) AS distinct_products_bought
FROM orders
GROUP BY user_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;
-- user_id 1,2,3,4 had most orders , they had higher totoal_buying_sessions, 
-- and they mostly bought product 4
SELECT 
    primary_product_id,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT user_id) AS unique_buyers,
    COUNT(DISTINCT website_session_id) AS converting_sessions
FROM orders
GROUP BY primary_product_id
ORDER BY total_orders DESC;
-- primary key 1,2,3,4 have most orders, unique_buyers 
-- and converting_sessions in arespective order
SELECT 
    o.primary_product_id,
    ws.is_repeat_session,
    COUNT(DISTINCT o.user_id) AS unique_users,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN web_sessions ws 
    ON o.website_session_id = ws.website_session_id
GROUP BY o.primary_product_id, ws.is_repeat_session
ORDER BY o.primary_product_id, ws.is_repeat_session;

### Summary Analysis: Product Performance & Repeat Sessions

-- * **Product 1 (Flagship Driver):** Generates **~80%+** of total orders (**130.6K** new / **28.2K** repeat). Primary acquisition hero product.
-- * **Products 2 & 3 (Secondary Drivers):** Solid secondary volume (**24.2K** and **14.3K** new orders respectively).
-- * **Product 4 (Niche/Low Volume):** Lowest overall sales (**2.7K** new / **744** repeat orders).
-- * **Product 0 (Data Anomaly):** **2.6K** legacy/untagged orders prior to product tracking.
-- * **Customer Behavior Pattern:** **~80–82%** of all orders come from first-time sessions (`is_repeat_session = 0`), 
-- while **~18–20%** come from returning users (`is_repeat_session = 1`). Sales heavily rely on new user acquisition.

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(order_id) AS total_orders,
    SUM(items_purchased) AS total_items_sold,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(price_usd - cogs_usd), 2) AS total_profit,
    ROUND(AVG(price_usd), 2) AS avg_order_value
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

### Monthly Time-Series Analysis Summary

-- * **Rapid Growth (2012–2014):** Monthly revenue scaled aggressively from **$9.4K** (Mar 2012) to a peak of **$434.5K** (Dec 2014).
-- * **Strong Q4 Seasonality:** Distinct sales spikes occur every November–December due to holiday demand (e.g., Dec 2014 achieved 6,942 orders and $434.5K revenue).
-- * **Expanding AOV:** Average Order Value increased steadily over time from **~$49.80** in early 2012 to **~$62–$64** in 2014–2015, 
-- driven by new product additions and price increases.
-- * **Volume Stabilization (2015):** Monthly revenue plateaued around **~$380K–$396K** in early 2015 before the dataset ends in March 2015


SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT user_id) AS unique_customers,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders;

SELECT
    items_purchased,
    COUNT(*) AS total_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;

SELECT
    user_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

SELECT
    primary_product_id,
    ROUND(SUM(price_usd), 2) AS revenue,
    ROUND(
        SUM(price_usd) * 100.0 /
        (SELECT SUM(price_usd) FROM orders), 2
    ) AS revenue_percentage
FROM orders
GROUP BY primary_product_id
ORDER BY revenue DESC;

SELECT
    primary_product_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS revenue
FROM orders
WHERE primary_product_id = 0
GROUP BY primary_product_id;

SELECT *
FROM orders
WHERE primary_product_id = 0
LIMIT 10;
SELECT *
FROM products
WHERE product_id = 0;

SELECT
    primary_product_id,
    COUNT(*) AS total_orders,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(cogs_usd), 2) AS avg_cogs,
    SUM(items_purchased) AS total_items
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT *
FROM order_items
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE primary_product_id = 0
)
LIMIT 20;

SELECT
    o.order_id,
    o.primary_product_id,
    oi.product_id,
    oi.price_usd
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
LIMIT 20;

SELECT
    oi.product_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price_usd), 2) AS item_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
GROUP BY oi.product_id
ORDER BY total_orders DESC;

SELECT COUNT(*) AS unmatched_orders
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
  AND oi.order_id IS NULL;
  
  SELECT COUNT(DISTINCT o.order_id) AS matched_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0;


SELECT
    items_purchased,
    COUNT(*) AS total_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS customer_orders;

SELECT
    order_id,
    items_purchased,
    price_usd,
    cogs_usd
FROM orders
WHERE items_purchased >= 30
LIMIT 10;

SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id), 2
    ) AS conversion_rate_pct
FROM web_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id;
    
    
    SELECT
    ws.utm_source,
    ws.utm_campaign,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id), 2
    ) AS conversion_rate_pct
FROM web_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source, ws.utm_campaign
ORDER BY conversion_rate_pct DESC;

SELECT
    COUNT(*) AS total_orders,
    SUM(primary_product_id = 0) AS zero_id_orders,
    SUM(primary_product_id IS NULL) AS null_id_orders
FROM orders;


-- order_id
select * from orders;
use orders;
select distinct items_purchased
from orders;
select distinct primary_product_id
from orders;
-- primary product id is 0_4
-- item purchased are 1,2,30,46,50,60,
select distinct price_usd
from orders;
select distinct cogs_usd
from orders;
-- price and cogs are also lying in a small field maybe they are relevent to poducts
SELECT 
    primary_product_id,
    SUM(items_purchased) AS total_items_purchased
FROM orders
GROUP BY primary_product_id
ORDER BY total_items_purchased DESC;



select * from products;
--  here is an issue primary products are 4 than how primary product is  id 5
SELECT 
    primary_product_id,
    SUM(items_purchased) AS total_items_purchased
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    price_usd,
    cogs_usd
FROM orders
GROUP BY
    primary_product_id,
    price_usd,
    cogs_usd
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    AVG(price_usd) AS avg_price_usd,
    AVG(cogs_usd) AS avg_cogs_usd
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT
    primary_product_id,
    SUM(items_purchased * price_usd) AS revenue,
    SUM(items_purchased * cogs_usd) AS total_cogs,
    SUM(items_purchased * (price_usd - cogs_usd)) AS gross_profit
FROM orders
GROUP BY primary_product_id
ORDER BY gross_profit DESC;

select  website_session_id,
count(*) as order_count
from orders
group by website_session_id;

SELECT COUNT(DISTINCT website_session_id) AS total_sessions
FROM orders;
SELECT COUNT(DISTINCT website_session_id) AS purchasing_sessions
FROM orders;
SELECT 
    website_session_id,
    COUNT(DISTINCT order_id) AS orders
FROM orders
GROUP BY website_session_id
ORDER BY orders DESC;

SELECT 
    website_session_id,
    SUM(items_purchased) AS total_items
FROM orders
GROUP BY website_session_id
ORDER BY total_items DESC;

SELECT 
    website_session_id,
    SUM(items_purchased * price_usd) AS revenue
FROM orders
GROUP BY website_session_id
ORDER BY revenue DESC;

SELECT 
    user_id,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT website_session_id) AS total_buying_sessions,
    COUNT(DISTINCT primary_product_id) AS distinct_products_bought
FROM orders
GROUP BY user_id
HAVING COUNT(DISTINCT order_id) > 1
ORDER BY total_orders DESC;
-- user_id 1,2,3,4 had most orders , they had higher totoal_buying_sessions, 
-- and they mostly bought product 4
SELECT 
    primary_product_id,
    COUNT(order_id) AS total_orders,
    COUNT(DISTINCT user_id) AS unique_buyers,
    COUNT(DISTINCT website_session_id) AS converting_sessions
FROM orders
GROUP BY primary_product_id
ORDER BY total_orders DESC;
-- primary key 1,2,3,4 have most orders, unique_buyers 
-- and converting_sessions in arespective order
SELECT 
    o.primary_product_id,
    ws.is_repeat_session,
    COUNT(DISTINCT o.user_id) AS unique_users,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN web_sessions ws 
    ON o.website_session_id = ws.website_session_id
GROUP BY o.primary_product_id, ws.is_repeat_session
ORDER BY o.primary_product_id, ws.is_repeat_session;

### Summary Analysis: Product Performance & Repeat Sessions

-- * **Product 1 (Flagship Driver):** Generates **~80%+** of total orders (**130.6K** new / **28.2K** repeat). Primary acquisition hero product.
-- * **Products 2 & 3 (Secondary Drivers):** Solid secondary volume (**24.2K** and **14.3K** new orders respectively).
-- * **Product 4 (Niche/Low Volume):** Lowest overall sales (**2.7K** new / **744** repeat orders).
-- * **Product 0 (Data Anomaly):** **2.6K** legacy/untagged orders prior to product tracking.
-- * **Customer Behavior Pattern:** **~80–82%** of all orders come from first-time sessions (`is_repeat_session = 0`), 
-- while **~18–20%** come from returning users (`is_repeat_session = 1`). Sales heavily rely on new user acquisition.

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(order_id) AS total_orders,
    SUM(items_purchased) AS total_items_sold,
    ROUND(SUM(price_usd), 2) AS total_revenue,
    ROUND(SUM(price_usd - cogs_usd), 2) AS total_profit,
    ROUND(AVG(price_usd), 2) AS avg_order_value
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

### Monthly Time-Series Analysis Summary

-- * **Rapid Growth (2012–2014):** Monthly revenue scaled aggressively from **$9.4K** (Mar 2012) to a peak of **$434.5K** (Dec 2014).
-- * **Strong Q4 Seasonality:** Distinct sales spikes occur every November–December due to holiday demand (e.g., Dec 2014 achieved 6,942 orders and $434.5K revenue).
-- * **Expanding AOV:** Average Order Value increased steadily over time from **~$49.80** in early 2012 to **~$62–$64** in 2014–2015, 
-- driven by new product additions and price increases.
-- * **Volume Stabilization (2015):** Monthly revenue plateaued around **~$380K–$396K** in early 2015 before the dataset ends in March 2015


SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT user_id) AS unique_customers,
    ROUND(AVG(price_usd), 2) AS average_order_value
FROM orders;

SELECT
    items_purchased,
    COUNT(*) AS total_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;

SELECT
    user_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY total_orders DESC;

SELECT
    primary_product_id,
    ROUND(SUM(price_usd), 2) AS revenue,
    ROUND(
        SUM(price_usd) * 100.0 /
        (SELECT SUM(price_usd) FROM orders), 2
    ) AS revenue_percentage
FROM orders
GROUP BY primary_product_id
ORDER BY revenue DESC;

SELECT
    primary_product_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(price_usd), 2) AS revenue
FROM orders
WHERE primary_product_id = 0
GROUP BY primary_product_id;

SELECT *
FROM orders
WHERE primary_product_id = 0
LIMIT 10;
SELECT *
FROM products
WHERE product_id = 0;

SELECT
    primary_product_id,
    COUNT(*) AS total_orders,
    ROUND(AVG(price_usd), 2) AS avg_price,
    ROUND(AVG(cogs_usd), 2) AS avg_cogs,
    SUM(items_purchased) AS total_items
FROM orders
GROUP BY primary_product_id
ORDER BY primary_product_id;

SELECT *
FROM order_items
WHERE order_id IN (
    SELECT order_id
    FROM orders
    WHERE primary_product_id = 0
)
LIMIT 20;

SELECT
    o.order_id,
    o.primary_product_id,
    oi.product_id,
    oi.price_usd
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
LIMIT 20;

SELECT
    oi.product_id,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price_usd), 2) AS item_revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
GROUP BY oi.product_id
ORDER BY total_orders DESC;

SELECT COUNT(*) AS unmatched_orders
FROM orders o
LEFT JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0
  AND oi.order_id IS NULL;
  
  SELECT COUNT(DISTINCT o.order_id) AS matched_orders
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.primary_product_id = 0;


SELECT
    items_purchased,
    COUNT(*) AS total_orders
FROM orders
GROUP BY items_purchased
ORDER BY items_purchased;

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT user_id
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 1
) AS customer_orders;

SELECT
    order_id,
    items_purchased,
    price_usd,
    cogs_usd
FROM orders
WHERE items_purchased >= 30
LIMIT 10;

SELECT
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id), 2
    ) AS conversion_rate_pct
FROM web_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id;
    
    
    SELECT
    ws.utm_source,
    ws.utm_campaign,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) * 100.0 /
        COUNT(DISTINCT ws.website_session_id), 2
    ) AS conversion_rate_pct
FROM web_sessions ws
LEFT JOIN orders o
    ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_source, ws.utm_campaign
ORDER BY conversion_rate_pct DESC;

SELECT
    COUNT(*) AS total_orders,
    SUM(primary_product_id = 0) AS zero_id_orders,
    SUM(primary_product_id IS NULL) AS null_id_orders
FROM orders;


-- all of my business interpretations
select * from fuzzy;
-- this table contain coolumns of all the tables.
-- the sequecnce of tables analysis should be
-- --products,website_session, website_pageview, orders, order_items, order_items_refund
-- products
-- * **Product 1 (`Mr. Fuzzy`):** Launched in March 2012 as the flagship product, operating solo for 10 months to build initial core revenue.
-- * **Product 2 (`Love Bear`):** Introduced in January 2013 right before Valentine's Day, successfully kickstarting multi-product cross-selling.
-- * **Product 3 (`Sugar Panda`):** Released in December 2013 to capitalize on holiday gift demand and expand the catalog.
-- * **Product 4 (`Mini Bear`):** Added in February 2014 as a lower-priced option to boost basket sizes and total orders.
-- website_session
-- --utm Analysis: Most website traffic came from gsearch nonbrand campaigns (282,706 sessions),
 -- making it the dominant traffic source. bsearch nonbrand was the second-largest source (54,909).
--  Brand campaigns generated considerably less traffic than nonbrand campaigns for both gsearch and bsearch.
--  socialbook contributed relatively little traffic. 83,328 sessions had no UTM source/campaign recorded, 
--  so their marketing origin is unknown from these fields.
-- utm_content: Search advertising was the major source of identifiable traffic, particularly g_ad_1.
--  Social advertising contributed relatively little traffic. However, a substantial number of sessions had missing campaign information, 
--  so campaign performance cannot be evaluated completely from this field alone.

device
Google is the strongest identifiable traffic referrer,
--  with desktop users generating considerably more sessions than mobile users.
--  Bing is a secondary source, while social traffic is relatively small.
--  Some sessions have a referrer but no UTM campaign information,
--  and others have no referrer at all, so the two fields provide complementary—not
--  identical—information about traffic acquisition.
time effect
-- Maven Fuzzy Factory experienced substantial growth in website traffic 
-- from 2012 through 2014, with sessions increasing roughly eightfold from 
-- the beginning of the observed period. Traffic shows recurring seasonal 
-- spikes around November–December, while early 2015 shows a noticeable decline 
-- from the late-2014/January-2015 highs.
repeat_sessions and user_id
-- Most website traffic came from non-repeat sessions,
--  while a smaller portion came from returning users.
--  This suggests that the website relied more heavily on 
--  acquiring/attracting new visits than on repeat visits.

website_pageview
url= Pageview Analysis: /products was the most-viewed page, followed by 
-- /the-original-mr-fuzzy and /home. Product and landing pages generated 
-- substantial browsing activity, while /cart, /shipping, and
--  /billing show significant traffic reaching later stages of the purchase journey. 
--  The large differences in product-page views suggest that customer interest varies considerably 
--  across products. Further analysis should examine how page visits translate into orders and where

session
Pageviews per Session: A large share of sessions contained
--  only one pageview, indicating many visitors left without exploring further
-- Sessions with three pageviews were also substantial, while 32,313 sessions 
--  reached seven pageviews, suggesting deeper engagement among a smaller group of visitors.
time
-- Time-of-Day Analysis: Website activity was lowest during the early morning hours 
-- and increased sharply after 8 AM. Traffic peaked between 10 AM and 4 PM, with
--  the highest pageview volume at 12 PM (79,678). Activity gradually declined after 
--  4 PM, indicating that daytime hours generated the strongest website engagement.

orders
one problem i till see is that 5 primary_product_keys are working in orders while elsewhere they are 4
most of the items_purchased are by id_1 , least by id 4,
-- Product 2 has the highest average selling price ($65.97) and COGS ($24.46),
--  while product 4 has the lowest average price ($34.04) and COGS ($10.92); 
--  product 0 likely represents missing/unknown product identification and should be investigated.

-- Product 1 dominates performance, generating $12.51M revenue and $6.61M profit,
--  making it the largest contributor by far; product 2 ranks second with $1.68M revenue and $1.05M profit.

-- Products 3 and 4 generate $723.9K and $63.6K profit, respectively,
--  while product 0 generates $290.6K; investigate product 0’s meaning before drawing product-level conclusions.

### Monthly Time-Series Analysis Summary

-- * **Rapid Growth (2012–2014):** Monthly revenue scaled aggressively from **$9.4K** (Mar 2012) to a peak of **$434.5K** (Dec 2014).
-- * **Strong Q4 Seasonality:** Distinct sales spikes occur every November–December due to holiday demand (e.g., Dec 2014 achieved 6,942 orders and $434.5K revenue).
-- * **Expanding AOV:** Average Order Value increased steadily over time from **~$49.80** in early 2012 to **~$62–$64** in 2014–2015, 
-- driven by new product additions and price increases.
-- * **Volume Stabilization (2015):** Monthly revenue plateaued around **~$380K–$396K** in early 2015 before the dataset ends in March 2015.
-- * Orders: 139,053 orders from 3,170 unique customers; average order value: $58.79.

-- * Items per order: Most orders contain 1 item, followed by 2 items; bulk purchases are less common.
-- Repeat customers: Some customers have placed up to 5 orders, while many have placed 8–14 orders, indicating repeat purchasing;
-- Revenue concentration: Product 1 generates 73.62% ($6.02M) of total revenue,
--  followed by product 2 at 15.99% and product 3 at 8.87%—the business is heavily dependent on product 1.

-- 1,310 orders have primary_product_id = 0.

-- 92 orders have matching records in order_items.

-- 1,218 orders have no matching records in order_items.

-- These zero-ID orders generated $44,887.27 in recorded revenue.

-- Overall, 6.83% of website sessions converted into orders;
--  gsearch nonbrand generated the most orders (22,212),
--  while bsearch brand had the highest conversion rate (10.03%) and socialbook pilot performed worst (1.08%).

order_item
 Dataset Findings Summary:
-- Product 1 primary selling driver hai (9,792 primary vs 44 cross-sell).

-- Product 4 pure cross-sell product hai (136 cross-sell vs 0 primary)
-- —yeh site par akele nahi bikti, balke sirf doosre products ke sath checkout par cross-sell hoti hai.

-- **Product 1 drives 80%+ of total revenue as the core acquisition hero,
--  while Product 3 and Product 4 act almost exclusively
--  as checkout add-ons to boost Average Order Value (AOV).**

-- refund
-- **Order Item Refunds — Overall Overview**

-- The table contains **1,731 refund records** associated with **1,723 unique orders**.
--  The total refunded amount is approximately **$85,338.69**, with an average refund of **$49.30 per record**. Since refund records exceed unique orders by 8, some orders have multiple refund records.

-- **Business insight:** Refunds represent a measurable loss of sales revenue. 
-- The next step is to investigate when refunds occurred and whether refund activity changed over time.

-- **Monthly Refund Trend — Summary**

-- Refund activity generally increased from 5 records per month in April–June 2012 to much higher levels in 2014. 
-- September 2014 recorded the highest number of refunds (237), totaling $11,773.63. December 2014 was another peak, 
-- with 122 refunds totaling $5,908.78. Refund activity remained relatively high in early 2015 before dropping sharply in April 2015,
--  when only 2 records were recorded.

-- **Business insight:** The unusually high refund count in September 2014 deserves further investigation. The April 2015 decline may reflect incomplete data rather than a genuine improvement, since the dataset ends that month.
-- Product 1 accounts for the largest share of recorded refunds by a substantial margin.
--  Its sales volume should be compared with its refund volume before concluding that it has a higher refund rate
--  or a product-quality problem.

-- **Multiple Refunds per Order**

-- Only a small number of orders have multiple refund records. The highest observed count is 2 refunds per order, with total refunded amounts ranging from $79.98 to $109.98 in the displayed results.

-- **Insight:** Multiple refunds within one order may indicate refunds for separate items. This does not necessarily mean the same item was refunded twice.
-- **Refund Amount Distribution**

-- Most refunds are for $49.99 (1,237 records), followed by $45.99 (301), $59.99 (129), and $29.99 (64).

-- **Insight:** Refunds are heavily concentrated around the $49.99 price point, suggesting that refunds are largely associated with items sold at that price.


-- year 2014 had most refunds , while 2012 had least

-- **Order Refund Rate**

-- Out of 32,313 total orders, 1,723 orders had at least one refund, giving an order refund rate of **5.33%**.

-- **Business insight:** Approximately 5 out of every 100 orders had a recorded refund. This provides an overall measure of refund frequency, but does not indicate the reasons for refunds.
-- **Monthly Sales vs. Refunds — Summary**

-- Sales increased substantially through 2012 and 2013, reaching 1,047 orders and $236,397.75 in December 2013. However, from March 2014 onward, the reported sales figures drop dramatically while refunds remain high. For example, September 2014 shows only $461.91 in sales but $11,773.63 in refunds.

-- **Business insight:** These figures cannot be interpreted as a reliable monthly comparison yet. The sharp sales decline may indicate incomplete or inconsistent order data, and refunds may relate to orders placed in earlier months. Validate the underlying data before drawing conclusions about profitability.
