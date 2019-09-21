# 第五章 继承

## super关键字

+ super不是一个对象的引用，不能将super赋给另一个对象变量，它只是一个指示编译器调用超类方法的特殊关键字

## 多态

### 方法调用

1. 方法的名字和列表参数称为 **方法的签名**，但是*返回类型不是签名的一部分* </br>
2. ***在覆盖一个方法的时候，子类方法不能低于超类的可见性。特别是超类方法是瀑布public，子类的方法一定要声明为public。***
3. 如果将一个类声明为final，只有其中的方法自动地成为final，而不包括域

### 强制类型转换

+ 进行类型转换的***唯一原因***是：在暂时忽略对象的实际类型之后，使用对象的全部功能

### 受保护的访问（protected关键字）

+ protected对本包可见的意思是：如果在同一个包下，子类可以访问超类protected域，但是在跨包的情况下，子类就不能再访问父类的protected域了

## Object超类

### equals方法

+ 本方法用于检测一个对象是否等于另一个对象，在Object类中，这个方法将判断两个对象是否具有相同的引用。
+ Java语言规范要求equals方法具有下面的特性：
  1. 自反性： x.equals(x) return true;
  2. 对称性： 如果 x.equals(y) return true, 那么 y.equals(y) return true;
  3. 传递性： 如果 x.equals(y) return true, 并且 y.equals(z) return true, 那么 x.equals(y) return true;
  4. 一致性： 如果x和y引用对象没有发生变换，反复调用x.equals(y)应该返回相同的结果
  5. 对于任意非空引用x，x.equals(null)应该返回false

### toString方法

+ 打印数组可以使用Arrays.toString()；
+ 打印多维数组可以使用Arrays.deepToString()；

### 自动装箱

+ 如果想写一个修改数值参数值的方法，就需要使用org.omg.CORBA包中定义的持有者（holder）类型，包括IntHolder、BooleanHolder等，如：

    ```java
    public static void triple(IntHolder x) {
        x.value = 3 * x.value;
    }
    ```

## 反射

### Class类

+ 将forName与newInstance配合起来使用，可以根据储存在字符串中的类名创建一个对象如：

    ```java
    String s = "java.util.Random";
    Object m = Class.forName(s).newInstance();
    ```

+ 几种常用的get方法：
  + Field对象：
    1. getFields()，记录了这个类或其超类的**公用域**
    2. getDeclaredFields()，记录了这个类的**全部方法**
  + Method对象：
    1. getMethods()，返回所有的**公有方法**，*包括从超类中继承来的公用方法*
    2. getDeclaredMethods()，返回这个*类或接口*的**全部方法**，*但不包括有超类继承的方法*
  + Constructor对象：
    1. getConstructors()，描述的类的所有**公有**构造器
    2. getDeclaredConstructors()，**所有构造器**

+ 建议Java开发者不要使用Method对象的回调功能。使用接口进行回调会使得代码的执行速度更快，更易于维护
