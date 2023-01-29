# -*- coding: utf-8 -*-
"""Created on Wed Jul 20 15:50:04 2022@author: xiaom"""

# Rewrite the for loop to use enumerate
indexed_names = []
for i,name in enumerate(names):
    index_name = (i,name)
    indexed_names.append(index_name) 
print(indexed_names)

# Rewrite the above for loop using list comprehension
indexed_names_comp = [(i,name) for i,name in enumerate(names)]
print(indexed_names_comp)

# Unpack an enumerate object with a starting index of one
indexed_names_unpack = [*enumerate(names, 1)]
print(indexed_names_unpack)

################################
names = ['Jerry', 'Kramer', 'Elaine', 'George', 'Newman']
# Use map to apply str.upper to each element in names
names_map  = map(str.upper, names)

# Print the type of the names_map
print(type(names_map))

# Unpack names_map into a list
names_uppercase = [*names_map]

# Print the list created above
print(____)

##############################
'''                 ZOLOTO                  '''
import numpy as np
names = ['Jerry', 'Kramer', 'Elaine', 'George', 'Newman']
arrival_times = [*range(10,60,10)]
arrival_times_np = np.array(arrival_times)
new_times = arrival_times_np - 3
guest_arrivals = [(names[x],time) for x,time in enumerate(new_times)]
welcome_map = map(welcome_guest, guest_arrivals)
guest_welcomes = [*welcome_map]
print(*guest_welcomes, sep='\n')

list(enumerate(new_times))
'''aaaaaaaaaaaaaaaaaa ^^^ '''

##############################











