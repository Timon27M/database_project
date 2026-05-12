WITH duplicate_car_by_class AS (
    SELECT c.class, COUNT(c.name) AS count
    FROM cars c
    GROUP BY c.class
    HAVING COUNT(c.name) > 1
),
    avg_all_cars_by_class AS (
        SELECT d.class, AVG(r.position) AS avg
        FROM duplicate_car_by_class d
        JOIN cars c ON c.class = d.class
        JOIN results r ON r.car = c.name
        GROUP BY d.class
        ),
    cars_avg_pos_by_duplicate_class AS (
        SELECT c.name, c.class, AVG(r.position) AS avg, COUNT(r.race) AS race_count
        FROM cars c
        JOIN results r ON r.car = c.name
        JOIN duplicate_car_by_class d ON d.class = c.class
        GROUP BY c.name, c.class
    )

SELECT c.name AS car_name,
       c.class AS car_class,
       CAST(ROUND(c.avg, 4) AS DECIMAL(10, 4)) AS average_position,
       c.race_count,
       cl.country AS car_country
FROM cars_avg_pos_by_duplicate_class c
JOIN avg_all_cars_by_class a ON a.class = c.class
JOIN Classes cl ON cl.class = a.class
WHERE c.avg < a.avg
ORDER BY c.class, c.avg;