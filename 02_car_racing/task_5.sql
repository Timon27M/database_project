WITH avg_cars AS (
    SELECT c.name AS car_name, c.class AS car_class, AVG(r.position) AS average_position, COUNT(r.car) AS race_count
    FROM cars c
    JOIN results r ON r.car = c.name
    GROUP BY c.name
    HAVING AVG(r.position) > 3
),
    total_count_by_class AS (
        SELECT c.class, COUNT(c.class) AS total_count
        FROM cars c
        JOIN results r ON c.name = r.car
        GROUP BY c.class
        HAVING c.class IN (
            SELECT a.car_class
            FROM avg_cars a
            )
    ),
    low_posititon_count_by_class AS (
        SELECT a.car_class, COUNT(a.car_class) AS low_position_count
        FROM avg_cars a
        GROUP BY a.car_class
    )

SELECT a.car_name, a.car_class, a.average_position, a.race_count, cl.country AS car_country, t.total_count, l.low_position_count
FROM avg_cars a
JOIN classes cl ON a.car_class = cl.class
JOIN total_count_by_class t ON t.class = a.car_class
JOIN low_posititon_count_by_class l ON l.car_class = a.car_class
ORDER BY t.total_count DESC;
