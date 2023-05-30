-- 1. Who is the senior most employee based on job title?

-- Sorting can help us find the senior most employee
select* from employee
order by levels desc
limit 1


-- 2. Which countries have the most Invoices?

SELECT billing_country, COUNT(*) as num_invoices
FROM invoice
GROUP BY billing_country
ORDER BY num_invoices DESC;


--3. What are top 3 values of total invoice?
select* from invoice

-- To get ID column & Total column
select customer_id,total from invoice
order by total desc
limit 3


/*
4. Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals
*/
select * from invoice

select billing_city, sum(total) as invoice_total
from invoice
group by billing_city
order by invoice_total desc

/* 
5. Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money
*/

select* from customer
select * from invoice

select c.customer_id,c.first_name, c.last_name, sum(i.total) as total
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.customer_id
order by total desc
limit 1


-- Set 2

/*
1. Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A
*/
select* from customer

select* from genre

select distinct c.email,c.first_name,c.last_name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
order by email;

/*
This code selects the distinct names of customers who have purchased at least one track with a genre name of "Rock". The DISTINCT keyword ensures that each customer is only listed once in the results.

In summary, the SQL code retrieves the names of all customers who have purchased at least one track with a genre name of "Rock".
*/


/*
2. Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands
*/

select a.artist_id, a.name, count(a.artist_id) as total_track_count
from artist a
join album al on a.artist_id = al.artist_id
join track tk on al.album_id = tk.album_id
join genre g on tk.genre_id = g.genre_id
where g.name= 'Rock'
group by a.artist_id
order by total_track_count desc
limit 10


/*
3. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first
*/

select name, milliseconds
from track
where milliseconds> (select avg(milliseconds) from track)
order by milliseconds desc;


-- Set 3

/* 
1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent
*/

-- Below code will group by customer ID. But question is asking only to return customer name , artist & money spent
SELECT c.customer_id, c.first_name || ' ' || c.last_name AS customer_name,
a.name AS artist_name,
SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY c.customer_id,customer_name, a.name
ORDER BY total_spent desc
limit 20

-- Below code will group by customer name only.
SELECT c.first_name || ' ' || c.last_name AS customer_name,
a.name AS artist_name,
SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN album al ON t.album_id = al.album_id
JOIN artist a ON al.artist_id = a.artist_id
GROUP BY 1,2
ORDER BY total_spent desc
limit 20


/*
2. We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres
*/

WITH popular_genre as
(
SELECT billing_country,genre.name,genre.genre_id,SUM(quantity) AS purchase_quantity,
row_number() over(partition by invoice.billing_country order by count(invoice_line.quantity)desc) as rowno
FROM invoice
INNER JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
INNER JOIN track ON invoice_line.track_id = track.track_id
INNER JOIN genre ON track.genre_id = genre.genre_id
GROUP BY billing_country, genre.name, genre.genre_id
ORDER BY billing_country, purchase_quantity DESC
)

select * from popular_genre WHERE rowno=1

/*
3. Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount
*/

with top_customer as
(
SELECT c.country, c.first_name, c.last_name, SUM(i.total) AS total_spending,
row_number() over(partition by c.country order by sum(i.total)desc) as rowno
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
WHERE i.billing_country = c.country
GROUP BY c.country, c.first_name, c.last_name
ORDER BY c.country asc
)
select * from top_customer WHERE rowno=1























