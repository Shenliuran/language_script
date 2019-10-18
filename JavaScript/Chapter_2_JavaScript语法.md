# 第二章 JavaScript语法

## 准备工作

+ 编写前期准备代码：

    ```html
    <!DOCTYPE html>
    <html lang = "en">
    <head>
        <meta charset="utf-8">
        <title>Example</title>
    </head>
    <body>
        Mark-up goes here...
        <script src="file.js"></script>
    </body>
    </html>
    ```

    这是浏览器加载最快的方法

+ JavaScript是弱类型语言，这意味着程序员可以在任何阶段改变变量的数据类型

### 数据类型

+ 字符串

    ```javascript
    //method 1
    var mood = 'don\'t ask';
    //method 2
    var height = "about 5'10\" tall";
    ```

+ 数组

    ```javascript
    //method 1
    var beatles = Array(4);
    //method 2
    var beatles = Array("John", "Paul", "George", "Ringo");
    //method 3
    var beatles = ["John", "Paul", "George", "Ringo"];
    //method 4
    var lennon = ["John", 1940, false];
    //关联数组 （键值对）
    var lennon = Array();
    lennon["name"] = "John";
    lennon["year"] = 1940;
    lennon["living"] = false;
    ```

### 对象

+ 创建对象

    ```javascript
    //method 1
    var lennon = Object();
    lennon.name = "John";
    lennon.year = 1940;
    lennon.living = false;
    //method 2
    var lennon = { name:"John", year:1940, living:false };
    ```

### 条件语句

+ 比较操作符
    1. `==`操作符无法比较空串 ""和false，`"" == false` 返回`true`如果要比较，需要使用`===` （**全等操作符**，**严格相等**）。`!==`严格不相等

## 函数

+ 函数定义：使用`function`关键字定义函数

    ```javascript
    function shout() {
        var beatles = Array("John", "Paul", "George", "Ringo");
        for (var count = 0; count < beatles.length; count++) {
            alert(beatles[count]);
        }
    }
    ```
