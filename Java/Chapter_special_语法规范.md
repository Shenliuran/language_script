# 语法规范总结

## 变量定义

1. 尽量不要在同一行定义多个变量（提高代码可读性）
2. 习惯上常量名称使用全大写
3. float变量后加F或f， double变量后加D或d，long变量后加L或l
4. 在所有方法中不要命名与实例域同名的变量
5. Java程序员通常不在实例域前加前缀

## 类设计技巧

1. 一定要保证数据私有
2. 一定要对数据初始化
3. 不要在类中使用过多的基本类型
4. 不是所有的域都需要独立的域访问器和域更改器
5. 将职责过多的类进行分解
6. 类名和方法名要能够体现他们的职责：采用**一个名词**、**前面有形容词修饰的名词**或**动名词（有“-ing”后缀）修饰名词**
7. 优先使用不可变的类（尽可能的让类是不可变的）
8. 设计类层次时，要仔细思考哪些方法和类声明为final
9. 在进行类型转换之前，先查看是否能成功转换，使用*instanceof*操作符，例如：

    ```java
    if (stuff[1] instanceof Manager) {
        boss = (Managerstaff[1];
    }
    ```

10. 适用类型转换时，要捕捉**ClassCastException**异常
11. 只有在使用子类中特有的方法时才需要进行类型转换，如果需要进行类型转换，就应该检查一下超类的设计是否合理。重新设计超类并添加需要的方法才是正确的选择。
12. 一般情况下，尽量少使用类型转换和instancof运算符
13. 在实际应用中，要谨慎使用protected属性
14. 相等性检查：
    1. 如果子类能够拥有自己的相等概念，则对称性需求将强制采用getClass进行检测
    2. 如果由超类决定相等的概念，那么就可以使用instanceof进行检测，这样就可以在不同子类之间进行相等的对比
15. 编写一个完美equals方法的建议：
    1. 显示参数命名为otherObject，稍后需要将它转化成另一个叫做other的变量
    2. 检测this与otherObject是否应用同一个对象
    3. 检测otherObject是否为null，如果为null，返回false。**这项检查是很有必要的**
    4. 比较this与otherObject是否属于同一个类。如果equals的语义在每个子类中有所改动，就使用getClass检测，如果所有子类都拥有统一的语义，就是用instanceof检测
    5. 现在开始对所有需要比较的域进行比较。使用==比较基本类型域，使用equals比较对象域。如果所用的域都匹配，就返回true，否则返回false
16. 每个自定义的类中最好增加一个toString方法
17. 使用Class.forName()创建对象时，需要捕捉ClassNotFoundException

### 继承的设计技巧

1. 将公共操作和域放在超类中
2. 不要使用受保护的域，protected方法对于指示那些不提供一般用途而应在子类中重新定义的方法很有用
3. 使用继承实现“is-a”关系
4. ***除非所有继承的方法都有意义，否则不要使用继承***
5. 在覆盖方法时，不要改变预期的行为
6. 使用多态，而非类型信息
7. 不要过多的使用反射

## 接口

+ 在实现接口时，需要把方法声明为public
+ 如果存在这样一种通用算法，它能够对两个不同的子类对象进行比较，则应该在超类中提供一个compareTo方法，并在将这个方法声明为final
+ 对于每一个类，需要确定：
    1. 默认的clone方法是否满足要求，即是否只需要进行“浅拷贝”
    2. 是否可以在可变的子对象上调用clone来修补默认的clone方法
    3. 是否不否不该使用clone
    4. 第三个选项是默认选项。如果选择第一项或者第二项，类必须实现：
        + 实现Cloneable接口
        + 重新定义clone方法，并指定public访问修饰符
+ 像Cloneable这类的接口，被称为标记接口，标记接口不包含任何方法，它唯一的作用就是允许在类型查询中使用instanceof（建议自己的程序中不要使用标记接口）

    ```java
    if (obj instanceof Cloneable)
    ```

## 内部类

1. 内部类不需要方位外围类对象的时候，应该使用静态内部类

## 异常

+ 习惯上，自定义的异常类应该包含两个构造器，一个是默认的构造器；另一个是带有详细描述信息的构造器

## 泛型程序设计

1. 类型变量使用大写形式，且比较短。
2. Java库中，使用`E`表示 *集合的元素类型*， `K`表示 *关键字*，`K`表示 *值*，`T`、`U`、`S`表示 *任意类型*
3. 为了提高效率，应该将标签接口（即没有方法的接口）放在边界列表（即限定列表）的末尾
4. 想要支持擦除的转换，就需要强制限制一个类或者类型变量不能同时称为两个接口类型的子类，而这两个接口是同一接口的不同参数化，例如：

    ```java
    class Employee implements Comparable<Employee> {...}
    class Manager extends Employee implements Comparable<Manager> {...}//Error
    ```

    Manager会实现`Comparable<Employee>`和`Comparable<Manager>`，这是同一接口的不同参数化

## 集合

1. 议避免使用以整数索引表示链表中位置的所有方法
2. 如果需要对集合进行随机访问，就使用数组或 ArrayList，而不要使用链表

## 部署Java应用程序

1. 习惯上，会把属性存储在用户主目录的一个子目录中，目录名通常以一个点号开头，约定只是一个对用户隐藏的系统目录
2. 类似于包名， 只要程序员用逆置的域名作为路径的开头， 就可以避免命名冲突

## 并发

1. 不要将`InterruptedException`异常抑制在很低的层次上，如：

    ```java
    void mySubTask() {
        try {
            sleep(delay);
        } catch (InterruptedException e) {}//Don't ignore
    }
    ```

2. 如果不认为在 catch 子句中做这一处理有什么好处的话，仍然有两种合理的选择：
    1. 在 catch 子句中调用 Thread.currentThread().interrupt() 来设置中断状态。于是，调用者可以对其进行检测：

        ```java
        void mySubTask() {
            try {
                sleep(delay);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
        ```

    2. 或者，更好的选择是，用 `throws InterruptedException` 标记你的方法：

        ```java
        void mySubTask() throws InterruptedException {
            ...
            sleep(delay);
            ...
        }
        ```

3. 不要将程序构建为功能的正确性依赖于优先级
4. 守护线程应该永远不去访问固有资源， 如文件、 数据库，因为它会在任何时候甚至在一个操作的中间发生中断。
5. 默认情况下，创建的所有线程属于相同的线程组， 但是， 也可能会建立其他的组。现在引入了更好的特性用于线程集合的操作，所以建议不要在自己的程序中使用线程组
6. 如果使用锁， 就不能使用带资源的 try 语句
7. 内部锁和条件存在的限制：
    1. 不能中断一个正在试图获取锁的线程
    2. 试图获取锁时，不能设定超时
    3. 每个锁仅有单一的条件，可能是不够的
    4. 最好既不使用Lock/Condition也不使用synchronized关键字
    5. 如果synchronized关键字适合你的程序，请尽量使用
    6. 如果特别需要Lock/Condition结构提供的独有特性时，才使用它们
8. 如果向一个变量写入值， 而这个变量接下来可能会被另一个线程读取， 或者，从一个变量读值， 而这个变量可能是之前被另一个线程写入的， 此时必须使用同步
9. 对于实际编程来说，应该尽可能远离底层结构。使用由并发处理的专业人士实现的较高层次的结构要方便得多、 要安全得多

## 第十六章 输入与输出

1. 对于可移植的程序来说, 应该使用程序所运行平台的文件分隔符, 可以通过常量字符串`java.io.File.separator`来获得
2. 应该总是在`InputStreamReader`的构造器中选择一种具体的编码方式，例如：

    ```java
    Reader in = InputStreamReader(new FileInputStream("data.txt"), StandardCharsets.UTF_8);
    ```

3. 在读写文本的时候，应该使用`Charset`对象：`String str = new String(bytes, StandardChatses.UTF_8)`
