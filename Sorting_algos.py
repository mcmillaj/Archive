import random


def MergeSort(v):
     
    v_size = len(v)
     
    if v_size < 2:
        return v 
    
    midpoint = round(v_size/2)
     
    v_left = v[0:midpoint] # left half of vector 
    v_right = v[midpoint:v_size]
    
    #recursive call on both halves
    l = MergeSort(v_left)
    r = MergeSort(v_right)
    
    # 2 pointers to traverse the two vector halves
    l_point = 0
    r_point = 0
    
    #output vector, starts empty
    result = []
    
    while True: # loop will end from break
        
        left_na = False if l_point < len(l) else True
        right_na = False if r_point < len(r) else True
        
        if left_na and right_na:
            left_less = "NA"
        elif left_na:
            left_less = False
        elif right_na:
            left_less = True
        elif l[l_point] > r[r_point]:
            left_less = False
        else:
            left_less = True
        
        if left_less == "NA":
            break  # finished loop in this case 
        
        if left_less:
            result.append(l[l_point])
            l_point += 1
        else:
            result.append(r[r_point])
            r_point += 1
    return result


def Swap(v,a,b):
    tmp = v[a]
    v[a] = v[b]
    v[b] = tmp


def QuickSort(v):
    
    v_size = len(v)
    
    if v_size == 1:
        return v
    
    pivot_index = random.sample(range(v_size),1)[0]
    pivot = v[pivot_index]
    
    Swap(v,0,pivot_index)
    
    border = 1
    i = 1
    
    while i < v_size:
        if v[i] < pivot:
            Swap(v,i,border)
            border += 1
        i += 1
    
    border -= 1
    Swap(v,0,border)
    
    if border == 0:
        l_recurse_v = []
        left_single = True
    else:
        l_recurse_v = v[0:border]
        left_single = False
    if border == v_size - 1:
        r_recurse_v = []
        right_single = True
    else:
        r_recurse_v = v[border+1:v_size]
        right_single = False
    
    l_recurse = l_recurse_v if left_single  else QuickSort(l_recurse_v)
    r_recurse = r_recurse_v if right_single else QuickSort(r_recurse_v)
    
    return l_recurse + [v[border]] + r_recurse
           
        
t = random.sample(range(100000),100000)

r = MergeSort(t)

q = QuickSort(t)

print(q)

        
t = random.sample(range(100000000),100000000)
start = time.time()
q = QuickSort(t)
end = time.time()
print(end-start)
