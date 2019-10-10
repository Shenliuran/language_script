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
