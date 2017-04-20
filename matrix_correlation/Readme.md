# 说明文档  

生物信息学进行大规模的统计检验时基本上不会考虑过多的统计量，一般都是p值和校正p值（比如FDR）。

## 引（可以略过）
做生物信息的时候，我们经常要计算基因间的共表达相关性，当时编程水平不够，就傻傻地用`for`循环来计算来计算任意两个基因的相关性、p值以及fdr值。当基因数目少的时候还行，跑个把小时；当要计算的关系对太多，比如`5000*10000`，这时间就没个准了，当时还庆幸找到了“并行运算”的**好方法**——将关系对分割成几十个文件分别跑……  
真是**Too young too simple**

后来渐渐贯彻了**R向量运算**的理念，原来`cor`函数可以直接进行矩阵运算，速度非常快，简直是如获至宝！**只要有了斧子，还怕我抡不起来！**  

当然对矩阵进行相关性检验确实是个问题，`cor.test`只支持两个向量间的运算。但已经有了斧子，就要将它抡起来！于是自己根据`cor.test.default`查看了相关性检验方法——皮尔森相关性检验实际上就是T检验。  

当然，我对编程不太敏感，也不努力，所以很少仔细去研究这方面的知识。幸好有万能的无私
的网友（大部分是外国友人，比如[stackoverflow](https://stackoverflow.com/)）喜欢分享知识解决难题，更重要的是有**谷歌**这个好伙伴提供接口，让我对相关性程序能够不断改进。  

这就是最后的成果了，“斯是陋室，惟吾德馨”~  

## 函数介绍  

R包`psych`也有个函数`corr.test`做相同的事儿，实际上该函数集成的是`cor`与`t.test`，所以在计算大矩阵时很吃力，
不过它除了计算p值与fdr值还计算了置信区间和标准误等信息，感兴趣可以看看源代码。  
另外值得注意的是，原始的`cor.test`对三种不同的相关性方法`pearson/spearman/kendall`进行的检验时采取的策略不一样，可以用
`getAnywhere(cor.test.default)`查看源代码。而`corr.test`对三种方法都使用了`t.test`进行检验，其中的数学原理我不是很了解，所以计算的时候需要谨慎。故而在这里，`pearsonTestMatrix`**也许**也能够对`spearman/kendall`进行检验。但，`t.test`是对服从正态分布的
伙计进行检验，而`spearman/kendall`是非参数方法，这似乎不合理……

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

---

## 更新

之前只能计算皮尔森，现在可以搞[斯皮尔曼](https://github.com/gnilihzeux/MyRcode/blob/master/matrix_correlation/spearmanTestMatrix.R)了！
使用方法与`pearsonTestMatrix`差不多。  

* spearmanTestMatrix  
  - x,y,adjust  
  同`pearsonTestMatrix`
  - CPU= 4  
  并行计算分配几个内核，默认是4个

**注意** 关于观测值`n > 1290`的情况我没有测试（感觉不会再爱），使用时要检查检查……  

`网友King:` 对于这么不靠谱的整合方法真的是需要提着心吊着胆~

## 后记（可以略过）  

斯皮尔曼相关性检验的向量化真是废了我大量的时间，最后效果仍然没有皮尔森的好。皮尔森相关性检验
计算相对容易，就是T检验，它的计算公式很容易就能矩阵化（向量化）；而斯皮尔曼相关性就要复杂的多。
利用`getAnywhere(cor.test.default)`我们可以看到`cor.test`的源代码，再结合帮助文档`?cor.test`，
我们可以知道，当观测值`n < 1290`时，皮尔森相关性检验使用的是**AS 89**算法，而该算法在`n < 10`
的时候能够计算出精确值；其他情况都是采用T渐进分布（asymptotic t approximation)。  

**注意** 如果变量`x`或`y`中有重复观测值，那么我们是得不到精确值的）。比如：  

```
> cor.test(1:8, c(1, 3, 5, 7,3, 2, 9, 2), method= "spearman")
Warning message:
In cor.test.default(1:8, c(1, 3, 5, 7, 3, 2, 9, 2), method = "spearman") :
Cannot compute exact p-value with ties
```

这里的`ties`就是指观测值有重复的意思。但在算法中这仅仅给出了警告而没有改变新的算法。  

看算法似乎很简单，但实际上有个很大的麻烦就是计算斯皮尔曼整体相关系数`rho`时调用的是C程序。最笨
的办法就是直接用`cor.test.default`中的代码进行运算，但-It didn't work!-——其中一个参数`C_pRho`
根本无法调用。到这里，我实际上是放弃挣扎了，虽然有豪言壮语**撬动R的内核**，但不适合我……  

故事还没完，不知道哪根神经跳了，我继续搜索看其他人是怎么对百万级别（1000X1000的矩阵）甚至数亿
（10000X10000的矩阵）的关系对——实际上这是生物信息基因组级别——进行快速地计算的（当然是用R）。但
是很失望，没有找到……  

阴差阳错地，我撬开了`pspearman`包——`cor.test`帮助文档中推荐的更精确计算p值的方法。R的`base`包
虽然不好撬，但该包源代码却容易得多，包括如何计算`rho`，甚至直接调用都没有问题。  

好吧，开始干吧！包中的`spearman.test`实际上包含三种计算p值的方法，除了**AS 89**和T渐进分布还
包括更精确的方法：当`n <= 22`，`pspearman`的作者事先设计了22个向量用来拟合相应的分布，从而获得
更精确的值。但实际操作中，这精确的方法不服从管教，唉！最后发挥懒惰的个性，该方法我没有实现。

本来呢，直接调用`pspearman`函数进行p值计算应该很合理才对，但不知道哪里抽风，该函数非常耗时，但
单独进行**AS 89**时间却相对较短。无奈之下，我将它抽了出来单独计算。  

但时间消耗还是太大，对于1000X1000的矩阵居然要花20多分钟，这不能忍啊！要问我怎么办，实际上我现有
的能力差不多就这样了……但是！我还是无法忍受。最后快速上手了`parallel`包——哈哈哈哈，1000X10000的矩阵
只花了2分钟就OK了（4个CPU）。对于10000X10000的矩阵花了二十多分钟……啊，我已经比较满足了……  

`parallel`我是基本不会用的额，在征用多个CPU时（可能物理核与逻辑核都算吧）还是出现了错误：  
`Error in checkForRemoteErrors(val)`  
啊，头大啊，又要看文档，又要查资料……哈哈哈，*瞎猫碰到了死耗子*，用`clusterExport(c1, "pspearman")`
解决了。我的理解是，通过告诉每个CPU，`pspearman`这个包子是可以吃的，不是地雷，放心吧。  

最后呢，T渐进分布虽然封装了，但是我没有测试，感觉好累……另外，我也没有用`for`循环进行时间上的比较，
太累了，不知道是不是真的快了一些呢？

**ps.** 要吐槽一下的是，R语言对中文，特别是linux对中文没有好感啊，总是出错！
