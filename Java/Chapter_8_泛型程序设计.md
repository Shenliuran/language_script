# 第八章 泛型程序设计

+ 泛型类可以看作普通类的工厂
+ 泛型方法可以定义在普通类中，也可以定义在泛型类中
+ 当调用一个泛型方法时，在方法名前的尖括号中放入具体的类型：`String middle = Arraylg.<String>getMiddle("John", "Q", "Public");`</br>
多数情况下，可以省略`<String>`类型参数
+ 限定类型用`&`分隔，逗号用来分隔类型变量
+ 在限定中至多有一个类，如果用一个类作为限定，它必须是限定列表的第一个（对接口没有数量限制）

## 泛型代码和虚拟机

### 类型擦除

+ 无论何时定义一个泛型类型，都自动提供一个相应的 **原始类型** 。原始类型的名字就是删去类型参数后的泛型类型名，如：

    ```java
    public class SomeClass<T> {
        private T field;
        public SomeClass(T field) {
            this.field = field;
        }

        public T getField() { return field; }
        public void setField(T field) { this.field = field; }
    }
    ```

    擦除（erased）类型变量后，替换为限定类型：

    ```java
    public class SomeClass<Object> {
        private Object field;
        public SomeClass(Object field) {
            this.field = field;
        }

        public Object getField() { return field; }
        public void setField(Object field) { this.field = field; }
    }
    ```

    因为T是一个无限定的变量，所以直接用Object替换（称为`SomeClass<T>`的原始类型）
