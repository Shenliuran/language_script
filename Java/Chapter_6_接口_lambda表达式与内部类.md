# 第六章 接口、lambda表达式与内部类

+ 接口中的域将被自动设置为**public static final**
+ 可以为接口方法提供一个默认实现。必须使用default修饰符标记这样一个方法，如：

    ```java
    public interface Comparable<T> {
        default int compareTo(T other) { return 0; } //By default, all elements are the same
    }
    ```

## 接口

### 解决默认方法冲突

+ 如果现在一个接口中将一个方法定义为默认方法，然后又在超类或另一个接口中定义了同样的方法，解决二义性的方法如下：
    1. 超类优先
