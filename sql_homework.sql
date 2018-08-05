
USE sakila;

-- 1a. Display the first and last names of all actors from the table `actor`.
SELECT * FROM actor;

SELECT first_name, last_name
FROM actor;


-- 1b. Display the first and last name of each actor in a single column in upper case letters.
-- Name the column `Actor Name`.
SELECT CONCAT(first_name, ' ', last_name) 
AS 'Actor Name' 
FROM actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

-- 2b. Find all actors whose last name contain the letters `GEN`
SELECT *
FROM actor
WHERE last_name LIKE '%G%'
AND last_name LIKE '%E%'
AND last_name LIKE '%N%';

-- 2c. Find all actors whose last names contain the letters `LI`. 
-- This time, order the rows by last name and first name, in that order
SELECT *
FROM actor
WHERE last_name LIKE '%L%'
AND last_name LIKE '%I%'
ORDER BY (last_name);

-- 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: 
-- Afghanistan, Bangladesh, and China
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a `middle_name` column to the table `actor`. 
-- Position it between `first_name` and `last_name`. Hint: you will need to specify the data type
ALTER TABLE actor
ADD middle_name VARCHAR(50)
AFTER first_name;

-- 3b. You realize that some of these actors have tremendously long last names.
-- Change the data type of the `middle_name` column to `blobs`.
ALTER TABLE actor
MODIFY COLUMN middle_name blob;

-- 3c. Now delete the `middle_name` column.
ALTER TABLE actor
DROP middle_name;

SELECT * FROM actor;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(last_name) AS 'Count'
FROM actor
GROUP BY(last_name);

SELECT * FROM actor;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
SELECT last_name, COUNT(*) Count
FROM actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as 
-- `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's yoga teacher. 
-- Write a query to fix the record.
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'GROUCHO'
AND last_name = 'WILLIAMS';


UPDATE actor
SET 
    first_name = 'HARPO',
    last_name = 'WILLIAMS'
WHERE actor_id = 172;


SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'HARPO'
AND last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
-- It turns out that `GROUCHO` was the correct name after all! In a single query, 
-- if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. 
-- Otherwise, change the first name to `MUCHO GROUCHO`, as that is exactly what the actor 
-- will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO 
-- `MUCHO GROUCHO`, HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor
SET 
    first_name = 'GROUCHO'
WHERE actor_id = 172;

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 172;

UPDATE actor
SET 
    first_name = 'MUCHO GROUCHO'
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the `address` table. 
-- Which query would you use to re-create it?
CREATE SCHEMA address;


-- 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. 
-- Use the tables `staff` and `address`
SELECT staff.first_name, staff.last_name, address.address
FROM staff
JOIN address ON address.address_id=staff.address_id;


--  6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005.
--  Use tables `staff` and `payment`.
SELECT p.staff_id, s.first_name, s.last_name, SUM(p.amount) AS 'Total Amount Rung'
FROM payment p, staff s
WHERE p.payment_date BETWEEN '2005-08-01 00:00:01' AND '2005-08-31 11:59:59' AND p.staff_id=s.staff_id
GROUP BY (p.staff_id);


-- 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. 
-- Use inner join.
SELECT f.title, COUNT(*) as 'Number of Actors'
FROM film f
INNER JOIN film_actor fa ON f.film_id = fa.film_id
GROUP BY (f.title);

-- 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?
SELECT f.film_id, COUNT(i.inventory_id) AS 'Copies'
FROM film f, inventory i
WHERE f.title = 'Hunchback Impossible' AND f.film_id = i.film_id
GROUP BY (f.film_id);


-- 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid 
-- by each customer. List the customers alphabetically by last name
SELECT c.last_name, SUM(p.amount) AS 'Total Paid'
FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY (c.last_name);


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

SELECT * FROM language;
SELECT * FROM film;

SELECT f.title, l.name FROM film f, language l 
WHERE f.language_id = l.language_id
AND f.title IN (SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%');


-- 7b. Use subqueries to display all actors who appear in the film `Alone Trip`
SELECT a.first_name, a.last_name, f.title FROM actor a, film_actor fa, film f
WHERE a.actor_id = fa.actor_id AND fa.film_id = f.film_id AND f.title IN 
(SELECT f.title FROM film f, film_actor fa WHERE f.film_id = fa.film_id  HAVING f.title = 'Alone Trip');


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information.
SELECT a.first_name, a.last_name, a.email, b.country
FROM customer a, country b, city c, address d
WHERE a.address_id = d.address_id AND d.city_id = c.city_id AND c.country_id = b.country_id
HAVING b.country = 'Canada';


-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT c.title, a.name
FROM category a, film_category b, film c
WHERE a.category_id = b.category_id AND b.film_id = c.film_id
HAVING a.name = 'Family';


-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS 'Rent Count'
FROM rental r, inventory i, film f
WHERE r.inventory_id = i.inventory_id AND i.film_id = f.film_id
GROUP BY (f.title) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT a.store_id, SUM(c.amount) AS 'Profit ($)'
FROM store a, staff b, payment c
WHERE a.store_id = b.store_id AND b.staff_id = c.staff_id
GROUP BY (a.store_id);


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT a.store_id, c.city, d.country
FROM store a, address b, city c, country d 
WHERE a.address_id = b.address_id AND b.city_id = c.city_id AND c.country_id = d.country_id;



-- 7h. List the top five genres in gross revenue in descending order. 
-- (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) AS 'Gross Revenue'
FROM category c, film_category fc, inventory i, rental r, payment p
WHERE c.category_id= fc.category_id AND fc.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
AND r.staff_id = p.staff_id AND r.customer_id = p.customer_id
GROUP BY (c.name) ORDER BY SUM(p.amount) DESC LIMIT 5;



-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
-- Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. 
CREATE VIEW top_five_genres AS 
SELECT c.name, SUM(p.amount) AS 'Gross Revenue'
FROM category c, film_category fc, inventory i, rental r, payment p
WHERE c.category_id= fc.category_id AND fc.film_id = i.film_id AND i.inventory_id = r.inventory_id AND r.rental_id = p.rental_id
AND r.staff_id = p.staff_id AND r.customer_id = p.customer_id
GROUP BY (c.name) ORDER BY SUM(p.amount) DESC LIMIT 5;


-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;


-- 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_genres;


