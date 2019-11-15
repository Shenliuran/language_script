# 第十九章 数据库编程

## JDBC配置

### 数据库URL

+ JBDC使用了一种与普通URL相类似的语法描述数据源，一下是这种语法的两个实例：

    ```txt
    jdbc:derby://localhost:1527/COREJAVA;create=true    描述的是derdy数据库
    jdbc:postgresql:COREJAVA    描述的是PostgreSQL数据库
    ```

+ 一般语法：`jdbc:subprotocal:other stuff`
    1. `subprotocal`用于选择连接到的数据库的具体驱动
    2. `other stuff`参数的格式随使用的subprotoocal不同而不同，需要查看相应的文档

### 驱动程序jar文件

+ 在运行访问数据库的程序时，需要将驱动程序的jar文件包含到类路径中（编译时并不需要这个jar文件）
+ 在从命令行启动程序时，只需要使用下面的命令：`java -c classpath driverPath;. ProgramName`

### 启动数据库

+ 使用Derdy数据库的步骤：
    1. 在shell中转到存放数据库文件的目录中
    2. 定位derbyrun.jar文件
    3. 运行下面的命令：`java -jar "derbyrun.jar路径" server start`
    4. 创建一个名为`ij.properites`的文件，并包含以下各行文件：

        ```txt
        ij.driver=org.apache.derby.jdbc.ClientDriver
        ij.protocol=jdbc:derby://localhost:1527/
        ij.database=COREJAVA;create=true
        ```

    在另一个命令shell中，执行下面命令来运行Derby的交互式命令执行工具：`java -jar "derbyrun.jar路径" ij -p ij.properties`
    5. 使用SQL命令创建数据库
    6. 关闭服务器：`java jar "derbyrun.jar路径" server shutdown`

### 注册驱动器类

+ 通过使用`DriverManager`，可以使用两种方式来注册驱动器：
    1. 在就Java程序中加载驱动器类：`Class.forName("com.mysql.cj.jdbc.Driver");`（加载MySQL驱动器）
    2. 另一种方式是设置`jdbc.drivers`属性：`java -Djdbc.drivers=org.postgresql.Driver ProgramName`</br>或者是在应用中用下面这样的调用来设置系统属性：`System.setProperty("jdbc.drivers", "org.postgresql.Driver");`</br>在这种方式中可以提供多个驱动器，并用冒号分隔：`org.postgresql.Driver:org.apache.derby.jdbc.ClientDriver`

### 连接数据库

+ （以MySQL 8.0.15为例）
+ 数据库连接代码：

    ```java
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/jtdb?userSSL=false&serverTimezone=UTC";
    private static final String USERNAME = "shenliuran";
    private static final String PASSWORD = "1234";
    Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
    ```

+ 也可以通过加载自己写的配置文件来连接：

    ```properties
    jdbc.driver=com.mysql.cj.jdbc.Driver
    jdbc.url=jdbc:mysql://localhost:3306/jtdb?userSSL=false&serverTimezone=UTC
    jdbc.username=shenliuran
    jdbc.password=1234
    ```

## 使用JDBC语句

### 执行SQL语句

+ 执行步骤：
    1. 执行SQL语句之前，需要创建一个`Statement`对象
    2. 调用`DriverManager.getConnection`方法获得一个`Connection`对象
    3. 实例化Statement对象：`Statement state = conn.createStatement();`
    4. 定义执行语句：`String sql = "UPDATE books SET Price = Price - 5.00 WHERE Title NOT LIKE '%Introduction%'";`
    5. 调用Statement接口中的`executeUpdate`方法：`state.executeUpdate(sql);`
+ `executeUpdate`方法用以执行：`INSERT`, `UPDATE`, `DELETE`之类的操作
+ `executeQuery`方法用以执行：`CREATE TABLLE`, `DROP TABLE`, `SELECT`之类的操作
+ 运行结果记录在`ResultSet`类型的对象中，通过对它来每次一行地迭代遍历所有结果：

    ```java
    ResultSet rs = state.executeQuery("SELECT * FROM Books");
    while (rs.next()) {
        look at a row of the result set
    }
    ```

### 管理连接、语句和结果集

+ 使用完ResultSet、Statement或Connection对象后，需要调用`close`方法，关闭资源

### 分析SQL异常

+ 每个`SQLException`都是由多个SQLException对象构成的链，这些对象可以通过`getNextException`方法获取
+ 使用如下代码进行遍历：

    ```java
    for (Throwable t : sqlExceptio) {
        //do something with t
    }
    ```

+ 可以调用`getSQLState`和`getErrorCode`方法进一步分析
+ 可以通过下面的代码，获取警告链：

    ```java
    SQLWarning w = state.getWarning();
    while (w != null) {
        //do something with w
        w = w.nextWarning();
    }
    ```

    SQLWarning是SQLException的子类

### 组装数据库

+ 可以使用`ExecSQL`程序读取固定格式的sql脚本文件：创建数据表，并插入数据
+ 在确认数据库服务器是正在运行的情况下，使用如下方法运行该程序：

    ```shell
    java -classpath driverPath;. exec.ExecSQL Books.sql
    java -classpath driverPath;. exec.ExecSQL Authors.sql
    java -classpath driverPath;. exec.ExecSQL Publishers.sql
    java -classpath driverPath;. exec.ExecSQL BooksAuthors.sql
    ```

+ ExecSQL程序的操作步骤：
    1. 连接数据库，读取database.properties文件
    2. 使用SQL语句打开文件
    3. 使用泛化的`execute`方法执行每一条语句
    4. 如果产生结果集，则打印出来
    5. 如果运行过程中出现SQL异常，则打印出结果链
    6. 关闭数据库连接

## 执行查询操作

### 预备语句

+ 通过使用带有宿主变量的查询语句，可以避免在每次开始一个查询时都要建立新的查询语句
+ 在预备查询语句中，每个宿主变量都用“?”表示，例如：

    ```java
    String publisherQuery =
        "SELECT Books.Price, Books.Title" +
        "FROM Books, Publishers" +
        "WHERE Books.Publisher_Id = Publishers.Publisher_Id AND Publishers.Name = ?";
    PerpaerdStatement state = conn.prepareStatement(publisherQuery);
    ```

### 读写LOB

+ 在SQL中，二进制大对象称为`BLOB`，字符型大对象称为`CLOB`
+ 要读取LOB，需要执行SELECT语句，然后在ResultSet上调用`getBlob`和`getClob`方法
+ 要从Blob中获取二进制数据，可以调用`getBytes`或者`getBinaryStream`，如保存图像：

    ```java
    state.set(1, isbn);
    try (ResultSet result = state.executeQuery()) {
        if (result.next()) {
            Blob coverBlob = result.getBlob();
            Image coverImage = ImageIO.read(coverBlob.getBinaryStream());
        }
    }
    ```

+ 类似地，如果获取了Clob对象，可以调用`getSubString()`和`getCharacterStream()`方法来获取其中的字符数据
+ 使用`Connection`对象，调用`createBlob`或`createClob`，获取一个用于该LOB的输入流或写出器，如存储一张图像：

    ```java
    Blob coverBlob = connection.createBlob();
    int offset = 0;
    OutputStream out = coverBlob.setBinaryStream(offset);
    ImageIO.write(coverImage, "PNG", out);
    PreparedStatement state = conn.prepareStatement("INSERT INTO Cover VALUES(?, ?)");
    state.set(1, isbn);
    state.set(2, coverBlob);
    state.executeUpdate();
    ```

### SQL转义

+ 转义主要用于下列场景：
    1. 日期和字面常量、
        1. 使用`d`表示`DATA`：`{d '2008-01-24'}`
        2. 使用`t`表示`TIME`：`{t '23:59:59'}`
        3. 使用`ts`表示`TIMESTAMP`：`{ts '2008-01-24 23:59:59'}`
    2. 调用标量函数（标量函数：传入参数个数不定，但是返回值只有一个）需要向下面这样嵌入标准的函数名和参数：
        1. `{fn left(?, 20)}`
        2. `{fn user()}`
        3. 在JDBC规范中可以找到它支持的函数名的完成列表
    3. 调用存储过程，调用存储过程需要使用`call`转义命令，使用`=`来捕获存储过程返回值：
        1. `{call PROC1(?, ?)}`
        2. `{call PROC2}`
        3. `{call ? = PROC3(?)}`
    4. 外连接
    5. 在`LIKE`子句中的转义字符
        1. 如果想要匹配所有包含"_"字符的字符串，就必须使用下面的结构：`... WHERE ? LIKE %_% {escape '!'}`

### 多结果集

+ 下面是获取所有结果集的步骤
