WITH customers_have_two_booking AS (
    SELECT b.id_customer, COUNT(DISTINCT h.id_hotel) AS total_hotel, COUNT(DISTINCT b.id_booking) AS total_booking, SUM(r.price) AS total_price
    FROM booking b
             JOIN room r ON b.id_room = r.id_room
             JOIN hotel h ON h.id_hotel = r.id_hotel
    GROUP BY b.id_customer
),
    filtered_customers_by_count AS (
        SELECT c.id_customer, c.name, h.total_booking, h.total_hotel, h.total_price
        FROM customer c
                 JOIN customers_have_two_booking h ON c.id_customer = h.id_customer
        WHERE h.total_hotel > 1 AND h.total_booking > 2
        group by h.total_booking, c.name, c.id_customer, h.total_hotel, h.total_price
    ),
    filtered_customers_by_price AS (
        SELECT h.id_customer, c.name, h.total_price, h.total_booking
        FROM customers_have_two_booking h
        JOIN customer c ON c.id_customer = h.id_customer
        WHERE h.total_price > 500
    )

SELECT p.id_customer, p.name, c.total_booking, c.total_price AS total_spent, c.total_hotel AS unique_hotels
FROM filtered_customers_by_count c
JOIN filtered_customers_by_price p ON p.id_customer = c.id_customer
ORDER BY c.total_price
