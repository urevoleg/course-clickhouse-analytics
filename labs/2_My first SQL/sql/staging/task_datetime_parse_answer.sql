select transaction_id,
       parseDateTimeBestEffort(concat(arrayElement(splitByChar(',', transaction_date), 2), '-',
            multiIf(arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Jan', '01',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Feb', '02',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Mar', '03',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Apr', '04',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='May', '05',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Jun', '06',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Jul', '07',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Aug', '08',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Sep', '09',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Oct', '10',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Nov', '11',
                arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 1)='Dec', '12', '_'), '-',
            arrayElement(splitByChar(' ', arrayElement(splitByChar(',', transaction_date), 1)), 2),
            ' ',
            substringUTF8(transaction_time, 1, -4))) as transaction_dt
from transactions_log
order by transaction_dt desc;