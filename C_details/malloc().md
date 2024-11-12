# malloc()
## malloc函数原型: 
void* malloc(size_t size);
## size_t size: 
指定需要分配的内存大小(byte)
## void*: 
返回一个void* 类型的指针,指向分配的内存区域,如果内存分配失败,返回NULL
## 作用:
分配一个指定大小的连续的内存块

# free()
## malloc函数的配套函数,用于释放malloc分配的内存
## note:
如果修改指向malloc分配的内存的指

# realloc()
## 函数原型:
void* realloc(void* ptr, size_t new_size);

## note:
### 1. ptr == NULL
相当于调用malloc();
### 2.new_size == 0
相当于调用free();
