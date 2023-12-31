# Chapter 4 - Computer Science (base)

![real CS.jpg](..%2F..%2Fimg%2Freal%20CS.jpg)


**Алгоритм** - это последовательность операций или шагов, которые нужно выполнить для решения определенной задачи. 
Алгоритмы часто используются в компьютерных науках и информационных технологиях для решения различных задач, таких как сортировка данных, поиск информации, анализ данных и т.д.

**Структура данных** - это способ хранения и организации данных в компьютере, чтобы их было удобно использовать и обрабатывать.
Структуры данных различаются по способу хранения и доступа к данным, а также по способу реализации операций над ними.

**Сложность алгоритмов** - это количество времени и/или ресурсов, необходимых для выполнения алгоритма. 
Она обычно измеряется в количестве операций, необходимых для его выполнения. 
Чем больше операций требуется, тем более сложным считается алгоритм.

-------------------------------------

## Binary search

![binary_search.png](..%2F..%2Fimg%2Fbinary_search.png)

### Tasks

Предлагаю вам такую задачу, воспользуйтесь предыдущим алгоритмом (см курс) и 
дополните его так чтобы функция возвращала элемент ближайший по значению к заданному (в большую сторону).

Например, для `1 3 5 7 9 11 13 15 17 19,8` результат 9

Решение [task_4_1_bin_search.py](python%2Ftask_4_1_bin_search.py)

-------------------------

## Hash table

![hash-table.png](..%2F..%2Fimg%2Fhash-table.png)

**Хеш-таблица** - это структура данных, которая позволяет быстро и эффективно выполнять операции добавления, удаления и поиска элементов. 
Она основана на использовании функции хеширования, которая принимает на вход элемент и вычисляет для него 
уникальный хеш-код - числовое значение, которое может быть использовано для индексации элемента в таблице.

### Tasks 

1. Напишите функцию find_duplicates, которая принимает список целых чисел и 
возвращает список всех повторяющихся элементов в исходном списке, то есть тех элементов которых больше 1

Решение [task_4_2_duplicates.py](python%2Ftask_4_2_duplicates.py)

2. Предлагаю вам реализовать метод del который будет удалять элементы из нашей хеш-таблицы.

Решение [task_4_3_hash.py](python%2Ftask_4_3_hash.py)

-------------------------------------
## Алгоритмы JOIN

![nested_loop.png](..%2F..%2Fimg%2Fnested_loop.png)

Есть логические JOIN:
1. Inner
2. Left\Right\Full Outer
3. Cross

А есть физические JOIN:

**1. Nested Loop**

(вложенный цикл) - это простой алгоритм, который соединяет две таблицы путем последовательного сканирования одной таблицы и 
поиска соответствующих строк в другой таблице. Этот алгоритм неэффективен для больших таблиц, поскольку его сложность составляет
**O(n∗m)**, где n и m - количество строк в каждой таблице.

**2. Merge JOIN**

(объединение с сортировкой) - это алгоритм, который сначала сортирует каждую таблицу по соединяемому полю, 
а затем объединяет их вместе, сканируя их последовательно и находя соответствующие строки. 
Этот алгоритм требует дополнительной памяти для сортировки таблиц, но его сложность составляет
**O(nlog(n)+mlog(m))**, что делает его более эффективным для больших таблиц.

**3. Hash JOIN**

 (хэш-соединение) - это алгоритм, который создает хэш-таблицу для одной таблицы, используя соединяемое поле в качестве ключа, 
 а затем сканирует другую таблицу, ищет соответствующие значения в хэш-таблице и объединяет строки. 
 Этот алгоритм требует большого объема памяти для хранения хэш-таблицы, но его сложность составляет
**O(n+m)**, что делает его очень эффективным для больших таблиц. **Данный алгоритм работает по умолчанию в ClickHouse!**


