

if __name__ == '__main__':
    # Считывание данных
    left, right = list(map(str, "a b c d,b:1 c:2 d:3".split(',')))

    # Разбиение
    left = list(map(str, left.split())) # Левая таблица, тут лежит массив строк
    right = dict(map(lambda x: x.split(':'), right.split())) # Правая таблица, тут лежит словарь, хеш таблица

    # print(left, right)

    ljoin = {}
    for l in left:
        ljoin[l] = right.get(l, 'default')

    for k, v in ljoin.items():
        print(f"{k}:{v}")
