# 第三章 MySQL支持的数据类型

## 数值类型

+ MySQL中的数值类型</br>
    1. 整数
        >整数类型|字节|最小值|最大值
        >|:----|:--|:-----|:---|
        >tinyint|1|signed: -128</br>unsigned: 0|signed: 127</br>unsigned: 255
        >smallint|2|signed: -32768</br>unsigned: 0|signed: 32767</br>unsigned: 65535
        >int、integer|4|signed: -8388608</br>unsigned: 0|signed: 8388607</br>1677215
        >bigint|8|signed:-9223372036854775808</br>unsigned: 0|signed: 9223372036854775807</br>unsigned: 18446744073709551615
    2. 浮点数
        >浮点数类型|字节|最小值|最大值
        >|:----|:--|:-----|:---|
        >float|4|$\pm$ 1.175494351E-38</br>|$\pm$ 2.2250738585072014E-308
        >double
