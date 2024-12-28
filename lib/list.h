#ifndef LIST_H
#define LIST_H

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>

#define List(T) List_##T

#define List_Def(T)\
    typedef struct {\
        T* items;\
        size_t count;\
        size_t capacity;\
    } List(T)

#define shuffle(start, offset, count) memmove((start)+(offset), (start), (count)*sizeof(*(start)));\

#define list_ensure_cap(list, cap)\
    if ((cap) >= list.capacity) {\
        if (list.capacity == 0) list.capacity = 256;\
        else list.capacity = (cap)*2;\
        list.items = realloc(list.items, list.capacity*sizeof(*list.items));\
        assert(list.items);\
    }

#define list_append(list, x)\
    do {\
        list_ensure_cap(list, list.count+1);\
        list.items[list.count++] = x;\
    } while(0)

#define list_insert(list, idx, x)\
    do {\
        assert((idx) >= 0 && (idx) <= list.count);\
        list_ensure_cap(list, list.count+1);\
        if ((idx) < list.count) shuffle(&list.items[idx], 1, list.count-idx);\
        list.items[idx] = x;\
        list.count++;\
    } while(0)

#define list_unordered_remove(list, idx)\
    do {\
        assert(idx >= 0 && idx < list.count);\
        list.count--;\
        list.items[idx] = list.items[list.count];\
    } while(0)

#define list_ordered_remove(list, idx)\
    do {\
        assert((idx) >= 0 && (idx) < list.count);\
        if (idx < list.count-1) {\
            shuffle(&list.items[idx+1], -1, list.count-idx-1);\
        }\
        list.count--;\
    } while(0)

#endif
