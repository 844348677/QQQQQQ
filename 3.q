/ q中的所有数据结构最终构建于list，dictionary是一对list，table是特殊的dictionary，keyed table是一对table
/ list中元素类型一致的，叫simple list，数学中的向量，最佳的存储和表现形式
/ q的list，类似动态分配数组
/ list是有序的集合
/ list使用括号创建，内部元素使用分号分隔，空格是可选的
(1; 1.1; `1)
(1;2;3)
("a";"b";"c";"d")
(`Life;`the;`Universe;`and;`Everything)
(-10.0; 3.1415e; 1b; `abc; "z")
((1; 2; 3); (4; 5))
((1; 2; 3); (`1; "2"; 3); 4.4)
/ list的顺序是从左到右，1;2和2;1是不同的，时间序列更快
/ 可以将list赋值给变量
L1:(1;2;3)
L2:("z";"a";"p";"h";"o";"d")
L3:((1; 2; 3); (`1; "2"; 3); 4.4)
/ count函数，用来得到list中元素的个数
count (1; 2; 3)
count L1
/ list中能容纳的最大元素个数为2^64-1
/ count单个元素得到的值是1，尽管单个原子不是list
count 42
count `zaphod
/ first和last函数分别得到list的第一个和最后一个元素
first (1; 2; 3)
last (1; 2; 3)
/ list中的元素同一类型叫simple list，相似数学中的vector，更少的内存空间，更快的操作
/ q动态的转成simple list，不用申请，simple list的创建可以省略括号
/ q中对比唯一性使用~，深度复制
(100;200;300)
100 200 300
100 200 300~(100; 200 ; 300)
(1h; 2h; 3h)
(100i; 200i; 300i)
/ 类型的尾部标识符，需要在每个元素后面都加上，否则不是simple list
(1; 2; 3h)
(123.4567; 9876.543; 99.0)
123.4567 9876.543 99
1.0 2.0 3.0
1 2 3f~1.0 2.0 3.0
/ 浮点数中包含了整数，整数会自动转成浮点数
1.1 2 3.3~1.1 2.0 3.3
(0b;1b;0b;1b;1b)
(0x20;0xa1;0xff)
0x20a1ff~(0x20;0xa1;0xff)
3?0Ng
(`Life;`the;`Universe;`and;`Everything)
`Life`the`Universe`and`Everything
/ 创建symbol list时候，在两个symbole中加空格，会产生错误
/ `bad `news
("s"; "t"; "r"; "i"; "n"; "g")
/不能使用=判断两个长度不同的string，但是可以使用~判断唯一
/ "string"="text"
"string"~"text"
(2000.01.01; 2001.01.01; 2002.01.01)
(00:00:00.000; 00:00:01.000; 00:00:02.000)
/ 时间类型会自动转成宽的类型，构成simple list
12:34 01:02:03
01:02:03 12:34
01:02:03 12:34 11:59:59.999u
/ 当list中的元素为零个或一个的时候，情况特别，分别为空列表和单例列表
/ 创建空列表使用一对括号，中间没有任何东西
()
/ 如果想强制显示空列表，使用命令-3!，这个会强制将实体显示string
L:()
-3!L 
/ 单例列表和单个元素不一样
/ 单例列表的创建使用enlist函数
enlist 42
/ 单char的string，不能直接使用"a"，需要使用函数enlist
"a"
enlist "a"
/ 单例中的元素可以是任何的q实体
enlist 1 2 3
enlist (10 20 30; `a`b`c)
/ list的顺序是从左到右，可以使用index来获取对应位置的元素，0到n-1，index在n上没有元素
/ 使用方括号包含index，访问list中的元素，index越界返回null值
(100; 200; 300)[0]
100 200 300[0]
L:100 200 300
L[0]
L[1]
L[3] / index out of bounds returns null value
L[2]
/ 可以使用index对其位置进行赋值
L:1 2 3
L[1]:42
L
/ 在对simple list中元素赋值，类型必须强制匹配，窄类型不会提升为宽类型
/ index为无效的值会出错
L:(-10.0; 3.1415e; 1b; `abc; "z")
/ L[1.0]
/ index越界不会产生错误，会返回空值，表示确实数据
L1:1 2 3 4
L1[4]
L2:1.1 2.2 3.3
L2[-1]
L3:(`1; 2; 3.3)
L3[0W]
/ 如果省略了index，则返回整个list
L:10 20 30 40
L[]
/ 确实index和index为空列表，不用，index为空列表，返回空列表，可以强制输出
-3!L[()]
L[::]
L:(::; 1 ; 2 ; 3)
type L
-3!L[0]
/ 使用::占位符，可以防止list被自动转成simple list
L:(1; 2; 3; `a)
L[3]:4
L
/ L[3]:`a
L:(::; 1 ; 2 ; 3; `a)
L[4]:4
L[4]:`a
/ list中可以含有表达式
a:42
b:43
(a; b)
L1:1 2 3
L2:40 50
(L1; L2)
(count L1; sum L2)
/ list中含有变量，创建时候不能省略括号
/ a b
/ 合并list使用逗号，将右边参数添加到左边参数尾部，左右两边参数都可以是原子
1 2 3,4 5
1,2 3 4
1,2 3 4
/ join两边类型不同，返回general list
1 2 3,4.4 5.5
/ merge两个相同length的list，右边list的值替换左边对应位置的值，除非右边值为null
L1:10 0N 30
L2:100 200 0N
L1^L2
/ list可以作为数学映射关系，作用域为index，值域为L[i]
101 102 103 104
(`a; 123.45; 1b)
(1 2; 3 4)
/ list可以看做map，但是参数时一元的
/ 嵌套列表，单元素的深度为0，simple list的深度为1，depth
L:(1;2;(100;200))
count L
L:(1;2;100 200)
count L
L[0]
L[1]
L[2]
L2:((1;2;3);(`ab;`c))
count L2
L3:((1; 2h; 3j); ("a"; `bc`de); 1.23)
count L3
L3[1]
count L3[1]
/ depth为2的单例列表，列表中的唯一元素为simple list
L4:enlist 1 2 3 4
count L4
count L4[0]
/ 矩阵
m:((11; 12; 13; 14); (21; 22; 23; 24); (31; 32; 33; 34))
m
m[0]
m[1]
m[1][0]
L:(1; (100; 200; (1000; 2000; 3000; 4000)))
L[0]
L[1]
L[1][2]
L[1][2][0]
/ 迭代index获取元素，同时可以使用indexing at depth，使用方括号，分号分割，获取嵌套列表元素
/ 严格的语法糖，方括号内部的index与nest list的depth相同
L[1;2;0]
/ 对嵌套列表赋值，使用index at depth，迭代index的方法无效
L:(1; (100; 200; (1000 2000 3000 4000)))
L[1; 2; 0]: 999
L
/ L[1][2][0]:42
/ 因为中间产物存在的时间有限，无法寻址该实体
m:((11; 12; 13; 14); (21; 22; 23; 24); (31; 32; 33; 34))
m
m[0][0]
m[0; 0]
m[0; 1]
m[1; 2]
/ 对list重构成矩阵，0N表示确实数据，使用#符号，做参数n行m列，右参数为list
2 0N#til 10
0N 3#til 10
/ q是向量操作语言
L:100 200 300 400
L[0]
L[2]
/ index可以为list，同时检索多个元素
L[0 2]
/ 检索的到的列表，与index中的list长度匹配
L[3 2 0 1]
L[0 2 0]
01101011b[0 2 4]
"beeblebrox"[0 7 8]
/ 注意没有分号分割
/ index可以为变量
L
I:0 2
L[I]
/ index可为嵌套列表
L:100 200 300 400
L[(0 1; 2 3)]
/ 通过index对list元素赋值
L:100 200 300 400
L[0]:100
L
L[1 2 3]:2000 3000 4000
L
/ 赋值的顺序从左到右
L[3 2 1]:999 888 777
L[3]:999
L[2]:888
L[1]:777
/ 因此多次赋值，最右边的赋值操作生效
L:100 200 300 400
L[0 1 0 3]:1000 2000 3000 4000
L
L:100 200 300 400
L[1 3]:999
L
/ 根据索引获取值，在函数式编程有简单的写法，省略方括号和分号，并列写，空格分割
L:100 200 300 400
L[0]
L 0
L[2 1]
L 2 1
I:2 1
L I
L ::
/ 个人喜好
/ find使用二元操作符问号?，在左边list中查找右边元素，所对应的索引值
1001 1002 1003?1002
/ 如果没有找到，则返回list的length
1001 1002 1003?1004
/ 当右边参数，需要查找为list，以此查找内部元素，返回index的list
1001 1002 1003?1003 1001
m:(1 2 3 4; 100 200 300 400; 1000 2000 3000 4000)
m
/ 当矩阵省略掉其中一个index，会获得整行或者整列
m[1;]
m[;3]
m[1;]~m[1]
L:((1 2 3;4 5 6 7);(`a`b`c`d;`z`y`x`;`0`1`2);("now";"is";"the"))
L
L[;1;]
L[;;2]
L[0 2;;0 1]
L:(1 2 3; (10 20; 100 200; 1000 2000))
L
/ 矩形list，可以使用flip函数，对其进行转置
L:(1 2 3; 10 20 30; 100 200 300)
L
flip L
L:(1 2 3; 10 20 30; 100 200 300)
M:flip L
L[1;2]
M[2;1]
/ 矩阵，q没有tuple，q中的vector可以不是数值类型，矩阵的纬度为1时，为向量，
v1:1 2 3 / vector of integers
v2:98.60 99.72 100.34 101.93 / float vector
v3:`so`long`and`thanks`for`all`the`fish / symbol vector
/ 二维矩阵，嵌套列表，每个元素为一行，行操作快，列操作慢
/ 矩阵可以看做行的集合，二维矩阵操作行很快
/ table是行的转置，所以在对table的列操作很快，列为simple list，操作时间序列是，两列是平行列表
/ 一列是时间值，一列是链接值，把列当做vector操作，很快，效率高
mm:((1 2;3 4;5 6);(10 20;30 40;50 60))
mm
mm[0]
mm[1]
m:(1 2; 10 20; 100 200; 1000 2000)
m 0 2
/ til接受一个非负数，生成从0开始，n个整数的list
til 10
1+til 10
2*til 10
1+2*til 10
-5+4*til 3
/ distinct去重复，顺序为元素第一次出现的顺序
distinct 1 2 3 2 3 4 6 4 3 5 6
/ where返回值为1b的index list
where 101010b
/ where很有用的一点，在于识别list中的判断条件
L:10 20 30 40 50
L[where L>20]:42
L
/ group一元函数，参数为list，对list中元素进行分组，以此返回该元素的所在的index值
group "i miss mississippi"