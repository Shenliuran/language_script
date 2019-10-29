# 第十一章

+ 视图(View)是一种虚拟存在的表,对于使用视图的用户来说基本上是透明的
+ 视图并不在数据库中实际存在
+ 视图相对于普通的表的优势主要包括以下几项
    1. 简单 
    2. 安全
    3. 数据独立

## 视图操作

### 创建或者修改视图

+ 创建视图要有`create view`的权限，并且对于涉及到的列有select权限
+ 使用`create or replace`或者是`alter`修改视图，还需要有`drop`权限
+ 创建视图语法为：

    ```sql
    create [or replace] [algorithm = {undefinded | merge | temptable}]
        view view_name [(column_list)]
        as select_statement
        [with [cacaded | local] check option]
    ```


+ 修改视图语法为：

    ```sql
    create [algorithm = {undefinded | merge | temptable}]
        view view_name [(column_list)]
        as select_statement
        [with [cacaded | local] check option]
    ```

+ MySQL视图的限制：from 关键字后面不能包含子查询
+ 视图的可更新性与视图中查询的定义有关
+ 以下类型的视图是不可更新的：
    1. 包含以下关键字的SQL语句：聚合函数（sum、min、max、count等）、distinct、group by、having、union或者union all
    2. 常量视图
    3. select中包含的子查询
    4. join
    5. from一个不可更新的视图
    6. where字句的子查询引用了from字句中的表
