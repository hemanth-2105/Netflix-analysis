create table netflix_data(
	show_id varchar(7),
	type varchar(12),
	title varchar(150),
	director varchar(220),
	country varchar(25),
	date_added text,
	release_year int,
	rating varchar(16),
	duration varchar (12),
	listed_in varchar(82)
)

select * from netflix_data 

--1	What is the total number of 'Movies' and 'TV Shows' on Netflix?

select type,count(*)as total_count 
from netflix_data
group by type;

--2. Which country has produced the most content (Movies + TV Shows) on Netflix? List the top 5 countries.

select country, 
count(*) as total_movies from netflix_data
group by country 
order by total_movies desc
limit 5; 

--3.Retrieve a list of all movies and TV shows released in the year 2020.

select title, type
from netflix_data
where release_year = 2020

--4.What are the titles of all movies directed by 'Kirsten Johnson'?

select title 
from netflix_data
where director = 'Kirsten Johnson'

--5.Which content rating is the most common on Netflix? (Count of titles by rating).

select rating, count(*) as total_rating 
from netflix_data
group by rating
order by  total_rating  desc

--6.Find the list of all 'TV Shows' that have 5 or more seasons.

select title,duration
from netflix_data
where type = 'TV Show' AND duration > '5 seasons' 
limit 15

--7.List all the movies produced in 'India' that belong to the 'Comedies' category.

select title,listed_in
from netflix_data
where type = 'Movie' AND country ='India' AND listed_in like '%Comedies%'


--8.How many new shows/movies were released each year? Sort the results in
--descending order of the release year.

select release_year,count(*) as total_releases
from netflix_data
group by release_year
order by release_year desc

--9.Who are the top 5 directors with the highest number of directed movies
--(excluding 'Not Given')?

select director,count(*) as highest_movies
from netflix_data
where type='Movie' AND director != ''
group by director
order by highest_movies desc
limit 5

--10.In which year did Netflix add the highest amount of content to its platform?

select RIGHT(date_added,4) as year_added, count(*) as total_content
from netflix_data
group by year_added
order by total_content desc
limit 1

--11. Which are the 5 oldest movies released in India on Netflix?

select title, release_year
from netflix_data
where country ='India'
order by release_year 
limit 5

--12. . Find the titles of all movies listed as 'Documentaries' that were released
--after the year 2015

select title,release_year,listed_in
from netflix_data
where listed_in like '%Documentaries%' AND release_year >2015
order by release_year

--13. Which movie has the longest duration in minutes on Netflix?

select title,
SPLIT_PART(duration,' ',1):: int as duration_minutes
from netflix_data
where type='Movie'
order by duration_minutes desc
limit 1;

--14. What is the most recently released movie for each country?

with ranked_movies as(
	select title,country,release_year,
	ROW_NUMBER() over (partition by country order by release_year desc) as rnk
	from netflix_data
	where type='Movie')
select country,title as latest_movie,release_year
from ranked_movies
where rnk = 1;

--15.Identify the release years in which more than 50 movies from India were
--released.

select release_year,count(*) as total_moives
from netflix_data
where type='Movie' AND country ='India' 
group by release_year 
having count(*) > 50
order by release_year desc
