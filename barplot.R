###############################
### bar图可能遇到的各种形式    ###
###############################
# 参考 Quick-R: http://www.statmethods.net/graphs/bar.html

###--- 简单情况 --------------------------------------------------
# 基本
counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", xlab="Number of Gears")

# 上图bar太宽，调窄一点。文档也说了width要搭配xlim才能有效果
barplot(counts, main="Car Distribution", xlab="Number of Gears",
        xlim= c(0, 5)
)

# bar图水平放置，使用horiz= TRUE就OK了；标签用参数las改变方向
barplot(counts, main="Car Distribution", horiz=TRUE, las= 1,
        names.arg=c("3 Gears", "4 Gears", "5 Gears"))

# 默认地，barplot并不会画bar的分类坐标，可以使用axis.lty= 1显示出来；
# 控制标签的大小使用cex.names选项，另外还可以用par函数控制画图框位置
par(las=2) # make label text perpendicular to axis
par(mar=c(5,8,4,2)) # increase y-axis margin.
counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", horiz=TRUE, names.arg=c("3 Gears", "4 Gears", "5   Gears"), cex.names=0.8)

###--- 重叠（stacked）-------------------------------------------
# 并附上legend；其实就是数据变换了格式
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
  xlab="Number of Gears", col=c("darkblue","red"),
 	legend = rownames(counts))
  
###--- 分组 -----------------------------------------------------
# 设置了参数beside
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
  xlab="Number of Gears", col=c("darkblue","red"),
 	legend = rownames(counts), beside=TRUE)

###--- 加标准误 --------------------------------------------------
# 实际上通过arrow函数拼接上去的
# 数据构造
tbl <- data.frame(groups= sample(rep(1:3, 100), 30),
                  scores <- rnorm(30, 5)
)
# 计算每组的均值和标准误
mean_tbl <- aggregate(scores ~ groups, tbl, mean)
sd_tbl <- aggregate(scores ~ groups, tbl, sd)
# 绘图,同时设计bar的间隔
space = 0.1
barplot(mean_tbl[, 2], xlim= c(0, 5), ylim= c(0, 7), space= space, names= 1:3)
# 计算每一个bar的中心位置
grp <- nrow(mean_tbl)
x_loc <- 0.5*(1 + seq(from= 0, by= 2, length.out= grp))  + space*seq_len(grp)
# 标准误作图
arrows(x0=x_loc, x1= x_loc, y0= mean_tbl[, 2], y1= mean_tbl[, 2] + sd_tbl[, 2], angle= 90, length= .05)
arrows(x0=x_loc, x1= x_loc, y0= mean_tbl[, 2], y1= mean_tbl[, 2] - sd_tbl[, 2], angle= 90, length= .05)

###--- 不同组别坐标轴对称分布 ---------------------------------------
# 这非常简单，主要依靠数据的正负表现
barplot(c(1, -1, 2))

###--- bar截断 ----------------------------------------------------
# *注* 该内容可以用 plotrix::gap.barplot 绘制
# 有时候某个bar太长了，比较尺度太大，将整体性对比度缩小了，因此需要将其截断显示
# 例如下面的例子
mat <- c(969, 248, 92, 30, 7, 3, 4, 4, 1)
# 如果要达到缩短第一个bar凸显其他bar的话，需要以矩阵的形式截断输入
m0 <- mat
m0[1] <- 250
m1 <- c(10, rep(0, 8))
# 设计好截断比例
m2 <- c(69*40/100, rep(0, 8))
mat <- matrix(c(m0, m1, m2), nrow= 3, byrow= T)
mat
# 绘图
barplot(mat, col= c("grey", "white", "grey"), border= T, axes= T,
        ylim= c(0, 300), xlim= c(0, 17), names.arg= 1:9
)
# 可以看出我们构造的图纵坐标不对，所以要对坐标重新构造；且border也要去掉才行
barplot(mat, col= c("grey", "white", "grey"), border= F, axes= F,
        ylim= c(0, 300), xlim= c(0, 17), names.arg= 1:9
)
axis(2, at= c(0, 10, 30, 100, 150, 200, 250), labels= c(0, 10, 30, 100, 150, 200, 250), las= 1)
axis(2, at= c(260, 300), labels= c(900, 1000), las= 1)

# 另一个相似的例子
m0 <- c(172, 24, 15, 5, rep(0, 5))
m1 <- c(78, 224, 77, 25, 7, 3, 4, 4, 1)
m2 <- c(10, rep(0, 8))
m3 <- c(34, rep(0, 8))
mat <- matrix(c(m0, m1, m2, m3), 4, byrow= T)
barplot(mat, ylim= c(0, 300), col= c("black", "grey", "white", "grey"), 
        border= F, xlim= c(0, 17), xlab= "no. circRNAs", ylab= "no. hosts", 
        names.arg= 1:9, axes= F)
axis(2, at= c(0, 10, 30, 100, 150, 200, 250), labels= c(0, 10, 30, 100, 150, 200, 250), las= 1)
axis(2, at= c(260, 300), labels= c(900, 1000), las= 1)

##############
#### 讨论   ###
##############
# 1.非多组(beside= F), 如<加标准误>模块，关于barplot(horiz= FALSE)非多组的x轴的位置，第一个bar的左边缘的x值为参数space的距离，
#   然后每一个bar的宽度刚好为1(其中width= 1控制），所以可以如<加标准误>的例子中定位每个bar的中心；
counts <- table(mtcars$gear)
points(c(0.7, 1.9), c(2, 2))
# 该例子是默认参数，我们可以看出默认space= 0.2, 那么第一个bar的x坐标为0.2，原点分别标示了第一以及第二个bar的x位置

# 2.多组(beside= T)的情况，即<分组>模块，第一个bar的x轴坐标的距离刚好是1，且不同组之间的间隔也为1(其中参数width= 1)
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, beside= T, col= "grey")
points(c(1.5, 2.5, 3.5, 4.5), rep(2, 4))
# 可以从该例子中看出，默认space=1，所以第一个bar的x坐标也为1
