# 第三章 共享对象

## 可见性

### 过期数据

+ 线程安全地访问

    ```java
    @ThreadSafe
    public class SynchronizedInteger {
        @GuardedBy("this") private int value;

        public synchronized int get() { return value; }
        public synchronized void set(int value) { this.value = value; }
    }
    ```

### 非原子的64位操作

+ Java存储模型要求数据的获取和存储操作都为原子的
+ 对于非`volatile`的`long`或`double`变量，JVM允许将64位的读或写划分成两个32位的操作，这会使得在多线程中操作可变的long和double变量，出现线程安全问题
+ 需要使用volatile关键字或使用锁保护起来

### 锁和可见性

+ 锁不仅仅是关于同步与互斥，也是关于内存可见的。为了保证所有线程都能够看到共享的、可变变量的最新值，读取和写入进程必须使用公共的锁进行同步

### volatile变量

+ volatile变量是一种同步的弱形式
+ 它确保一个变量的更新以可预见的方式告知其他线程
+ 当一个域声明为volatile类型后，编译器与运行时会监视这个变量：它是共享的，而且对它的操作不会与其他的内存操作一起被重排序
+ volatile变量不会缓存在寄存器或者其他处理器隐藏的地方
+ 读一个volatile类型的变量时，总会返回由某一线程所写入的最新值
+ 访问volatile变量的操作不会加锁，因此不会引起线程阻塞
+ 不推荐过度依赖volatile变量，过度使用会使得代码更加脆弱、更难理解
+ 正确使用volatile变量的方式包括：
    1. 用于确保它们所引用的对象状态的可见性
    2. 用于标识重要的生命期时间（比如初始化或关闭）的发生
+ 读取volatile变量的开销只会比非volatile变量的开销略高
+ 通常被当作标识 *完成*、*中断*、*状态*的标记使用
+ 加锁可以保证可见性和原子性，但是 **volatile变量值能保证可见性**
+ 使用volatile变量的条件：
    1. 写入变量时并不依赖变量的当前值；或者能够确保只有单一线程修改变量的值
    2. 变量不需要与其他的状态变量共同参与不变约束
    3. 访问变量时，没有其他的原因需要加锁

## 发布和逸出

+ 发布（publishing）：使一个对象能够被当前范围之外的代码所使用，例如：

    ```java
    //发布一：将对象的应用存储到公共静态域中
    public static Set<Secret> knownSecrets;
    public void initialize() {
        knownSecrets = new HashSet<Secret>();
    }

    //发布二：发布一个对象会间接地发布其他对象
    class UnsafeStates {//不建议这样使用
        private String[] states = new String[] { "AK", "AL", ...};
        public String[] getStates() { return states; }
    }

    //发布三：发布一个内部类实例
    public class ThisEscape {//不建议这样使用
        public ThisEscape(EventSource source) {}
        source.registerListener(
            new EventListener() {
                public void onEvent(Event e) {
                    doSomething(e);
                }
            }
        );
    }
    ```

+ 发布一个对象，同样也发布了该对象所有非私有域所应用的对象
+ 在一个已经发布的对象中，那些非私有域的引用链，和方法调用链中的可获得对象也都会被发布
+ 使用封装的强制原因：封装使得程序的正确性分析变得更可行，而且更不易偶然地破坏设计约束

### 安全构建的实践

+ 导致this引用在构造期间逸出的常见错误，是在构造函数中启动一个线程。当对象在构造函数中创建一个线程时，无论是显示地（通过它传给构造函数）还是隐式地（因为Thread或Runnable所属地对象是内部类），this引用几乎总是被新线程共享
+ 在构造函数中创建线程并没有错误，但是最好不要立即启动它，应该使用一个start或initialize方法来启动对象拥有的线程
+ 如果想在构造函数中注册监听器或是启动线程，可以使用一个私有的构造函数和一个公共的工厂方法，以避免不正确的创建，例如：

    ```java
    //使用工厂方法防止this引用在构造期间逸出
    public class SafeListener {
        private final EvenListener listener;

        private SafeListener() {
            listener = new EventListener() {
                public void onEvent(Event e) {
                    doSomething(e);
                }
            };
        }

        public static SafeListener newInstance(EventSource source) {
            SafeListener safe = new SafeListener();
            source.registerListener(safe.listener());
            return safe;
        }
    }
    ```

## 线程封闭

+ 线程封闭（Thread confinement）技术是实现线程安全的最简单的方式之一
+ 当对象封闭在一个线程中时，这种做法会自动成为线程安全的，即使被封闭的对象本身不是线程安全的

### Ad-hoc线程限制

+ 这种线程限制是指：维护线程限制性的任务全部落在实现上

### 栈限制

+ 栈限制是线程限制的一种特例，在栈限制中，只能通过本地变量才能触及对象
+ 栈限制也称线程内部或者线程本地用法
+ 与ad-hoc线程限制相比，更容易维护、更健壮

### ThreadLocal

+ 这是一种维护线程限制的更加规范的方式
+ ThreadLocal提供了get和set访问器，为每个使用它的线程维护一份单独的拷贝
+ 线程本地（ThreadLocal）变量通常用于防止在基于可变的单体（Singleton）或全局变量的设计中，出现（不正确的）共享
+ 实例：

    ```java
    //使用ThreadLocal确保线程封闭性
    private static ThreadLocal<Connection> connectionHolder
        = new ThreadLocal<Connection>() {
            public Connection initiaValue() {
                return DriverManager.getConnection(DB_URL);
            }
        };

    public static Connection getConnection() {
        return connectionHolder.get();
    }
    ```

+ 这项技术还用于下面的情况：一个频繁执行的操作既需要向buffer这样的临时对象，同时还需要避免每次都重新分配该临时对象
+ 可以将`ThreadLocal<T>`看作`Map<Thread, T>`它存储了与线程相关的值
