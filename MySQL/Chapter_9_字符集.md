# 第九章 字符集

+ 对数据库来说，字符集更加重要，对数据库的存储、处理性能，以及日后系统的移植、推广都会有影响

## MySQL支持的字符集

+ 可以使用`SHOW character set`查看当前版本的数据库支持的字符集
+ 使用`DESC information_schema.character_sets`，查看所有字符集和该字符集默认的校对规则
+ MySQL的字符集包含字符集（CHARACTER）和校对规则（COLLATION）两个概念：
    1. 字符集：定义MySQL储存字符串的方式
    2. 校对规则：定义字符串的比较规则
+ 校对规则命名约定：`_ci`（大小写不敏感）、`_cs`（大小写敏感）、`_bin`（二元，即比较是字符编码的值而与语言（language）无关）

## MySQL字符集的设置

+ MySQL的字符集和校对规则有4个级别的默认设置：服务器级、数据库级、表级和字段级

### 服务器字符集和校对规则

+ 在MySQL服务启动的时候确定
+ 配置方法
    1. 在`my.ini`或`my.cnf`中设置：

        ```ini
        [mysqld]
        default-character-set = gbk
        ```

    2. 在启动项中指定：

        ```shell
        mysqld --default-character-set = gbk
        ```

    3. 在编译时指定：

        ```shell
        ./configure --with-charset = gbk
        ```

+ 如果没有特别指定服务器字符集，默认使用`latin1`作为服务器字符集
+ 使用`SHOW VARIABLES LIKE 'character_set_server'`查询当前服务器的字符集
+ 使用`SHOW VARIABLES LIKE 'collation_server'`查询当前服务器的校对规则

### 数据库字符集和校对规则

+ 数据库的字符集和校对规则在创建数据库的时候指定，也可以在创建完数据库后通过“alter database”命令进行修改
+ 不能通过修改数据库的字符集直接修改数据的内容
+ 设置数据库字符集的规则：
    1. 如果使用字符集和校对规则，则使用指定的字符集和校对规则
    2. 如果指定了字符集没有指定校对规则，则使用指定字符集的校对规则
    3. 如果没有指定字符集和校对规则，则使用服务器的字符集和校对规则作为数据库的
+ 推荐在创建数据库时，明确指定字符集和校对规则，**避免受到默认值的影响**
+ 使用`SHOW VARIABLE LIKE 'character_set_database'`查看数据库字符集
+ 使用`SHOW VARIABLE LIKE 'collation_database`查看数据库校对规则

### 表字符集和校对规则

+ 表的字符集和校对规则在创建表的时候指定，可以通过 alter table 命令进行修改
+ 如果表中已有记录，修改字符集对原有的记录并没有影响，不会按照新的字符集进行存放
+ 设置表的字符集的规则和数据库基本类似，只是默认值是依据数据库的字符集和校对规则
+ 使用`SHOW CREATE TABLE tablename`查看相关信息

### 连接字符集和校对规则

+ 对于客户端和服务器的交互操作，有三个不同的参数：
    1. `character_set_client`：客户端字符集
    2. `character_set_connection`：连接字符集
    3. `character_set_results`：返回结果的字符集
+ 通常情况，三个字符集应该是相同，才可以确保用户写入的数据可以正确地读出
+ 通常情况下，不会单个地设置这三个参数，可以通过以下命令：`SET NAMES ***;`来设置连接的字符集和校对规则，这个命令同时修改这三个参数觉得值
+ 另一个更简洁的方法，是在my.cnf设置以下语句：

    ```ini
    [mysql]
    default-character-set = gbk
    ```

+ 通常情况下，基本不需要用户强制指定字符串字符集

## 字符集的修改步骤

+ 字符集的修改不能直接通过“ALTER DATABASE CHARACTER SET ...” 或者 “ALTER TABLE tablename CHARACTER SET ...”，命令进行，这两个命令都没有更新已有记录的字符集，而只能会新创建的表或者记录生效
+ 正确的步骤：
    1. 导出表的结构：

        ```shell
        mysqldump -u root -p 'password' --default-character-set = gbk -d 'databasename' > createtab.sql
        ```

        其中`-d`表示只导出表结构，不导出数据
    2. 手工修改createtab.sql中表结构定义中的字符集为新的字符集
    3. 确保记录不再更新，导出所有记录：

        ```shell
        mysqldump -u root -p 'password' --quick --no-create-info --extended-insert --default-character-set = latin1 'databasename' > data.sql
        ```

        + `--quick`：该选项用于转储大的表
        + `--extended-insert`：使用包括几个values列表的多行insert语法，这样使得转储文件更小，重载文件时可以快速插入
        + `--no-create-info`：不写重新创建每个转储表的create table语句
        + `--default-character-set = latin1`：按照原有的字符集导出所有数据，这样导出的文件中，所有中文都是可见的，不会保存成乱码

    4. 打开data.sql，将SET NAMES latin1 修改成 `SET NAMES gbk`
    5. 使用新的字符集创建新的数据库：

        ```sql
        CREATE DATABASE databasename DEFAULT CHARSET gbk
        ```

    6. 创建表，执行createtab.sql

        ```shell
        mysql -u root -p 'password' 'databasename' < createtab.sql
        ```

    7. 导入数据，执行data.sql

        ```shell
        mysql -u root -p 'password' 'databasename' < data.sql
        ```

## 注意

+ 选择目标字符集的时候，最好是原字符集的超集，或者确定比原字符集的字库更大，以访数据丢失或乱码
