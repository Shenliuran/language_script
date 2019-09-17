# 第三章 Java的基本程序设计结构

## 运算符

### 位运算符

+ 与: & <==> and
+ 或: | <==> or
+ 亦或: ^ <==> xor
+ 非: ~ <==> not
+ **左移: >>**
+ **右移: <<**
+ **高位填充0 >>>**

### “==”运算符

>一定不要使用“==”运算符来检测两个字符串是否相等！这个运算符只能确定两个运算符是否放在同一个位置上。当然，如果字符串在同一个位置上，他们必然相等。但是，完全有可能，相同的内容在不同的位置上。</br> **（简而言之，能有用“==”来确定两个字符串的内容是否相等，“==”为真的条件要高于equals()）**

## 码点与代码单元 *(Java核心技术原10版 P50)*

查看码点数量：</br>

```java
String greeting = "Hello";
int n = greeting.length();
int cpCount = greeting.codePointCount(0, greeting.length());
```

查看代码单元：</br>

```java
char first greeting.charAt(x);// 0 <= x < greeting.length()
```

想要得到第i个码点：</br>

```java
int index = greeting.offsetByCodePoints(0, i);
int cp = greeting.codePointAt(index);
```

## 多重选择：switch语句

case标签可以是：</br>

+ 类型为char，byte，short或int的常量表达式
+ 枚举常量
+ 字符串字面量

带标签的break语句：</br>

```java
label: {
    //do something;
    break label;
}
```

## 大数值

+ BigInteger *（整数）*</br>

```java
BigInteger.add(BigDecimal other); //等价于 +
BigInteger.subtract(BigDecimal other); // 等价于 -
BigInteger.multiply(BigDecimal other); // 等价于 *
BigInteger.divide(BigDecimal other, RoundingMode mode); // 等价于 /，mode为四舍五入方式
```

+ BigDecimal *（浮点数 实数）*
