from itertools import tee

def lower_half(s, e):
    return (s, s + (e - s)/2)


def upper_half(s, e):
    return (s + (e -s)/2 + 1, e)


def partition(seq):
    row = (0, 127)
    col = (0, 7)

    for y in seq:
        if y == 'F':
            row = lower_half(*row)
        elif y == 'B':
            row = upper_half(*row)
        elif y == 'L':
            col = lower_half(*col)
        elif y == 'R':
            col = upper_half(*col)

    return row[0], col[0]


def seat(seq):
    row, col = partition(seq)
    return row * 8 + col


def test():
    assert lower_half(0, 127) == (0, 63)
    assert upper_half(0, 63) == (32, 63)
    assert lower_half(32, 63) == (32, 47)
    assert upper_half(32, 47) == (40, 47)
    assert upper_half(40, 47) == (44, 47)
    assert lower_half(44, 47) == (44, 45)
    assert lower_half(44, 45) == (44, 44)

    assert upper_half(0, 7) == (4, 7)
    assert lower_half(4, 7) == (4, 5)
    assert upper_half(4, 5) == (5, 5)

    assert partition('FBFBBFFRLR') == (44, 5)
    assert seat('FBFBBFFRLR') == 357


def pairwise(iterable):
    "s -> (s0,s1), (s1,s2), (s2, s3), ..."
    a, b = tee(iterable)
    next(b, None)
    return zip(a, b)


if __name__ == '__main__':
    test()

    with open('input', 'r') as input_file:
        lines = input_file.readlines()
        seats = [seat(l) for l in lines]

        print(max(seats))
        for s1, s2 in pairwise(sorted(seats)):
            if s2 - s1 != 1:
                print(s1, s2)

