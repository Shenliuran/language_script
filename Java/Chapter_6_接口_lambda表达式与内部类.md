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
    1. 超类优先。如果超类提供了一个具体的方法，同名而且有相同参数类型的默认方法会被忽略
    2. 接口冲突。如果一个超类提供了一个默认方法，另一个接口提供了一个同名而且参数类型（不论是否是默认参数）相同的方法，必须覆盖这个方法来解决冲突

### Comparator接口

+ Comparator和Comparable接口的区别在于，实现Comparator接口的类，被称作比较器，通过比较器间接的传入到Arrays.sort()中，可以解决一些像String类这种，不能被继承的类的比较问题

### 对象克隆

+ 如果希望copy是一个新对象，它的初始状态与original相同，但是之后它们各自会有自己不同的状态，在这种情况下就可以使用克隆
+ 默认的克隆操作是“浅克隆”，即不会克隆被克隆对象中的子对象

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

+ 所有数组类型都有一个public的clone方法，而不是protected。可以用这个方法建立一个新数组，包含原数组所有元素的副本

## lambda表达式

+ lambda（λ）表达式就是一个代码块，以及必须传入代码的变量规范
+ lambda表达式的形式：*参数*，*箭头（->）* 以及 *一个表达式*。如果代码要完成的计算无法放在一个表达式中，就可以像写方法一样，把这些代码放在“{ }”中，**并显式包含显式的return语句**, **如果只有一条语句，则可以将“{ }”省略**。如：

    ```java
    (String first, String second) -> {
        if (first.length() < second.length())       return -1;
        else if (first.length() > second.length())  return 1;
        else                                        return 0;
    }
    ```

+ 即使lambda表达式没有参数，仍要提供空括号，就像无参数方法一样：

    ```java
    () -> {
        for (int i = 100; i >= 0; i++)
            System.out.println(i);
    }
    ```

+ 如果可以推导出一个lambda表达式的参数类型，则可以忽略其类型。如：

    ```java
    Comparator<String> comp = (first, second) -> {
        first.length() - second.length();
    }
    ```

+ 如果方法只有一个参数，而且这个参数可以推导得出，那么甚至可以省略小括号：

    ```java
    ActionListener listener = event -> System.out.println("The time is " + new Date());
    // Instead of (event) ->...
    //or (ActionListener event) ->...
    ```

+ 无需指定lambda表达式的返回类型。lambda表达式的返回类型总是会由上下文推导出得出。例如：

    ```java
    (String first, String second) -> first.length() - second.length();
    ```

+ 如果一个lambda表达式只在某些分支返回一个值，而在另外一些分支不返回值，这是不合法的。如：

    ```java
    (int x) -> { if (x >= 0) return 1;}
    ```

    就是不合法的

### 函数式接口

+ 对于只有一个抽象方法的接口，需要这种接口的对象时，就可以提供一个lambda表达式。这种接口称为**函数式接口**
+ 最好把lambda表达式看作是一个函数，而不是一个对象，另外要接受lambda表达式可以传递到函数式接口。lambda表达式可以转化为接口
+ java.util.function包中有一个尤其有用的接口Predicate：

    ```java
    public interface Predicate<T> {
        boolean test(T t);
        //Additional default and static methods
    }
    ```

    ArrayList类有一个removeIf方法，它的参数就是一个Predicate。这个接口专门用来传递lambda表达式。例如下面的语句将从一个数组列表中删除所有null值：

    ```java
    list.removeIf(e -> e == null);
    ```

### 方法引用

+ 要用“::”操作符分隔方法名与对象或类名。主要有三种情况：

    ```java
    1. object::instanceMethod
    2. Class::staticMethod
    3. Class::instanceMethod
    ```

+ 前面两种情况等价于提供方法参数的lambda表达式：

    ```java
    System.out::println /*<==>*/ x -> System.out.println(x);
    Math::pow /*<==>*/ (x, y) -> Math.pow(x, y);
    ```

+ 第三种情况，第一个参数会成为方法的目标，如：

    ```java
    String::compareToIgnoreCase /*<==>*/ (x, y) -> x.compareToIgnoreCase(x);
    ```

+ 可以在方法引用中使用this参数

    ```java
    this::equals() /*<==>*/ x -> this.equals(x)
    ```

+ 使用super也是合法的如：super::instanceMethod

### 构造应用

+ 构造器引用和方法引用很类似，只不过方法名为new，例如Person::new, 使哪个构造器，取决于上下文
+ 可以用数组类型建立构造器引用。例如int[]::new, 它用一个参数：数组长度。`int[]::new -> new int[x];`

### 变量作用域

+ lambda表达式传值实例：

    ```java
    public static void repeatMessage(String text, int delay) {
        ActionListener listener = event -> {
            System.out.println(text);
            Toolkit.getDefaultToolkit().beep();
        };
        new Timer(delay, listener).start();
    }
    // 调用示例：
    repeatMessage("Hello", 1000);//Prints Hello every 1000 milliseconds
    ```

+ lambda表达式中，只能引用值不会改变变量

    ```java
    public static void contDown(int start, int delay) {
        ActionListener listener = event -> {
            start--;//Error: Can't mutate captured variable
            System.out.println(start);
        };
        new Timer(delay, listener).start();
    }
    ```

+ lambda表达式中引用变量，而这个变量可能在外部改变，这也是不合法的。例如：

    ```java
    public static void repeat(String text, int count) {
        for (int i = 1; i <= count; i++) {
            ActionListener listener = event -> {
                System.out.println(i + ": " + text);//Error:Cannot refer to changing i;
            };
        }
        new Timer(1000, listener).start();
    }
    ```

+ lambda表达式的3个部分
    1. 一个代码块
    2. 参数
    3. 自由变量的值，这是指 **非参数而且不在代码中定义的变量**（上文的“Hello”就是自由变量）
+ 规则：lambda表达式中捕获的 **变量必须实际上是最终变量（effectively final）** 。最终变量是指， **这个变量初始化之后就不会再为它赋新值**。
+ lambda表达式中声明与一个局部变量同名的参数或局部变量是不合法的：

    ```java
    Path first = Paths.get("/usr/bin");
    Comparator<String> comp = (first, second) -> first.length() - second.length();//Error:variable first already defined
    ```

+ 在lambda表达式中this的含义并没有变化

### 处理lambda表达式

+ 使用lambda表达式的重点是 **延迟执行（deferred execution）**。之所以希望以后再执行代码，有很多原因：
    1. 在一个单独的线程中运行代码
    2. 多次运行代码，如：

        ```java
        repeat(10, () -> System.out.println("Hello World"));
        ```

        接受这个lambda表达式，需要选择（偶尔可能需要提供）一个函数式接口。如，可以使用Runnable接口：

        ```java
        public static void repeat(int n, Runnable action) {
            for (int i = 0; i < n; i++) action.run();
        }
        ```

        需要说明，**调用action.run()是会执行这个lambda表达式的主体**

    3. 在算法的适当位置运行代码（例如，排序中的比较操作）
    4. 发生某种情况时执行代码（如，点击一个按钮，数据到达）
    5. 只在必要时才运行代码

+ 常用函数式接口

>函数式接口|参数类型|返回类型|抽象方法名|描述|其他方法
>|:-----:|:-----:|:----:|:-------:|:-:|:----:|
>Runnable|无|void|run| 作为无参数或返回值的动作运行
>Supplier< T >|无|T|get|提供一个T类型的值
>Consumer< T >|无|accept|处理一个T类型的值| andThen
>BiConsumer< T, U >|无|void|accept|处理T和U类型的值|andThen
>Function< T, R >|T|R|apply|有一个T类型的值|compose，andThen，identity
>BiFunction< T, U, R>|T，U|R|apply|有T和U类型参数的函数|andThen
>UnaryOperator< T >|T|T|apply|类型T上的一元操作符|compose，andThen，identity
>BinaryOperator< T >|T，T|T|apply|类型T上的二元操作符|andThen，maxBy，minBy
>Predicate< T >|T|boolean|test|布尔函数|and，or，negate，isEqual
>BiPredicate< T, U >|T，U|boolean|test|有两个参数的布尔值函数|and，or，negate

+ 基本类型函数接口

>函数式接口|参数类型|返回类型|抽象方法名
>|:-----:|:-----:|:-----:|:-----:|
>BooleanSupplier|none|boolean|getAsBoolean
>PSupplier|none|p|getAsP
>PConsumer|p|void|accept
>PFunction< T >|p|T|apply
>ObjPConsumer< T >|T,p|void|accpet
>PToQFunction|p|q|applyAsQ
>ToPFunction< T >|T|p|applyAsP
>TOPBiFunction< T, U >|T,U|p|applyAsP
>PUnaryOperator|p|p|applyAsP
>PBinaryOperator|p,p|p|applyAsP
>PPredicate|p|boolean|test
>注释：p,q为int，long，double；P，Q为Integer，Long，Double

+ 如果设计的接口，其中只有一个抽象方法，可以用`@FunctionalInterface`注解来标记这个接口
