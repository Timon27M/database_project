SELECT v.maker, v.model, c.horsepower, c.engine_capacity, v.type
FROM vehicle v
         JOIN car c ON v.model = c.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000

UNION ALL

SELECT v.maker, v.model, m.horsepower, m.engine_capacity, v.type
FROM vehicle v
         JOIN motorcycle m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000

UNION ALL

SELECT v.maker, v.model, NULL as horsepower, NULL as engine_capacity, v.type
FROM vehicle v
         JOIN bicycle b ON v.model = b.model
WHERE b.gear_count > 18
  AND b.price < 4000

ORDER BY horsepower DESC NULLS LAST;

