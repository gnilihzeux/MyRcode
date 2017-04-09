## 说明文档  

### 引（可以略过）
做生物信息的时候，我们经常要计算基因间的共表达相关性，当时编程水平不够，就傻傻地用`for`循环来计算来计算任意两个基因的相关性、p值以及fdr值。当基因数目少的时候还行，跑个把小时；当要计算的关系对太多，比如`5000*10000`，这时间就没个准了，当时还庆幸找到了“并行运算”的**好方法**——将关系对分割成几十个文件分别跑……  
真是**Too young too simple**

后来渐渐贯彻了**R向量运算**的理念，原来`cor`函数可以直接进行矩阵运算，速度非常快，简直是如获至宝！**只要有了斧子，还怕我抡不起来！**  

当然对矩阵进行相关性检验确实是个问题，`cor.test`只支持两个向量间的运算。但已经有了斧子，就要将它抡起来！于是自己根据`cor.test.default`查看了相关性检验方法——皮尔森相关性检验实际上就是T检验。  

当然，我对编程不太敏感，也不努力，所以很少仔细去研究这方面的知识。幸好有万能的无私
的网友（大部分是外国友人，比如[stackoverflow](https://stackoverflow.com/)）喜欢分享知识解决难题，更重要的是有**谷歌**这个好伙伴提供接口，让我对相关性程序能够不断改进。  

这就是最后的成果了，“斯是陋室，惟吾德馨”~  

### 函数介绍  

这里对矩阵的相关性检验只局限于`pearson`，在`cor.test`中其他两种方式由于不是T检验，
实现比较困难。另外，R包`psych`同理也是集成`cor`与`t.test`，所以在计算大矩阵时也很吃力，
不过它除了计算p值与fdr值还计算了置信区间和标准误等信息，感兴趣可以看看源代码。  

**注意**：`bigcor`只对`x`矩阵进行分割，所以当有两个矩阵时，将最大的设置为`x`应该更好。也许有之后会有改进的程序，希望~！

* bigcor  
该函数是一个外国友人提供，很好地解决了R自带函数`cor`计算大矩阵的难题，基本思想是  
矩阵分块计算（代数矩阵运算那部分有相关理论，但我也只能依稀记得，从小就得了“数学  
头痛症“）。  
参考资料（也可以直接google)  
&emsp;[rmazing](https://rmazing.wordpress.com/2013/02/22/bigcor-large-correlation-matrices-in-r/)  
&emsp;[r-blogger](http://www.r-bloggers.com/bigcor-large-correlation-matrices-in-r/)  
&emsp;[brainchronicle](http://brainchronicle.blogspot.com/2013/02/large-correlation-in-parallel.html)  
&emsp;[rdrr](https://rdrr.io/cran/propagate/src/R/bigcor.R)  

* pearsonCorrelationMatrix  
自定义函数判断是用`bigcor`还是`cor`，这里设定的是：其中一个矩阵变量>5000就用`bigcor`  

* pearsonTestMatrix  
主函数，用来计算pearson相关性并进行检验、计算FDR值，参数：  
  - x，y
  行为观测值，列为变量，与`cor`一致。
  默认`y= NULL`表示只对`x`进行相关性计算，从而获得对称矩阵；  
  若`y`不为`NULL`且与`x`不一致，那么最后获得的是行为`x`的变量、列为`y`的变量、值为相关性的非对称矩阵。  
  - size= 2000  
  这个参数是为`bigcor`提供，意思是将原始矩阵按照多大的规模`size`分割。  
  - adjust= "BH"
  这个参数与`cor`一致，表示用哪种方法进行多重检验校正  
最后结果包含三个矩阵：相关性、p值和fdr值。  

* outputDF  
该函数目的是将`pearsonCorrelationMatrix`的结果转换为长格式的数据库：变量1、变量2、相关系数、p值、fdr值。  

* checkPoint  
用`cor.test`对结果进行验证，看`outputDF`的值是否一致，默认检测分位数0/0.25/0.5/0.75/1这5行。
