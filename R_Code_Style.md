# R code style
> 参考网上各种资料和个人习惯，力求能够写出优雅的 R 代码。

## 一、命名
命名应该简单明了（这并不容易）

### 1. 文件命名
R 代码文件应该以`.R`结尾，例如 `fit-models.R`

如果是一系列连续的代码，可以用数字作为前缀

```
0-download.R
1-parse.R
2-explore.R
```

### 2. 对象命名
**变量** 以下划线`_`分割，避免使用点号`. # R 中 S3 方法的命名规则`及关键字

```
# Good
good_name <- "haha"
# Bad
bad.name <- "No!"
mean <- "God Bless You!"
```

## 二、语法

### 1. 缩进
规范代码，同时也使代码好看

**一般在操作符** `e.g. =, +, -, *, /, <-, etc.`两边加入一个空格，`:, ::, :::`除外；并在逗号后加入一个空格

*个人习惯：对于函数参数，只在`=`右侧加空格

```
average <- mean(feet / 12 + inches, na.rm= TRUE)
x <- 1:10
base::get
```

### 花括号
`if...else`以及`function`格式

```
# 其他人
if (y == 0) {
  log(x) # 表达式前面有两个空格
} else {
  y ^ x
}
# 个人习惯
if(y == 0){
  log(x) # 表达式前面有两个空格
}else{
  y ^ x
}
```

**注意** 每行命令最好不超过 80 个字符，如果代码过长，使用缩进解决

```
long_function_name <- function(a = "a long argument", 
                               b = "another argument",
                               c = "another long argument") {
  # As usual code is indented by two spaces.
  print(a)
  print(b)
  print(c)
}
```

## 代码结构化
通过空行以及注释行分割不同目的的代码

```
# load data -----------------
code

# plot data -----------------
code
```


