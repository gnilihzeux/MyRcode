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
&ensp;**colorRampPalette  
以及灰度设置  
&ensp;**gray**  

---  

当然光有靓装还不行，还需要懂得如何搭配~  
[二颜色混合器计算器](http://www.osgeo.cn/app/sc501)  
[RGB选色](http://www.rapidtables.com/web/color/RGB_Color.htm)  
[科技论文常用配色](http://geog.uoregon.edu/datagraphics/color_scales.htm)  

---  
### R中的颜色  
  
[R颜色板](http://research.stowers.org/efg/R/Color/Chart/)好像不好使了，搜索R Color Chart应该能搜到，或者输入下面代码展示 

```  
library(gplots)  
m <- matrix(1:675, 25, 27, byrow= T)  
# 面板中总共有657种颜色  
heatmap.2(m, cellnote= m, notecol= colors()[1:675]) 
```  
  
实际上，这里展示的是R中固有的颜色。据该文档介绍，R将所有颜色的名字存到了相应的位置(安装目录中)，  
linux: /usr/lib/X11/rgb.txt (or sometimes /etc/X11)
windows: C:\Program Files\R\rw<version>\etc\rgb.txt
