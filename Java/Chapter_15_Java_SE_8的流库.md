# 第十五章 Java SE 8的流库

## 从迭代到流的操作

+ 流遵循了 **做什么而非怎么做** 的原则
+ 流表面上看起来和集合相似，都可以让我们转化和获取数据，但是它们之间存在着显著的差异：
    1. 流并不储存其他数据
    2. 流的操作不会修改其数据源
    3. 流的操作是尽可能惰性执行的，这意味着直至需要其结果是，操作才会执行

## 流的创建

+ 可以使用`Collection`接口的`stream`方法将任何集合转换成为一个流
+ 使用静态`Stream.of`方法将数组转换成为流
+ 使用`Array.stream(array, from, to)`可以从数组中位于from（包括）和to（不包括）的元素中创建一个流
+ 使用静态`Stream.empty`方法创建一个不包含任何元素的流

## filter、map和flatMap方法

+ filter的引元是`Predicate<T>`，如：`Stream.filter(w -> w.length() > 12);`
+ 通常，我们想要按照某种方式来转换流中的值，此时，可以使用map方法并传递执行该转换的函数如：

    ```java
    Stream<String> lowercaseWords = words.stream().map(String::toLowerCase);
    ```

    通常，我们可以使用lambda表达式代替：

    ```java
    Stream<String> firstLetters = words.stream().map(s -> s.substring(0, 1));
    ```

## 抽取子流和连接流

+ 调用`stream.limit(n)`会返回一个新的流，它在n个元素之后结束（如果原来的流更短，那么就会在流结束时结束），这个方法对于裁剪无限流的尺寸会显得特别有用，例如：

    ```java
    Stream<Double> random = Stream.generate(Math::random).limit(100);
    ```

    产生一个包含100个随机数的流

+ 调用`stream.skip(n)`正好相反：丢弃前n个元素。这个方法在将文本分隔为单词时会显得方便

## 其他转换流

+ `distinct`方法会返回一个流，原来的元素按照同样的顺序剔除重复元素后产生的
+ `sorted`方法用于流的排序
    1. 一种是用于操作Comparable元素
    2. 另一种是接受一个Comparator，如：

        ```java
        Stream<String> longestFirst = words.stream().sorted(Comparator.comparing(String::length)).reversed();
        ```

    3. sorted方法会产生一个新的流
+ `peek`方法会产生另一个流，它的元素与原来的流中的元素相同，但是每次获取一个元素时，都会调用一个函数，如：

    ```java
    Object[] powers = Stream.iterate(1.0, p -> p * 2)
        .peek(e -> System.out.println("Fetching " + e)
        .limit(20).toArray();
    ```

## 简单约简

+ 约简是一种终结操作（terminal operation），它们会将流约简为可以在程序中使用的非流值
+ `count`方法是一个简单约简

## Optional类型

+ `Optional<T>`对象是一种包装器对象，要么包装类型T的对象，要么没有包装任何对象

### 如何使用Optional值

+ 在值不存在情况下会产生一个可替代物：
    1. 可能是空字符串：

        ```java
        String result = optionalString.orElse("");
        //The wrapped string, or "" if none
        ```

    2. 调用代码来计算默认值：

        ```java
        String result = optionalString.orElseGet() -> Locale.getDefault().getDisplayName();
        //The function is only called when needed
        ```

    3. 抛出异常：

        ```java
        String result = optionalString.orElseThrow(IllegalStateException::new);
        //Supply a method that yields an exception object
        ```

+ 在值存在的情况下，才会使用这个值：

    1. `ifPresent`方法会接受一个函数，如果该可选值存在，那么会被传递给该函数。否则不会做任何事：

        ```java
        optionalValue.ifPresent(v -> Process v);
        ```

    2. 在值存在的情况下，想要将其添加到某个集合中，可以调用：

        ```java
        optionalValue.ifPresent(v -> result.add(v));
        //或者直接调用
        optionalValue.ifPresent(result::add);
        ```

    3. 在调用ifPresent时，不会从该函数返回任何值。如果想要处理函数的结果，应该使用map：

        ```java
        Optional<Boolean> added = optionalValue.map(result::add);
        ```

        现在added具有三种值之一：
          + optionalValue存在的情况下包装器在Optional中的true或false
          + optionalValue不存在的情况下的空的Optional

### 不适合使用Optional值的方式

+ `get`方法会在Optional值存在的情况下获取其中包装的元素，或者在不存在的情况下抛出一个`NoSuchElementException`
+ `isPresent`方法会报告某个`Optional<T>`对象是否具有一个值

### 创建Optional值

+ 如果想要编写方法来创建Optional对象，可以使用的方法有：
    1. `Optional.of(result)`
    2. `Optional.empty()`
+ 例如：

    ```java
    public static Optional<Double> inverse(Double x) {
        return x == 0 ? Optional.empty() : Optional.of(1 / x);
    }
    ```

## 收集结果
