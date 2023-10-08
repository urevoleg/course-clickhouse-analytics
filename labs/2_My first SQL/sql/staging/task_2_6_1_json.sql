/*
 Парсинг (достаньте поля JSON документа следующим образом):
- `value` - как Float
- `is_active` - как Bool
- `key` - как String и преобразовать в Int64
- `list` - как Array

Дополнительные вычисления (проведите небольшие вычисления для получения ответа):
- По `value` посчитать сумму
- По `list` сначала просуммировать по каждому массиву,
Нужно будет поменять тип лежащих данных на Int64 (вам может помочь arrayMap)
Возьмите среднее avg по получившейся колонке
- По `key` преобразовать в Int64 затем взять среднее avg
 */

select sum(value),
       avg(arraySum(arrayMap(x -> toInt64(x), list))),
       avg(key)
from (select JSONExtractFloat(json, 'value') as value,
        JSONExtractBool(json, 'is_active') as is_active,
        toInt64(JSONExtractString(json, 'key')) as key,
        JSONExtractArrayRaw(json, 'list') as list
 from table2) as sq;