CREATE TABLE transactions_log (
    transaction_id String,
    transaction_date String,
    transaction_time String,
    tax_type String,
    transaction_type String,
    refund_type String,
    product_name String,
    product_id String
) ENGINE = Log;

create view transactions_log_view as select * from transactions_log order by transaction_id limit 50;