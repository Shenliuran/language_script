# 第七章 异常、断言和日志

+ 所有异常都是由Throwable继承来的，下一层分解为Error和Exception:

    ![avatar](../images/Java中的异常层次结构.png)

+ 应用程序不应该抛出Error类型的对象
+ 由于程序错误导致的异常属于RuntimeException
+ 由于像I/O错误这类问题导致的异常属于其他异常
+ 派生于RuntimeException的异常包含下面几种情况：
    1. 错误的类型转换：`ClassCastException`
    2. 数组访问越界：`ArrayIndexOutOfBoundsException`
    3. 访问null指针：`NullPointerException`
+ 不是派生于RuntimeException包括：
    1. 试图在文件尾部后面读取数据：`EOFException`
    2. 试图打开一个不存在的文件：`FileNotFoundException`
    3. 试图根据给定的字符串查找Class对象，而这个字符串表示的类并不存在：`ClassNotFoundException`
+ 对于一个已经存在的异常类，在这种情况下：
    1. 找到一个合适的异常类
    2. 创建这个类的对象
    3. 将这个对象抛出</br>
    一旦方法抛出异常，这个方法就 **不可能返回调用者**。也就是说，**不必写返回值（也不能写返回值）**
+ 合并catch子句：

    ```java
    try {
        //code that might throw exceptions
    } catch (FileNotFoundException | UnknownHostException e) {
        //emergency action for missing files and unknown hosts
    } catch (IOException e) {
        //emergency action for all other I/O problems
    }
    ```

    只有当捕获的异常类型彼此之间不存在子类关系时才需要这个特性
+ 捕获多个异常时，异常变量隐含着final变量，即 `e` 不能被赋值
