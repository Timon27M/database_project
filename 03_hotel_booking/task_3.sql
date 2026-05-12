WITH hotel_category AS (
    SELECT
        h.ID_hotel,
        h.name,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            WHEN AVG(r.price) > 300 THEN 'Дорогой'
            ELSE 'Не определено'
            END AS category
    FROM hotel h
    JOIN room r ON h.ID_hotel = r.ID_hotel
    GROUP BY h.ID_hotel
),
    customer_category AS (
        SELECT
            c.id_customer,
            c.name,
            CASE
                WHEN COUNT(CASE WHEN h.category = 'Дорогой' THEN 1 END) > 0 THEN 'Дорогой'
                WHEN COUNT(CASE WHEN h.category = 'Средний' THEN 1 END) > 0 THEN 'Средний'
                WHEN COUNT(CASE WHEN h.category = 'Дешевый' THEN 1 END) > 0 THEN 'Дешевый'
                ELSE 'Не определено'
                END AS category,
            STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotel_list
        FROM customer c
        JOIN booking b ON c.id_customer = b.id_customer
        JOIN room r ON b.id_room = r.id_room
        JOIN hotel_category h ON h.id_hotel = r.id_hotel
        GROUP BY c.id_customer
    )

SELECT *
FROM customer_category c
ORDER BY
    CASE
        WHEN category = 'Дешевый' THEN 1
        WHEN category = 'Средний' THEN 2
        WHEN category = 'Дорогой' THEN 3
        WHEN category = 'Не определено' THEN 4
        END,
    c.id_customer