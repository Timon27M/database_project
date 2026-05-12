WITH avg_pos_class AS (
    SELECT c.class, AVG(res.position)
    FROM cars c
    JOIN results res ON res.car = c.name
    GROUP BY c.class
),
    avg_pos_car AS (
        SELECT c.name, AVG(r.position)
        FROM cars c
        JOIN results r ON r.car = c.name
        GROUP BY c.name
    ),
    min_avg_pos_class AS (
        SELECT *
        FROM avg_pos_class cl
        where cl.avg = (SELECT MIN(a.avg) FROM avg_pos_class a)
    ),
    all_cars_by_min_avg_class AS (
        SELECT c.name AS car_name, c.class AS car_class, COUNT(r.race) AS race_count
        FROM cars c
        JOIN results r ON c.name = r.car
        JOIN min_avg_pos_class cl ON cl.class = c.class
        GROUP BY c.name, c.class
        ),
    count_all_cars_race_by_min_avg_class AS (
        SELECT cl.car_class, SUM(cl.race_count)
        FROM all_cars_by_min_avg_class cl
        GROUP BY cl.car_class
    )

SELECT car.car_name, car.car_class, CAST(ROUND(a.avg, 4) AS DECIMAL(10, 4)) AS average_position, car.race_count, cls.country AS car_country, cl.sum AS total_races
FROM all_cars_by_min_avg_class car
JOIN avg_pos_car a ON a.name = car.car_name
JOIN count_all_cars_race_by_min_avg_class cl ON cl.car_class = car.car_class
JOIN classes cls ON cls.class = car.car_class;
