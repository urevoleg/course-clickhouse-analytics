

s = "1 3 5 7 9 11 13 15 17 19,17"
# Считывание данных
arr, target = list(map(str, s.split(',')))

# Разбиение
arr = list(map(int, arr.split())) # Массив
target = int(target) # Таргет

def binary_search(arr, target):
    low = 0
    high = len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            # здесь возвращается сам элемент массива
            return arr[mid]
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    # замена -1 на arr[low] - тк здесь low содержит индекс элемента больше чем target
    return arr[low]


if __name__ == "__main__":
    print(binary_search(arr, target))