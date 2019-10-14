# 第三章 进程同步与通信

## 进程的同步与互斥

### 进程同步的基本概念

+ 同步：指多个进程中发生的事件存在着某种时序关系，它们必须按规定时序执行
+ 互斥：多个进程不能同时使用一个资源

### 临界资源与临界区

+ 临界资源：某段时间内仅允许一个进程使用的资源
+ 临界区：每个进程中访问临界资源的那段代码
+ 访问临界资源的进程描述：

    ```java
    while (true) {
        进入区:
            // 空闲让进：临界资源处于空闲状态，允许程序进入临界区
            // 忙则等待：临界区正在被访问，其他进程必须等待
            // 有限等待：对于要求访问临界资源的进程，应保证在有效的时间内进入
            // 让权等待：等进程不能进入临界区时，应立即释放处理机
        临界区
        退出区
        剩余区
    }

### 互斥实现的硬件方法

+ 禁止中断
+ 专用机器指令
    1. TS（Test and Set）指令
    2. Swap（Exchange）指令
+ 硬件方法的缺点：
    1. 不能做到“让权等待”
    2. 有死锁的可能
    3. 容易产生“饥饿现象”

### 互斥现象的软件方法

+ 单标志算法

    ```java
    //进程0
    while (turn != 0) {
        //do nothing;
        临界区；
        turn = 1;
        剩余区；
    }
    //进程1
    while (turn != 1) {
        //do nothing;
        临界区；
        turn = 0;
        剩余区；
    }
    ```

    缺点：不能做到“空闲让进”
+ 双标志，先检查算法

    ```java
    //进程0
    while (flag[1]) {
        //do nothing;
        flag[0] = true;
        临界区；
        flag[0] = false;
        剩余区；
    }
    //进程1
    while (flag[0]) {
    //do nothing;
        flag[1] = true;
        临界区；
        flag[1] = false;
    }
    ```

    缺点：不能保证  ‘忙则等待’
+ 双标志，先修改后检查算法

    ```java
    //进程0
    flag[0] = true;
    while (flag[1]) {
    //do nothing;
        临界区；
        flag[0] = false;
        剩余区；
    }
    //进程1
    flag[1] = true;
    while (flag[0]) {
        //do nothing;
        临界区；
        flag[1] = false;
        剩余区；
    }
    ```

    缺点：不能保证‘空闲让进’
+ 先修改，后检查，后修改算法

    ```java
    //进程0
    turn = 1;
    while (flag[1] && (turn == 1)) {
        //do nothing;
        临界区；
        flag[0] = false;
        剩余区；
    }
    //进程1
    flag[1] = true;
    turn = 0;
    while (flag[0] && (turn  ==  0)) {
        //do nothing;
        临界区；
        flag[1] = false;
        剩余区；
    }
    ```

    保证了  ‘空闲让进’和‘忙则等待’

### 信号量和PV操作

+ 信号灯机制
+ 记录型信号灯的定义

    ```cpp
    struct semaphore {
        int value;
        struct PCB * queue;
    }
    ```

+ 信号灯的PV操作

    ```cpp
    void wait(semaphore s) {
        s.value = s.value + 1;
        if (s.value < 0)
            block(s.queue);//将进程阻塞，并将其投入等待队列s.queue;
    }

    void signal(semaphore s) {
        s.value = s.value + 1;
        if (s.value <= 0)
            wakeup(s.queue);//唤醒阻塞进程，将其从等待队列s.queue取，投入就绪队列出
    }
    ```

    `s.value`：初值表示系统中的某种资源数目
    `wait(s)`：表示要申请一个资源
    `signal(s)`：表示进程释放一个资源
    `s.value < 0`：|s.value|表示等待队列的进程数

    ```cpp
    semaphore mutex = 1;
    P1:
        while (true) {
            wait(mutex);
            临界区；
            signal(mutex);
            剩余区；
        }
    P2:
        while (true) {
            wait(mutex);
            临界区；
            signal(mutex);
            剩余区；
        }
    ```

## 经典的进程同步问题

+ 生产者——消费者问题
    1. 问题定义：两个进程共享一个环形缓冲池，一组进程称为生产者，另一组称为消费者
    2. 问题分析：生产者和消费者需要同步，生产者（消费者）之间需要同步
    3. 代码分析：

        ```cpp
        semaphore mutex = 1;
        semaphore empty = n;
        semaphore full = 0;

        void producer() {
            while (true) {
                produce an item in data_p;
                P(empty);
                P(mutex);
                buffer[i] = data_p;
                i = (i + 1) % n;
                V(mutex);
                V(full);
            }
        }

        void consumer() {
            while (true) {
                P(full);
                P(mutex);
                data_c = buffer[j];
                j = (j + 1) % n;
                V(mutex);
                V(empty);
                consume the item in data_c;
            }
        }

    4. 应该先进行资源的P操作，再进行控制权的P操作

+ 读者——写者问题
    1. 代码分析：

        ```cpp
        semaphore wMutex, rMutex = 1;
        int rCount;

        void reader() {
            while (true) {
                P(rMutex);
                if (rCount == 0) P(wMutex);
                rCount = rCount + 1;
                read();
                P(rMutex);
                rCount = rCount - 1;
                if (rCount == 0) V(wMutex);
                V(rMutex);
            }
        }

        void writer() {
            while (true) {
                P(wMutex);
                write();
                V(wMutex);
            }
        }
        ```

        以上是读者优先策略
+ 哲学家进餐问题
    1. 代码分析：

        ```cpp
        semaphore chopstick[] = { 1, 1, 1, 1, 1};
        void philosopher(int i) {
            while (true) {
                P(chopstick[i]);
                P(chopstick[i + 1] % chopstick.length);
                eating;
                V(chopstick[i]);
                V(chopstick[i + 1] % chopstick.length);
                thinking;
            }
        }
        ```

+ 打瞌睡的理发师问题
    1. 代码分析：

        ```cpp
        #define CHAIRS 5
        semaphore customers = 0;
        semaphore barbers = 0;
        semaphore mutex = 1;
        int waiting;

        void barber() {
            while (true) {
                P(customers); //如果没有顾客，理发师就打瞌睡
                P(mutex);
                waiting--;
                V(barbers); //理发师准备理发
                V(mutex);
                cut_hair(); //理发
            }
        }

        void customer() {
            P(mutex);
            if (waiting < CHAIRS) { //如果有空位，则顾客等待
                waiting++;
                V(customers); //如果有必要，唤醒理发师
                V(mutex);
                P(barbers); //如果理发师正在理发，则顾客等待
                get_haircut();
            }
            else //如果没有空位，顾客离开
                V(mutex);
        }

## AND信号量

+ 用AND信号量解决哲学家进餐问题

    ```cpp
    semaphore chopstick[5] = {1, 1, 1, 1, 1};
    void philosopher(int i) {
        while (true) {
            Swait(chopstick[i], chopstick[(i + 1) % 5]);
            eat();
            Ssingal(chopstick[i], chopstick[(i + i) % 5]);
            think();
        }
    }
    ```

## 管城

+ 面向对象的概念
+ 定义：一个数据结构和能为并发进程所执行的一组操作：`管程 = 数据结构 + 操作 + 对数据结构的初始化`

## 进程通信

+ PV操作属于低级通信
+ 高级通信：
    1. 共享存储系统
    2. 消息通信系统：直接通信方式、间接通信方式
    3. 管道通信
+ 通信链路的建立方式
+ 通信方向
+ 通信链路的连接方式
+ 通用的通信方式：命名管道、套接字、远程过程调用
