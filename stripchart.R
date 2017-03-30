###############################
### boxplot + stripchart    ###
###############################
### 首先看几个例子
### 第一个例子实际上是很多人经常需求的，即boxplot上显示散点图
x <- rnorm(10)
y <- rnorm(15)
xy <- c(list(x), list(y))
boxplot(xy)
# 参数add= TRUE, 可以看出该函数也是个初级函数
stripchart(xy, method= "jitter", vertical= T, add= T)

### 第二个例子是只画散点，但是要加上均值：stripchart加均值线
x <- rnorm(100)
y <- rnorm(150)
xy <- c(list(x), list(y))
mean_x <- mean(x)
mean_y <- mean(y)
# 参数method= "jitter"，并使用pch改变点的形状
stripchart(xy, method= "jitter", vertical= T, pch= c(21, 24))
# 添加均值线，其中标签的x坐标是1和2，所以添加就容易了
lines(x=c(1 - .1, 1+ .1),y= c(mean_x, mean_x), lwd= 2, col= "red")
lines(x=c(2 - .1, 2+ .1),y= c(mean_y, mean_y), lwd= 2, col= "red")

###--- stripchart函数解析 ---
# stripchart是graphics基础包中的函数，用来绘制一维散点图。
# 帮助文档描述中也提到，当数据量足够小时，可以用来替代boxplot。
# 关键参数：
#      1. method
#         该参数控制点的排布方式，配合jitter参数使用。
#         当method= "jitter"，点的排布开始颤抖，不再如method= "overlap"时排布在一条线上。
#         参数jitter越大，点颤动幅度越大；当method= "jitter", jitter= 0，效果同method= "overlap"。
#      e.g.
z <- rnorm(10)
stripchart(z, method= "jitter", jitter= 0, pch= 1)
stripchart(z, method= "jitter", jitter= .1, col= "red", pch= 2, add= T)
stripchart(z, method= "jitter", jitter= .5, col= "blue", pch= 3, add= T)
stripchart(z, method= "jitter", jitter= 1, col= "green", pch= 4, add= T)
#      2. vertical
#         该参数控制点排布的方向，是水平还是垂直。
#      3. x/data
#         x一般是数字向量，或者包含多个数字向量的列表，就如上面的第二个示例。
#         data一般是数据库或者列表，用于y~g形式的公式，表示根据g分组对y进行绘图。
#      e.g.
y <- rnorm(25)
g <- sample(1:3, 25, replace= T)
yg <- data.frame(value= y, group= g)
stripchart(value~group, yg, method= "jitter", vertical= T)
#      4. group.names
#         很明显，是用来该分组标签名字的，与另一个参数dlab相似。
