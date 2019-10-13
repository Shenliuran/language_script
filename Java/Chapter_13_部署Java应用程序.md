# 第十三章 部署Java应用程序

## JAR文件

+ 创建jar文件
    1. 常用命令：`jar cvf jarfilename file1 file2 ...`
+ 清单文件
    1. 清单文件被命名为`MANIFEST.MF`，位于jar文件的`META-INF`子目录中
    2. 清单条目被分为很多节，第一节称为主节（main section），作用域整个jar文件
    3. 节与节之间用空行分隔

        ```txt
        Manifest-Version: 1.0
        描述这个归档文件的行

        Name:Woozle.class
        描述这个文件的行

        Name:com/mycompany/mypkg
        描述这个包的行
        ```

    4. 编辑清单文件，将希望添加到清单文件中的行放到文本文件中，然后运行：`jar cfm jarfilename manifestfilename`
    5. 创建一个包含清单的jar文件，应该运行：`jar cfm MyArchive.jar manifest.mf com/mycompany/mypkg/*.class`
    6. 更新一个已有jar文件的清单，需要将增加的部分放置在一个文本文件中，然后执行命令：`jar ufm MyArchive.jar manifest-additions.mf`
+ 可执行jar文件
    1. 可以使用jar命令中的e选项指定程序入口，即通常需要在调用java程序加载器时指定的类：</br>
        `jar cvfe MyProgram.jar com.mycompany.mypkg.MainAppClass files to add`
    2. 或者在清单中指定应用程序的主类：`Main-Class: com.mycompany.mypkg.MainAppClass`（不要将扩展名`.class`添加到主类）
    3. 最简单的方式是：`java -jar MyProgram.jar`
+ 资源
    1. 利用资源机制，可以操作jar中的非类文件：
        1. 获取具有资源的Class对象
        2. 如果资源是一个图片或时声音，需要调用`getResource(filename)`获取作为URL的资源位置，然后利用`getImage()`或`getAudioClip()`方法进行读取
        3. 利用`getResourceAsStream()`方法读取文件中的数据
+ 密封
    1. 想要密封一个包，需要将包中所有类放到一个jar文件中。默认情况下，jar文件中的包时没有密封的，可以在清单文件的主节中加入下面一行：`Sealed:true`
    2. jar文件中的单独的包密封，可以清单中增加一节：

        ```txt
        Name:com/mycompany/util/
        Sealed:true
        ```

    3. 想要密封一个包，需要创建一个包含清单指令的文本文件，然后用常规的方式运行jar命令：`jar cvfm MyArchive.jar manifest.mf files to add`

## 应用首选项的储存

+ 属性映射
    1. 实现的java类名为：`Properties`
    2. 指定配置文件：

        ```java
        Properties settings = new Properties();
        settings.setProperty("width", "200");
        settings.setProperty("title", "Hello world");
        ```

    3. 使用`store`方法将属性映射列表保存在一个文件中，如保存在program.properties中：

        ```java
        OutputStream out = new FileOutputStream("program.properties");
        settings.store(out, "Program Properties");
        ```

        第二个参数事是对属性的描述

    4. 从文件中加载属性：

        ```java
        InputStream in = new FileInputStream("program.properties");
        settings.load(in);
        ```

+ 首选项API
