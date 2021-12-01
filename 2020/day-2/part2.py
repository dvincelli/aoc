def verify_password(line: str) -> bool:
    policy, password = [item.strip() for item in line.split(':')]
    bounds = policy[:-2]
    letter = policy[-1]
    low, high = [int(item) for item in bounds.split('-')]
    if password[low-1] == letter and password[high-1] != letter:
        return True
    elif password[low-1] != letter and password[high-1] == letter:
        return True
    return False
    #letters = [password[low-1], password[high-1]]
    #if letters.count(letter) == 1:
    #    return True
    #return False

def count_good_passwords(data: list) -> int:
    good_passwords = 0
    for line in data:
        if verify_password(line):
            good_passwords += 1
    print(f'Number of good password: {good_passwords}')
    return good_passwords

if __name__ == "__main__":
    data = []
    with open('input') as f:
        for line in f:
            data.append(line.strip())
    count_good_passwords(data)
