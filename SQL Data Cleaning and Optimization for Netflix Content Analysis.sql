-- Create a table to store Netflix data with relevant columns
CREATE TABLE netflix (
	show_id VARCHAR(5), -- Unique identifier for each show
	type VARCHAR(10), -- Type of content (Movie or TV Show)
	title TEXT, -- Title of the show or movie
	director VARCHAR(255), -- Name of the director
	country VARCHAR(50), -- Country of origin
	date_added date, -- Date when the content was added to Netflix
	release_year INT, -- Year of release
	rating VARCHAR(10), -- Content rating (e.g., PG, R, etc.)
	duration VARCHAR(10), -- Duration of the content (e.g., '90 min' for movies, '1 Season' for shows)
	listed_in VARCHAR(255) -- Genres/categories of the content
);

-- Copy data from CSV file into the Netflix table
COPY netflix
FROM 'C:\Users\Public\netflix.csv'
WITH (FORMAT CSV, HEADER, NULL "null");

-- Count the number of records in the Netflix table
SELECT COUNT(*)
FROM netflix;

-- Create a backup table by copying all records from the original table
CREATE TABLE netflix_backup AS SELECT *
FROM netflix;

-- Add a new column to store a duplicate of the country column
ALTER TABLE netflix ADD COLUMN country_duplicate VARCHAR(225);

-- Copy values from the country column into the new country_duplicate column
UPDATE netflix
SET country_duplicate = country;

-- Replace 'Not Given' values in the director column with NULL
UPDATE netflix
SET director = NULL
WHERE director = 'Not Given';

-- Delete records where the country is marked as 'Not Given'
DELETE FROM netflix
WHERE country ='Not Given';

-- Select records where the country is still 'Not Given' to verify deletion
SELECT country FROM netflix WHERE country='Not Given';

-- Replace 'UR' with 'NR' in the rating column for consistency
UPDATE netflix
SET rating= REPLACE(rating,'UR','NR');

-- Standardize country names by replacing 'West Germany' with 'Germany'
UPDATE netflix
SET country= REPLACE(country,'West Germany','Germany');

-- Convert all titles to lowercase for uniformity
UPDATE netflix
SET title = LOWER(title);

-- Identify duplicate titles in the dataset
SELECT title, COUNT(title) AS Duplicate
FROM netflix
GROUP BY title
HAVING COUNT(title) > 1;

-- Remove duplicate entries by keeping only one record per title
DELETE FROM
    netflix a
        USING netflix b
WHERE
    a.show_id < b.show_id
	AND a.title = b.title;
