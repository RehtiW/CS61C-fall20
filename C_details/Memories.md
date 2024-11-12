# Static Storage:
## 作用:存储全局变量


# The Stack:
## 作用:store local variables included:function call,local variables


# The Heap:
## 作用:store variables that assigned by  [[void* malloc(size_t size)]]
## 堆内存管理的典型实行方式之一:
### 空闲链表(FreeList):
实现: 每一个节点表示一个空闲内存块,包含内存块的大小以及指向下一个空闲内存块的指针
分配内存: 管理器遍历链表,找到满足第一个大小的空闲内存块,然后分割成所需大小,剩余部分继续作为空闲块
释放内存: 管理器将空闲块插入链表中，必要时合并相邻的空闲块，避免内存碎片。
	
