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

# bar图水平放置，使用horiz= TRUE就OK了
barplot(counts, main="Car Distribution", horiz=TRUE, names.arg=c("3 Gears", "4 Gears", "5 Gears"))

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
# 
