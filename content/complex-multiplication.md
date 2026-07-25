---
{}
  :id |complex-multiplication
  :title |乘法中的空间规律
  :summary "|极坐标形式揭示复数乘法同时组合尺度与角度。"
  :kind :section
  :parent |complex-numbers
  :tags $ #{} |旋转 |结构 |Euler公式
  :links $ [] |euler-formula |quaternions
---
## 乘法中的空间规律

### de Moivre 与 Euler：把角度送进代数

18 世纪的一个关键进展，是周期运动、三角函数与复数逐渐被看作同一种结构。de Moivre 研究了

$$
(\cos\theta+i\sin\theta)^n
=\cos(n\theta)+i\sin(n\theta),
$$

Euler 则在指数函数的框架中写出

$$
e^{i\theta}=\cos\theta+i\sin\theta.
$$

这不是漂亮记号而已。它说明角度相加可以被普通乘法实现：连续旋转不再需要单独的几何作图，而可以直接做代数乘法。

### 极坐标分解出的两个不变量

把非零复数写成 $z=re^{i\theta}$，其中 $r=|z|$ 是尺度，$\theta$ 是方向。两个复数相乘时

$$
(r_1e^{i\theta_1})(r_2e^{i\theta_2})
=r_1r_2e^{i(\theta_1+\theta_2)}
$$

所以乘法有两条并行规律：

- 模长相乘，记录尺度如何复合；
- 辐角相加，记录方向如何复合。

共轭 $z\mapsto\bar z$ 反转方向，乘积 $z\bar z=|z|^2$ 则把方向信息消去，只留下度量。这里已经出现后续代数反复使用的模式：对象与其“反向版本”相乘，会产生一个可测量的标量。

### 为什么这是一条空间规律

一个单位复数 $e^{i\theta}$ 作用于任意 $z$ 时保持长度，只改变方向。所有单位复数组成圆群 $U(1)$；旋转角相加对应群乘法。二维旋转因而被完整编码在一个交换代数中。

在交流电、量子振幅、傅里叶分析和信号处理中，人们关心的不只是量的大小，还关心相位关系。复数之所以反复出现，不是因为物理世界里藏着虚构的长度，而是因为它准确表达了周期、旋转与叠加。

### 通往更高维的诱惑与障碍

复数的成功自然提出一个问题：能否用“三个坐标的数”同样编码三维方向和旋转？如果二维旋转能由乘法完成，三维旋转似乎也应当有自己的数系。

Hamilton 正是从这里出发。然而三维旋转的复合不交换：先绕 $x$ 轴、再绕 $y$ 轴，与相反顺序通常不同。复数乘法的交换性因此无法原封不动地保留。下一篇文章的核心，就是 Hamilton 如何在失败多年后意识到：推广空间规律时，需要放弃的不是几何，而是一条过于熟悉的代数公理。

### 继续查证

- [MacTutor：代数学基本定理的历史](https://mathshistory.st-andrews.ac.uk/HistTopics/Fund_theorem_of_algebra/)
- [MacTutor：Caspar Wessel](https://mathshistory.st-andrews.ac.uk/Biographies/Wessel/)
- [MacTutor：Jean-Robert Argand](https://mathshistory.st-andrews.ac.uk/Biographies/Argand/)
