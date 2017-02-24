###############################
### bar图可能遇到的各种形式    ###
###############################
# 参考 Quick-R: http://www.statmethods.net/graphs/bar.html

###--- 简单情况 ----------------
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

###--- 重叠（stacked）----------
# 并附上legend；其实就是数据变换了格式
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
  xlab="Number of Gears", col=c("darkblue","red"),
 	legend = rownames(counts))
  
###--- 分组 -------------------
# 设置了参数beside
counts <- table(mtcars$vs, mtcars$gear)
barplot(counts, main="Car Distribution by Gears and VS",
  xlab="Number of Gears", col=c("darkblue","red"),
 	legend = rownames(counts), beside=TRUE)

###--- 加标准误 ----------------
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

###--- 不同组别坐标轴对称分布 ---
