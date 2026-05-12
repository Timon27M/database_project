
WITH car_avg_position AS (SELECT c.name, c.class, AVG(res.position * 1.0) AS avg_position, count(r.name) AS race_count
                          FROM cars c
                                   JOIN results res ON c.name = res.car
                                   JOIN races r ON res.race = r.name
                          GROUP BY c.name, c.class),

     min_avg_by_class AS (SELECT p.class, min(p.avg_position) as min_avg_position
                          FROM car_avg_position p
                          GROUP BY p.class)

SELECT c.name AS car_name, c.class AS car_class, CAST(ROUND(c.avg_position, 4) AS DECIMAL(10, 4)) AS average_position, c.race_count
FROM car_avg_position c
JOIN min_avg_by_class m ON m.class = c.class
WHERE m.min_avg_position = c.avg_position
ORDER BY m.min_avg_position