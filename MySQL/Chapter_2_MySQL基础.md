# 第二章 MySQL基础

## SQL入门

### SQL分类

+ DDL（Data Definition Languages）语句：数据定义语言，这些语句定义了不同的数据段、数据库、表、列、索引等数据库对象的定义。常用的语句关键字主要包括 create、drop、alter等。
+ DML（Data Manipulation Language）语句：数据操纵语句，用于添加、删除、更新和查询数据库记录，并检查数据完整性，常用的语句关键字主要包括 insert、delete、update 和select 等
+ DCL（Data Control Language）语句：数据控制语句，用于控制不同数据段直接的许可和访问级别的语句。这些语句定义了数据库、表、字段、用户的访问权限和安全级别。主要的语句关键字包括 grant、revoke 等。
+ MySQL预先创建的数据库：
    1. information_schema：主要存储了系统中的一些数据库对象信息。比如用户表信息、列信息、权限信息、字符集信息、分区信息等。
    2. cluster：储存了系统的集群星系
    3. mysql：储存了系统的用户权限
    4. test：系统自动创建的测试数据库，任何用户可以使用

### DDL语句

+ 选择数据库：`use dbname`
+ 查看表的信息：`desc tablename`
+ 显示表的定义信息：`desc create table tablename`
+ DDL：数据定义语句
    1. 创建数据库：`create database dbname`
    2. 删除数据库：`drop database dbname`
    3. 创建表：

        ```sql
        create table tablename(
            column_name_1 column_type_1 constrains,
            column_name_2 column_type_2 constrains,
            ...
            column_name_n column_type_n constraints
        )
        --column_name 列的名字
        --column_type 列的数据类型
        --constrains 列的约束条件
        ```

    4. 删除表：`drop table tablename`
    5. 修改表：`alter table tablename modify [column] column_definition [first | after col_name]`
    6. 增加表字段：`alter table tablename add [column] column_definition [first | after col_name]`
    7. 删除表字段：`alter table tablename drop [column] col_name`
    8. 字段改名：`alter table tablename change [column] old_col_name column_definition [first | after col_name]`（change和modify都可以修改表的定义，不同的是change后面需要写两次列名，不方便。但是change的优点是可以修改列名称，而modify则不能）
    9. 修改该字段排列顺序：默认`add`增加的新字段，加在表的最后，`change/modify`默认不会改变字段位置。想要改变位置，则要使用`[first | after col_name]`参数
    10. 改表名：`alter table tablename rename [to] new_tablename`

### DML语句

+ 插入记录：`insert into tablename(field1, field2,..., fieldn) values(value1, value2, ..., valuen)`，在MySQL中，insert语句可以一次插入多条数据：

    ```sql
    insert into tablename(field1, field2, ..., fieldn)
    values
    (record1_value1, record1_value2, ..., record1_valuen),
    (record2_value1, record2_value2, ..., record2_valuen),
    ...
    (recordn_value1, recordn_value2, ..., recordn_valuen)
    ```

+ 更新记录
    1. 修改一个表：`update tablename set field1 = value1, field2 = value2, ..., fieldn = valuen [where condition]`
    2. 同时修改多个表：`update t1, t2, ...,tn t1.filed1 = expr1, tn.fieldn = exprn [where condition]`
+ 删除记录
    1. 修改一个表：`delete from tablename [where condition]`
    2. 同时修改多个表：`delete t1, t2, ..., tn from t1, t2, ..., tn [where condition]`
+ 查询记录：
    1. 基本语法：`select * from tablename [where condition]`
    2. 查询不重复的记录：使用`distinct`
    3. 条件查询：使用`where`，可以使用比较运算符：`>、 <、 >=、<=、!=`，逻辑运算符：`or、and`
    4. 排序和限制（使用关键字`order by`）：`select * from tablename [where condition] [order by field1[desc|asc], field2 [desc|asc], ..., fieldn[desc|asc]]`（desc：降序排列，asc：升序排列）
    5. 使用`limit`关键字来实现对排序后的记录，只显示一部分，而不是全部：`select ...[limit offset_start, row_count]`（offset_start：记录的其实偏移量，row_count：显示的行数）
    6. limit经常和order by一起配合使用来进行记录的分页显示
+ 聚合：

    ```sql
    select [field1, field2, ..., fieldn] fun_name
    from tablename
    [where where_condition]
    [group by field1, field2, ..., fieldn]
    [with rollup]
    [having where_condition]
    ```

+ fun_name：聚合操作，也就是 **聚合函数** ，常用的有`sum`（求和）、`count(*)`（记录数）、`max`（最大值）、`min`（最小值）
+ group by：要进行分类聚合的字段
+ with rollup：可选语法，表明是否要对分类聚合后的结果进行再汇总
+ having：对分类后的结果再进行有条件的筛选
+ 表连接：
    1. 左连接：包含所有的左边表中的记录甚至是右表中没有和它匹配的记录
    2. 右连接：包含所有的右边表中的记录甚至是左表中没有和它匹配的记录
+ 子查询：
    1. 关键字有：in、not in、=、!=、exists、not exists等
    2. 如果 *子查询记录数唯一* ，可以用=替代in
    3. 某些情况下，子查询可以转化为表连接
    4. 表连接在很多情况下用于优化子查询
+ 记录联合：
    1. 使用关键字`union`和`union all`
    2. 语法：

        ```sql
        select * from t1
        union | union all
        select * from t2
        ...
        union | union all
        select * from tn;
        ```

### DCL语句

+ 创建一个数据库用户user1，host为localhost，具有对test1数据库中所有表的select/insert权限

    ```sql
    create user 'user1'@'localhost' identified by '123';
    grant select, insert on test1.* to 'user1'@'localhost';
    ```

+ 授予所有权限：

    ```sql
    grant all privileges on test1 to 'user1'@'localhost';--数据库权限
    grant all privileges on test1.* to 'user1'@'localhost';--表权限
    ```

+ 权限变更，收回数据库用户user1，host为localhost，insert权限：`revoke insert on test1.* to 'user1'@'localhost'`;

### 按照层次看帮助

+ ? contents
