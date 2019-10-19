# 第三章 MySQL中的运算符

## 算术运算符

+ MySQL支持的算术运算符
    >算术运算符|作用
    >|:------|:---|
    >+|加法
    >-|减法
    >*|乘法
    >/，div|除法，返回商
    >%，mod|除法，返回余数

+ 比较运算符
    >运算符|作用
    >|:---|:--|
    >=|等于
    ><>或!=|不等于
    ><=>|NULL 安全的等于(NULL-safe)
    ><|小于
    ><=|小于等于
    >>|大于
    >>=|大于等于
    >between|存在与指定范围
    >in|存在于指定集合
    >is null|为 NULL
    >is not null|不为 NULL
    >like|通配符匹配
    >regexp 或 rlike|正则表达式匹配

    1. between运算符的使用格式：`a BETWEEN min AND max`等价于`a >= min AND a <= max`
    2. in运算符的使用格式：`a in (value1, value2, ..., valuen)`
    3. is null运算符的使用格式：`a is null`
    4. like运算符的使用格式为：`a like %123%`
    5. regexp运算符的使用格式为`str regexp str_pat`
