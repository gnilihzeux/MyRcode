### 颜值设置  
  
不用说，在看颜值的社会，有好的配色才能逆袭！  
已经有很多教程讲解了R中如何配色，其中[R语言进阶](http://blog.csdn.net/u014801157/article/details/24372411)
比较详细和系统地讲解了R语言中的调色板，包括  
&ensp;**rainbow**  
&ensp;**heat.colors**  
&ensp;**terrain.colors**  
&ensp;**topo.colors**  
&ensp;**cm.colors**  
另外还有自定义调色板  
&ensp;**colorRampPalette**  
以及灰度设置  
&ensp;**gray**  

当然光有靓装还不行，还需要懂得如何搭配~  
[二颜色混合器计算器](http://www.osgeo.cn/app/sc501)  
[RGB选色](http://www.rapidtables.com/web/color/RGB_Color.htm)  
[科技论文常用配色](http://geog.uoregon.edu/datagraphics/color_scales.htm)  

---  

### R中的颜色  
  
[R颜色板](http://research.stowers.org/efg/R/Color/Chart/)链接不到了似乎，搜索[R Color Chart](https://www.aiguso.ml/)应该能搜到，或者输入下面代码展示 

```  
m <- matrix(1:675, 25, 27)  
# 面板中总共有657种颜色  
image(m, col= colors(), axes= F)  
loc <- expand.grid(0:24, 0:26)
text(loc[, 1]/24, loc[, 2]/26, m, cex= .5)
# 例如取其中几种颜色显示
barplot(rep(1, 5), col= colors()[c(8, 18, 118, 518, 618)], axes= F)
```  

实际上，这里展示的是R中固有的颜色。据该文档介绍，R将所有颜色的名字存到了相应的位置(安装目录中)，  
`linux: /usr/lib/X11/rgb.txt (or sometimes /etc/X11)`  
`windows: C:\Program Files\R\rw<version>\etc\rgb.txt`  
下面介绍几个关于R color的几个函数  
&ensp;**colors**  
&ensp;我们已经知道该函数总共包含657个值，实际上除了第一个white，其他值都是按照字母表顺序排列的；  
&ensp;如果想获得特定的颜色，比如红色，可以用`grep("red", colors())`  
&ensp;**col2rgb**  
&ensp;这个函数好理解，就是将颜色转换成red/green/blue三原色，例如`col2rgb("red")`  
&ensp;与它相对应的函数  
&ensp;**rgb**  
&ensp;默认输入是0-1之间的值，例如`rgb(1.0, 1.0, 0.0)`  
&ensp;也可以更改参数maxColorValue=255将输入设置为我们常见的255格式，例如`rgb(255, 255, 0, maxColorValue=255)`  

另外，该文档也介绍了将上面那个R Color Chart更好的展示，例如颜色归类，有相应的代码，可以网上搜索搜索……
