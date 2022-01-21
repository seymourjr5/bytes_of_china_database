CREATE TABLE restaurant(
    id integer PRIMARY KEY,
    name varchar(20),
    description varchar(200),
    rating decimal,
    telephone char(10),
    hours varchar(200)
);

CREATE TABLE address(
    id integer PRIMARY KEY,
    street_number varchar(20),
    street_name varchar(30),
    city_name varchar(20),
    state varchar(15),
    map_link varchar(100),
    restaurant_id integer REFERENCES restaurant(id) UNIQUE
);

SELECT constraint_name, table_name, column_name
FROM 
  information_schema.key_column_usage;

CREATE TABLE category(
  id char(2) PRIMARY KEY,
  name varchar(20),
  description varchar(200)
);

CREATE TABLE dish(
  id integer PRIMARY KEY,
  name varchar(50),
  description varchar(200),
  hot_and_spicy boolean
);


SELECT constraint_name, table_name, column_name
FROM 
  information_schema.key_column_usage
WHERE table_name = 'dish';

CREATE TABLE review(
  id integer PRIMARY KEY,
  rating decimal,
  description varchar(100),
  date date,
  restaurant_id integer REFERENCES restaurant(id)
);

SELECT constraint_name, table_name, column_name
FROM 
  information_schema.key_column_usage
WHERE table_name = 'review';

--CROSS-reference table between dish and category
CREATE TABLE categories_dishes(
  category_id char(2) REFERENCES category(id),
  dish_id integer REFERENCES dish(id),
  price money,
  PRIMARY KEY(category_id, dish_id) 
);


SELECT constraint_name, table_name, column_name
FROM 
  information_schema.key_column_usage
WHERE table_name = 'categories_dishes';

/* 
 *--------------------------------------------
 Insert values for restaurant
 *--------------------------------------------
 */
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

/* 
 *--------------------------------------------
 Insert values for address
 *--------------------------------------------
 */
INSERT INTO address VALUES (
  1,
  '2020',
  'Busy Street',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);

/* 
 *--------------------------------------------
 Insert values for review
 *--------------------------------------------
 */
INSERT INTO review VALUES (
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020',
  1
);

INSERT INTO review VALUES (
  2,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020',
  1
);

INSERT INTO review VALUES (
  3,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020',
  1
);

/* 
 *--------------------------------------------
 Insert values for category
 *--------------------------------------------
 */
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

/* 
 *--------------------------------------------
 Insert values for dish
 *--------------------------------------------
 */
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

/*
 *--------------------------------------------
 Insert valus for cross-reference table, categories_dishes
 *--------------------------------------------
 */
INSERT INTO categories_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'C',
  3,
  6.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO categories_dishes VALUES (
  'HS',
  8,
  17.95
);

--  Type in a query that displays the restaurant name, its address (street number and name) and telephone number
SELECT restaurant.name, address.street_number, address.street_name, restaurant.telephone
FROM restaurant, address
WHERE restaurant.id = address.restaurant_id; 
--Can also be done without the last line:
--WHERE restaurant.id = address.restaurant_id; 


-- write a query to get the best rating the restaurant ever received. Display the rating as best_rating.
SELECT MAX(review.rating) as best_rating
FROM review, restaurant
WHERE review.restaurant_id = restaurant.id;

--  Write a query to display a dish name, its price and category sorted by the dish name
SELECT 
      dish.name AS dish_name,
      categories_dishes.price AS price,
      category.name AS category
FROM dish, categories_dishes, category
WHERE dish.id = categories_dishes.dish_id
  AND category.id = categories_dishes.category_id
ORDER BY 1;


-- Instead of sorting the results by dish name, type in a new query to display the results as follows, sorted by category name.
SELECT 
      category.name AS category,
      dish.name AS dish_name,
      categories_dishes.price AS price
FROM dish, categories_dishes, category
WHERE dish.id = categories_dishes.dish_id
  AND category.id = categories_dishes.category_id
ORDER BY 1;


-- type a query in script.sql that displays all the spicy dishes, their prices and category
SELECT 
      dish.name AS spicy_dish_name, 
      category.name AS category,
      categories_dishes.price AS price
FROM dish, category, categories_dishes
WHERE dish.id = categories_dishes.dish_id
  AND category.id = categories_dishes.category_id
  AND dish.hot_and_spicy = true;


--  Write a query that displays the dish_id and COUNT(dish_id) as dish_count from the categories_dishes table. When we are displaying dish_id along with an aggregate function such as COUNT(), we have to also add a GROUP BY clause which includes dish_id
SELECT 
      categories_dishes.dish_id,
      COUNT(categories_dishes.dish_id) AS dish_count
FROM categories_dishes
GROUP BY 1
ORDER BY 1 ASC;

-- adjust the previous query to display only the dish(es) from the categories_dishes table which appears more than once. We can use the aggregate function, COUNT() as a condition. But instead of using the WHERE clause, we use the HAVING clause together with COUNT().
SELECT 
      categories_dishes.dish_id,
      COUNT(categories_dishes.dish_id) AS dish_count
FROM categories_dishes
GROUP BY 1
HAVING COUNT(categories_dishes.dish_id) > 1
ORDER BY 1 ASC;

-- The previous two queries only give us a dish_id which is not very informative. We should write a better query which tells us exactly the name(s) of the dish that appears more than once in the categories_dishes table. Write a query that incorporates multiple tables that display the dish name as dish_name and dish count as dish_count.
SELECT 
      dish.name AS dish_name,
      COUNT(categories_dishes.dish_id) AS dish_count
FROM categories_dishes, dish
GROUP BY dish.id, dish.name, categories_dishes.dish_id
HAVING COUNT(categories_dishes.dish_id) > 1
      AND dish.id = categories_dishes.dish_id
ORDER BY 1 ;

--  Write a query that displays the best rating as best_rating and the description too. In order to do this correctly, we need to have a nested query or subquery. We would place this query in the WHERE clause.
-- SELECT restaurant.rating, restaurant.description
-- FROM restaurant, review
-- WHERE restaurant.rating =(SELECT MAX(review.rating) AS best_rating
-- FROM review, restaurant
-- WHERE review.restaurant_id = restaurant.id);


-- SELECT MAX(review.rating) as best_rating
-- FROM review, restaurant
-- WHERE review.restaurant_id = restaurant.id;

SELECT restaurant.rating, restaurant.description
FROM restaurant
Where restaurant.rating =(SELECT MAX(restaurant.rating) AS best_rating
FROM restaurant);