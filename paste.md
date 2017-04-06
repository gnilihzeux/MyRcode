### 黏糊糊的paste  

更多关于文本处理的函数，请参考[R语言进阶](http://developer.51cto.com/art/201305/393692.htm)  

这个函数简单实用，但给出的两个分割参数`sep`和`collapse`有时让人傻傻分不清~  
帮助文档抬头就说明了，对于输入的对象，**首先**操作的是将该对象用`as.character()`转换，**然后**用根据`sep`指定分割，**最后**将分割结果用`collapse`粘起来。  
`sep`是对多个对象进行操作，`collapse`是对对象内元素的操作——之前有人提出将输入对象理解成矩阵，`sep`连接行元素，`collapse`连接列元素  
我们实际演练一下  

```  
x <- letters[1:3]  
y <- LETTERS[1:3]  
xy <- data.frame(x, y)  
(m <- as.matrix(xy))  
# 现在我们将x和y黏在一起，看效果  
paste(x, y, sep= ",", collapse= NULL)  
#从结果看，就是矩阵m的每行元素的黏贴，再对比collapse  
paste(x, y, sep= ",", collapse= ":")  
```
