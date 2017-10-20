# barplot的各种不同形式
> 参考 Quick-R: http://www.statmethods.net/graphs/bar.html

## 基本图形
```
counts <- table(mtcars$gear)
barplot(counts, main="Car Distribution", xlab="Number of Gears")
```

![](barplot1.png)  

然而，图中bar太宽，需要调窄一点，这需要配合参数`xlim`

```
barplot(counts, main="Car Distribution", xlab="Number of Gears",
        xlim= c(0, 5)
        )
```

