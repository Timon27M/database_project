WITH car_avg_position AS (SELECT c.name, c.class, AVG(res.position * 1.0) AS avg_position, count(r.name) AS race_count
                          FROM cars c
                                   JOIN results res ON c.name = res.car
                                   JOIN races r ON res.race = r.name
                          GROUP BY c.name, c.class)

SELECT c.name AS car_name, c.class AS car_class, CAST(ROUND(c.avg_position, 4) AS DECIMAL(10, 4)) AS average_position, c.race_count, cl.country AS car_country
FROM car_avg_position c
JOIN classes cl ON cl.class = c.class
WHERE c.avg_position = (SELECT MIN(car_avg_position.avg_position) FROM car_avg_position)
ORDER BY c.name
LIMIT 1;