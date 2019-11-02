# 第十六章 输入与输出

## 输入/输出流

### 完整流家族

+ 输入流与输出流的层次</br>![avatar](../images/Java/输入与输出流的层次结构.png)
    1. `InputStream`和`OutputStream`类, 可以读写单个字节或这是字节数组
    2. `DataInputStream`和`DataOutputStream`类, 可以以二进制格式读写所有基本的Java类型
    3. `ZIPInputStream`和`ZIPOutputStream`类, 可以以常见的ZIP压缩文件格式读写文件
+ Reader和Writer的层次</br>![avatar](../images/Java/Reader和Writer层次结构图.png)
    1. 用来处理Unicode文本
+ Closable、Flushable、Readable和Appendable接口![avatar](../images/Java/Closeable、Flushable、Readabe和Appendable接口.png)

### 组合输入输出流过滤器

+ 所有在java.io中的类都将 **相对路径名** 解释为 **以用户工作目录开始**, 可以通过调用`System.getProperty("user.dir")`来获取这个信息

## 文本输入与输出

+ 在存储文本字符串时，需要考虑字符串编码方式，Java内部使用UTF-16编码方式
+ `OutputStreamWriter`类使用选定的字符编码方式，把Unicode码元的输入流转啊混为字节流
+ `InputStreamReader`类包含字节的输入流转换为可以生产Unicode码元的读入器
+ *读入流输入器* 会假定使用主机系统所使用的默认字符编码方式：

    ```java
    Reader in = new InputStreamReader(System.in);
    ```

### 如何写出文本输出

+ `PrintWriter`：文本输出
+ 这个类拥有以文本格式打印字符串和数字的方法
+ 还可以链接到`FileWriter`，如：

    ```java
    PrintWriter out = new PrintWriter(new FileOutputStream("employee.txt"), "UTF-8");
    //等同于：
    PrintWriter out = new PrintWriter("employee.txt", "UTF-8");
    ```

+ 使用`ouot.print()`、`out.println()`和`out.printf()`方法，将数据输出到employee.txt文件中
+ 如果写出器设置为 **自动冲刷模式** ，那么只要println被调用，缓冲区中的所有字符都会被发送到它们的目的地（**打印写出器总是带缓冲区的**）
+ **默认情况** 下，自动冲刷机制是被 **禁用** 的：

    ```java
    PrintWriter out = new PrintWriter(
        new OutputStreamWriter(
            new FileOutputStream("employee.txt"), "UTF-8"
        ),
        true
    );
    ```

    print方法不抛出异常，可以调用`checkError`方法查看输出流是否出错

### 如何读入文本输入

+ 最简单的方式使用`Scanner`类
+ 短小的文本文件可以使用String构造器方法：

    ```java
    String content = new String(Files.readAllBytes(filepath), charset);
    ```

+ 如果想要一行一行地读入可以调用：

    ```java
    List<String> lines = Files.readAllLines(filepath, charset);
    ```

+ 如果文件太大，可以将行惰性处理为一个`Stream<String>`对象：

    ```java
    try (Stream<String> lines = Files.lines(filepath, charset)) {
        ...
    }
    ```

### 字符编码方式

+ `StandardCharsets`类具有类型为`Charset`的静态变量，用于表示每种Java虚拟机都必须支持的字符编码方式：
    1. `StandardCharsets.UTF_8`
    2. `StandardCharsets.UTF_16`
    3. `StandardCharsets.UTF_16BE`
    4. `StandardCharsets.UTF_16LE`
    5. `StandardCharsets.ISO_8859_1`
    6. `StandardCharsets.US_ASCII`
+ 在读写文本的时候，应该使用Charset对象

## 读写二进制数据

### DataInput和DataOutput接口

+ `DataOutput`接口定义了下面用于二进制格式写数组、字符、boolean值和字符串的方法：
    1. `writeInt`：总是将一个整数写出为 **4字节** 的二进制数量值，不管它有多少位
    2. `writeDouble`：总是将一个double值写出为 **8字节** 的二进制数量值
    3. `writeUTF`：使用 **修订版的8位Unicode** 转换格式写出字符串，只在用于写出Java虚拟机的字符串是才使用
    4. `writeChars`：其他场合都应该使用这个方法
    5. `writeByte`、`writeBoolean`、`writeLong`、`writeChar`、`writeFloat`、`writeShort`
+ `DataInput`接口用于读回数据，有与DataOutput接口与之相应的read方法
+ `DataInputStream`类实现了DataInput接口，可以将之与某个字节源相结合，如`FileInputStream`：

    ```java
    DataInputStream in = new DataInputStream(new FileInputStream("employee.dat"));
    ```

+ 相类似的，写出二进制数据，可以使用DataOutput接口的`DataOutputStream`类：

    ```java
    DataOutputStream out = new DataOutputStream(new FileOutputStream("employee.dat"));
    ```

### 随机访问文件

+ `RandomAccessFile`类可以在文件中的 **任何位置** 查找或写入文件
+ 磁盘文件都是随机访问的
+ 构造器第二个参数：
    1. `"r"`：读入访问
    2. `"rw"`：读入/写出访问
+ `seek`方法：
    1. 用途：将文件指针设置到文件中的任意字节位置
    2. 参数：long类型整数
    3. 取值范围：0 ~ 文件按照字节来度量的长度之间
+ `getFilePointer`方法：返回文件指针当前位置
+ 该类同时实现了DataOutput和DataInput接口
+ 设置文件读入位置：

    ```java
    long n = 3;
    in.seek((n - 1) * RECORD_SIZE);
    Employee e = new Employee();
    e.readData(in);
    ```

+ 设置文件写出位置：

    ```java
    in.seek((n - 1) * RECORD_SIZES);
    e.writeData(out);
    ```

+ `length`方法：确定文件中的字节总数
+ 记录总数：字节总数 / 每条记录的大小

    ```java
    long nbtyes = in.length() // length in bytes
    int nrecords = (int) (nbytes / RECORD_SIZE);
    ```

+ 通过使用用户 **自定义** 的方法来读写具有固定尺寸的字符串：
    1. `writeFixedString`：写出从字符串开头开始的指定数量码元（如果码元过少，该方法将用0值来补齐字符串）

        ```java
        public static void writeFixedString(String s, int size, DataOutput out) throws IOException {
            for (int i = 0; i < size; i++) {
                char ch = 0;
                if (i < s.length()) ch = s.charAt(i);
                out.writeChar(ch);
            }
        }
        ```

    2. `readFixedString`：从输入流中读入字符，直至读入size个码元，或直至遇到具有0值的字符值，然后跳过输入字段中剩余的0值：

        ```java
        public static String readFixedString(int size, DataInput in) throws IOException {
            StringBuilder b = new StringBuilder(size);
            int i = 0;
            boolean more = true;
            while (more && i < size) {
                char ch = in.readChar();
                i++;
                if (ch == 0) more = false;
                else b.append(ch);
            }
            in.skipBytes(2 * (size - 1));
            return b.toString();
        }
        ```

    3. 将以上两个方法放到`DataIO`助手类的内部

### ZIP文档
