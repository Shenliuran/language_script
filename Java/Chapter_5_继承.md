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

## equals方法

+ 本方法用于检测一个对象是否等于另一个对象，在Object类中，这个方法将判断两个对象是否具有相同的引用。
+ Java语言规范要求equals方法具有下面的特性：
  1. 自反性： x.equals(x) return true;
  2. 对称性： 如果 x.equals(y) return true, 那么 y.equals(y) return true;
  3. 传递性： 如果 x.equals(y) return true, 并且 y.equals(z) return true, 那么 x.equals(y) return true;
  4. 一致性： 如果x和y引用对象没有发生变换，反复调用x.equals(y)应该返回相同的结果
  5. 对于任意非空引用x，x.equals(null)应该返回false
+ 