# 第五章 首次登陆与在线求助

## 首次登陆

+ 语系设置：`$LANG`

+ man page
    1. man page中的常用按键整理：</br>
    >按键|进行工作
    >|:--|:--|
    >[Page Down]|向下翻页
    >[Page Up]|向上翻页
    >[ Home]|去到第一页
    >[ End]|去到最后一页
    >/string|向下查找string
    >?string|向上查找string
    >n,N|利用 / 或 ? 来搜寻字符串时，可以用 n 来继续下一个搜寻 (不论是 / 或 ?) ，可以利用 N 来进行『反向』搜寻。举例来说，我以 /vbird 搜寻 vbird 字符串， 那么可以 n 继续往下查询，用 N 往上查询。若以 ?vbird 向上查询 vbird 字符串， 那我可以用 n 继续『向上』查询，用 N 反向查询。
    >q|退出man page
+ 查找和`man`命令有关的命令的说明文件：`man -f man`
+ 列出说明文件中所有，有man这个关键词说明：`man -k man`
+ 与`man`简略写法：`whatis`相当于`man -f man`，`apropos`相当于`man -k man`