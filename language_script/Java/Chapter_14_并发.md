# 第十四章 并发

## 什么是线程

### 使用线程给其他任务提供机会

+ 在一个单独线程中执行一个任务的简单过程：
    1. 将任务代码移到实现了`Runnable`接口的类中的`run`方法中，这个接口只有一个方法：

        ```java
        public interface Runnable {
            void run();
        }
        ```

        由于Runnable是一个函数式接口，**可以用lambda表达式建立一个实例**：`Runnable r = () -> { task code; }`
    2. 由Runnable创建一个`Thread`对象：`Thread t = new Thread();`，也可以通过构建一个Thread类的子类定义一个线程：

        ```java
        class MyThread extends Thread {
            public void run() {
                task code
            }
        }
        ```

    3. 启动线程：`t.start()`

## 中断线程

+ 当线程的run方法执行方法体中最后一条语句后，并经由执行`return`语句返回时，或者出现了在方法中没有捕获的异常时，线程将终止
+ 没有可以用来强制线程终止的方法
+ `interrupt`方法可以用来请求终止线程，此时线程的 **中断状态** 将被置位。每一个线程都有这样一个boolean标志，以判断线程是否被中断
+ 判断当前线程的中断状态是否被置位：`Thread.currentThread().isInterrupted()`
+ 如果线程被阻塞，就无法检测中断状态
+ 更普遍的情况是，线程将简短地将中断作为一个终止请求，形式如下：

    ```java
    Runnable r = () -> {
        try {
            ...
            while (!Thread.currentThread().isInterrupted() && more work have to be done) {
                //do more work
            }
        } catch (InterruptedException e) {
            //thread was interrupted during sleep or wait
        } finally {
            //cleanup, if required
        }
        //exiting the run method terminates the thread
    };
    ```

+ 如果在中断状态被置位时调用 sleep 方法，它不会休眠。相反，它将清除这一状态（！）并拋出 InterruptedException：

    ```java
    Runnable r = () -> {
        try {
            while (more work have to be done) {
                doing working
                Thread.sleep(delay);
            }
        } catch (InterruptedException e) {
            //thread was interrupted during sleep
        } finally {
            cleanup, if required
        }
        //exiting the run method terminates the thread
    };
    ```

+ `interrupted` 方法是一个 **静态方法**， 它检测当前的线程是否被中断，而且，**会清除该线程的中断状态**
+ `isInterrupted` 方法是一个 **实例方法**，可用来检验是否有线程被中断，**不会改变中断状态**

## 线程状态

+ 创建新线程（New）：`new Thread(r);`，当用new创建一个新线程时，**该线程还没有开始运行**
+ 可运行线程（Runnable）：调用`start`方法，一个可运行的线程 **可能正在运行也可能没有运行**， 这取决于操作 **系统给线程提供运行的时间**。（Java 的规范说明没有将它作为一个单独状态。一个 **正在运行中的线程仍然处于可运行状态** 。）
+ 被阻塞线程和等待线程（Blocked）
    1. 阻塞状态：当一个线程试图获取一个内部的对象锁（而不`java.util.concurrent`库中的锁），而该锁被其他线程持有
    2. 等待状态：当线程等待另一个线程通知调度器一个条件时
    3. 即使等待：这一状态将一直保持到超时期满或者接收到适当的通知。带有超时参数的方法：
        1. `Thread.sleep()`
        2. `Object.wait()`
        3. `Thread.join()`
        4. `Lock.tryLock()`
        5. `Condition.await()`的计时版
+ 被终止的线程（Waiting）：
    1. 线程终止的原因：
        1. run方法正常退出而自然死亡
        2. 没有捕获的的异常终止了run方法而意外死亡

## 线程属性

### 线程优先级

+ Java中，每个线程有一个优先级，默认情况下，一个线程继承它的父类线程的优先级
+ `setPriority`方法设置优先级，可以将优先级设置在`MIN_PRIORITY`（在Thread类中定义为1）与`MAX_PRIORITY`（定义为10），`NORM_PRIORITY`被定义为5
+ 线程优先级是 **高度依赖于系统** 的
+ Java线程的优先级被映射到宿主主机平台的优先级上：
    1. Window有7个优先级
    2. Linux的JVM上，线程优先级被忽略——所有线程具有相同的优先级

### 守护线程

+ 将线程转换为守护线程（daemon thread）：`t.setDaemon(true)`
+ 唯一的用途：**为其他线程提供服务**
+ 当只剩下守护线程是，虚拟机就退出了，这是因为只剩下守护线程，就没有必要继续运行程序了

### 未捕获异常处理器

+ 线程的run方法 **不能抛出任何受查异常**，
+ 在线程死亡之前，异常被传递到一个用于未捕获异常的处理器：
    1. 该处理器实现一个`Thread.UncaughtExceptionHandler`接口，这个接口只有一个方法（函数接口）：</br>
    `void uncaughtException(Thread t, Throwable e)`
    2. 可以用`setUncaughtExceptionHandler`方法为任何线程安装一个处理器
    3. 也可以用`Thread.setDefaultUncaughtExceptionHandler`方法为 **所有线程** 安装一个默认的处理器
    4. 若不安装默认处理器，默认的处理器为空，此时的处理器就是该线程的`ThreadGroup`（线程组）对象
+ 受检查异常：在编译时被强制检查的异常，即在方法的声明中声明的异常
+ 未受检查异常：在方法声明中没有声明，但在方法的运行过程中发生的各种异常，**这种异常是错误**，会被自动捕获

## 同步

### 锁对象

+ 用`ReentrantLock`保护代码块的基本结构如下：

    ```java
    myLock.lock();//a ReentrantLock object
    try {
        critical section
    } finally {
        myLock.unLock();//make sure the lock is unlocked even if an exception is thrown
    }
    ```

    把解锁操作括在 finally 子句之内是至关重要的。如果在临界区的代码抛出异常，锁必须被释放。否则， 其他线程将永远阻塞。
+ 锁是 **可重入**，因为线程可以重复地获得已经持有的锁
+ 要留心临界区中的代码，不要因为异常的抛出而跳出临界区。如果在临界区代码结束之前抛出了异常，finally 子句将释放锁，但会使对象可能处于一种受损状态

### 条件对象

+ 通常， 线程进人临界区，却发现在某一条件满足之后它才能执行。要使用一个条件对象来管理那些已经获得了一个锁但是却不能做有用工作的线程
+ 一旦一个线程调用`await`方法， 它 **进人该条件的等待集**。当锁可用时，该 **线程不能马上解除阻塞**。相反，它处于阻塞状态，直到另一个线程调用同一条件上的`signalAll`方法时为止。

#### 锁和条件的关键

+ 锁是用来保护代码片段，任何时刻只能有一个线程执行被保护的代码
+ 锁可以管理试图进入被保护代码段的线程
+ 锁可以拥有一个或多个相关的条件对象
+ 每个条件对象管理那些已经进入被保护的代码段但还不能运行的线程

### synchronized关键字

+ 如果一个方法用 synchronized关键字声明，那么对象的锁将保护整个方法。也就是说，要调用该方法，线程必须获得内部的对象锁：

    ```java
    public synchronized void method() {
        method body
    }
    ```

    等价于：

    ```java
    public void method() {
        this.intrinsicLock.lock();
        try {
            method body
        } finally {
            this.intrinsicLock.unLock();
        }
    }
    ```

+ 内部对象锁只有一个相关条件
    1. `wait`方法添加一个线程到等待集中，等价于`intrinsicCondition.await()`
    2. `notifyAll()`/`notify()`方法解除等待线程的阻塞状态，等价于`intrinsicCondition.signalAll()`

### 同步阻塞

+ 线程还可以通过进入一个同步阻塞，获得锁：

    ```java
    synchronized (obj) {
        critical section
    }
    ```

    获取obj的锁

+ 客户端锁定（client-side locking）：使用一个对象的锁来实现额外的原子操作
+ 客户端锁定是非常脆弱的，通常不推荐使用

### 监视器概念

+ 特性：
    1. 监视器是只包含私有域的类
    2. 每个监视器类的对象有一个相关的锁
    3. 使用该对象对所有方法进行加锁。如果客户端调用`obj.method()`，那么obj对象的锁是在方法调用开始时就自动获得的，当方法返回时自动释放锁
    4. 该锁可以有任意多个相关条件

### volatile域

+ volatile 关键字为实例域的同步访问提供了一种 **免锁机制**。如果声明一个域为 volatile，那么编译器和虚拟机就知道该域是可能被另一个线程并发更新的
+ Volatile 变量不能提供原子性

### final变量

+ 还有一种情况可以安全地访问一个共享域，即将这个域声明为final，如：`final Map<String, Double> accounts = new HashMap<>();`，其他线程会在构造函数完成构造之后才看到这个accounts变量
+ 但是，对这个映射表的操作不是线程安全的

### 原子性

### 死锁
