import string

groups = {}

acc = 0

with open('input', 'r') as f:
    input_groups = f.read().split('\n\n')

    for i, group in enumerate(input_groups):
        persons = group.split('\n')

        groups[i] = {j: set([l for l in p if l]) for j,p in enumerate(persons) if p}


    for group_id, people in groups.items():
        group_size = len(people)
        print(people)
        group_set = set(string.ascii_lowercase)

        for answers in people.values():
            group_set = group_set & answers

        acc += len(group_set)

print(acc)




