WITH customers_have_two_booking AS (
    SELECT b.id_customer, COUNT(DISTINCT h.id_hotel) AS total_hotel, COUNT(DISTINCT b.id_booking) AS total_booking, STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotel_list
    FROM booking b
    JOIN room r ON b.id_room = r.id_room
    JOIN hotel h ON h.id_hotel = r.id_hotel
    GROUP BY b.id_customer
    HAVING  COUNT(DISTINCT  h.id_hotel) > 1 AND COUNT(DISTINCT b.id_booking) > 2
)


SELECT c.name, c.email, c.phone, h.total_booking, h.hotel_list, AVG(b.check_out_date - b.check_in_date) AS days_diff
FROM customer c
         JOIN customers_have_two_booking h ON c.id_customer = h.id_customer
         JOIN booking b ON h.id_customer = b.id_customer
group by c.phone, c.email, c.name,  h.total_booking, h.hotel_list
ORDER BY h.total_booking DESC