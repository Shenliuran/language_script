# 第三章

## 节点

### 获取元素

+ 可以使用`typeof`操作符来返回操作数的类型（字符串、数值、函数、布尔值还是对象）
+ 有三种DOM方法可获取元素节点
    1. `getElementByI(id)`方法：id对应的HTML中的id属性。
    2. `getElementByTagName(tag)`方法：tag对应HTML中的标签，如`body`、`li`等。返回的对象是一个数组：

        ```html
        <!DOCTYPE html>
        <html>
        <head>
            <!--......-->
        </head>
        <body>
            <!--......-->
            <ul>
                <li>A tin of beans</li>
                <li class = "sale">Cheese</li>
                <li class = "sale important">Mil k</li>
            </ul>
            <script src="datatype.js"></script>
        </body>
        </html>
        ```

        ```javascript
        for (var i = 0; i < document.getElementsByTagName("li").length; i++) {
            alert(typeof document.getElementsByTagName("li")[i]);
        }
        ```

        求文档中的所有节点数量：`alert(document.getElementsByTagName("*").length)`
    3. `getElementsByClassName(class)`：类名的实际顺序不重要，即`important sale`和`sale important`表示的是同一个class

## 获取和设置属性

### getAttribute

+ 参数：打算查询的属性的名字：`object.getAttribute(attribute)`
+ 该方法不属于document对象，只能通过元素节点对象调用，如获取每个`<p>`对象的`title`属性，如下：

    ```javascript
    var paras = document.getElementsByTagName("p");
    for (var i = 0; i < paras.length; i++) {
        alert(paras[i].getAttribute("title"));
    }
    ```

+ 在JavaScript里，`null`的含义是 **没有值**

### setAttribute

+ 用来设置属性节点的值：`object.setAttribute(attribute, value)`
