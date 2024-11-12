## C in terminal(gcc complier)
### 1.编译为可执行文件(.exe)
e.g:
gcc  -o hello interactive_hello.c
将interactive_hello.c 编译并生成一个名为 hello.exe的可执行文件
-g 
## 2.运行当前目录下的可执行文件
e.g:
./hello.exe
## 3.debugger(GDB)
e.g:
 gcc -g -o hello hello.c
 编译生成可执行文件 (-g)并使得GCC在可执行程序中存储信息，以便GDB可以理解它
 e.g:
 gdb hello
 
 1.执行被调用的程序,在第一个断点暂停/执行至main()函数起始位置
 run/start
 2.设置断点
 break main or break line_count
 3.遇到断点后执行下一行
 next
 4.进入函数内部
 step
 5.继续执行到下一断点
 continue
 6.每执行一步展示某变量值
 display variable_name
 7.退出gdb
 quit
 
 
 


