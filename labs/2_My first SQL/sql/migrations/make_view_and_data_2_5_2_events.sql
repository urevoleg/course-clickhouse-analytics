CREATE VIEW events as
SELECT tupleElement(array, 1) AS step, /* Шаг */
       tupleElement(array, 2) AS UID /* Идентификатор юзера */
FROM
  (SELECT arrayJoin([('step a', 1),('step c', 1), ('step b', 1), ('step d', 1),
                     ('step a', 2),('step e', 2), ('step b', 2), ('step w', 2),
                     ('step a', 3),('step f', 3), ('step b', 3), ('step g', 3),
                     ('step a', 4),('step b', 4), ('step w', 4), ('step e', 4),
                     ('step a', 5),('step c', 5), ('step d', 5), ('step e', 5),
                     ('step b', 6), ('step b', 6), ('step c', 6),
                     ('step d', 7), ('step e', 7), ('step c', 7),
                     ('step g', 8), ('step a', 8), ('step b', 8),
                     ('step d', 9), ('step b', 9), ('step c', 9)]) AS array);