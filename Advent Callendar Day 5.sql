/* Creating database*/
create database calendar_day5; 

/*Creating table and inserting values*/

CREATE TABLE beach_temperature_predictions (
    beach_name VARCHAR(255),
    country VARCHAR(255),
    expected_temperature_c INT,
    date DATE
);

INSERT INTO beach_temperature_predictions (beach_name, country, expected_temperature_c, date)
VALUES 
('Bondi Beach', 'Australia', 32, '2024-12-24'),
('Copacabana Beach', 'Brazil', 28, '2024-12-24'),
('Clifton Beach', 'South Africa', 31, '2024-12-25'),
('Brighton Beach', 'New Zealand', 25, '2024-12-25'),
('Waikiki Beach', 'USA', 29, '2024-12-26'),
('Cancún Beach', 'Mexico', 30, '2024-12-26'),
('Ipanema Beach', 'Brazil', 27, '2024-12-27'),
('Surfers Paradise', 'Australia', 31, '2024-12-28'),
('Playa del Carmen', 'Mexico', 29, '2024-12-28'),
('Santa Monica Beach', 'USA', 22, '2024-12-29'),
('Grace Bay', 'Turks and Caicos Islands', 27, '2024-12-30'),
('Seven Mile Beach', 'Cayman Islands', 28, '2024-12-30'),
('Eagle Beach', 'Aruba', 29, '2024-12-31'),
('Whitehaven Beach', 'Australia', 30, '2024-12-31'),
('Navagio Beach', 'Greece', 24, '2025-01-01'),
('Maya Bay', 'Thailand', 31, '2025-01-02'),
('Pink Sands Beach', 'Bahamas', 27, '2025-01-02'),
('Anse Source d\'Argent', 'Seychelles', 29, '2025-01-03'),
('Elafonissi Beach', 'Greece', 26, '2025-01-03'),
('Matira Beach', 'French Polynesia', 32, '2025-01-04'),
('Varadero Beach', 'Cuba', 28, '2025-01-04'),
('Zlatni Rat', 'Croatia', 23, '2025-01-05'),
('Camps Bay Beach', 'South Africa', 30, '2025-01-05'),
('Praia da Marinha', 'Portugal', 25, '2025-01-06'),
('Bora Bora Beach', 'French Polynesia', 31, '2025-01-06');


/* Which beaches have the highest forecast temperatures in each country? */
with RankedTemperatures as (
	select country, beach_name, expected_temperature_c,
	rank() over (partition by country order by expected_temperature_c desc) as rank_num
    from beach_temperature_predictions)
 select * 
 from RankedTemperatures 
 where rank_num =1;
 
 /*Show all beaches in order from highest to lowest temperature, giving each one a rank. to mozna ulepszyc*/
select 
beach_name, country, expected_temperature_c,
dense_rank () over (order by expected_temperature_c desc) as rank_num
from beach_temperature_predictions;	


/*Which beaches have the 2nd highest temperatures for each country? */
with RankedTemperatures as
(
select * 
, rank () over (partition by country order by expected_temperature_c desc) as rank_num
from beach_temperature_predictions)

select *
from RankedTemperatures
where rank_num =2;

/*Rank all beaches globally and display only those in the top 5 */
with RankTemperaturesGlobally as (
		select *,
		dense_rank () over (order by expected_temperature_c desc) as rank_num 
		from beach_temperature_predictions
)
select * 
from RankTemperaturesGlobally
where rank_num <=5;

/*Show beaches with temperatures higher than the average temperature in their respective country.*/
with country_average as(
		select 
		country, avg(expected_temperature_c) as average_temp
		from beach_temperature_predictions
		group by country),
	RankedBeaches as
		(
        select btp.beach_name, btp.country, btp.expected_temperature_c, average_temp,
        rank () over (partition by btp.country order by expected_temperature_c desc) as rank_num
        from beach_temperature_predictions btp
        inner join country_average ca
        on btp.country = ca.country
        ) 
   select 
   *
   from RankedBeaches
   where expected_temperature_c > average_temp;
   
   


        
