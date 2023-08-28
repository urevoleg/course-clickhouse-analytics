CREATE TABLE join_table1
(
    id UInt64,
    dt DateTime,
    val String
)
ENGINE = Log;

CREATE TABLE join_table2
(
    id UInt64,
    dt DateTime,
    val String
)
ENGINE = Log;

INSERT INTO join_table1 (*) VALUES (0, '2020-01-01', 'a'), (1, '2020-01-02', 'b'), (2, '2020-01-03', 'a'), (3, '2020-01-02', 'd'), (3, '2020-01-04', 'a'), (4, '2020-01-03', 'a');

INSERT INTO join_table2 (*) VALUES (1, '2020-01-02', 'e'), (1, '2020-01-02', 'f'), (2, '2020-01-03', 's'), (3, '2020-01-03', 'q'), (4, '2020-01-05', 'w'), (5, '2020-01-07', 'p');