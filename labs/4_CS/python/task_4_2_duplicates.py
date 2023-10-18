

s = list(map(int, "1 2 3 4 4 5 6 6 7".split(' ')))


def find_duplicates(numbers):
    hash_table = {}
    hash_dupl = {}
    for number in numbers:
        if number in hash_table:
            hash_dupl[number] = 1
        else:
            hash_table[number] = 1
    return list(hash_dupl.keys())


if __name__ == "__main__":
    print(find_duplicates(s))