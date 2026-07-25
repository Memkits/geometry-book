---
{}
  :id |clifford-synthesis
  :title "|Hamilton 与 Grassmann 的汇合"
  :summary "|Grassmann 的外积记录有向面积与高维扩张，Hamilton 的乘法携带度量和旋转。Clifford 用二次型把两条道路合并。"
  :kind :section
  :parent |clifford-algebra
  :tags $ #{} "|代数史" "|统一"
  :links $ [] |grassmann |clifford
---
## Hamilton 与 Grassmann 的汇合

### 两位 1840 年代的开路者

Hamilton 在 1843 年发现四元数，把三维旋转的顺序装进非交换乘法。仅一年后，任职中学教师的 Hermann Grassmann 出版《线性扩张论》。Grassmann 的目标更抽象：不预设空间只有三维，而从独立方向的组合出发构造任意维“扩张量”。

Grassmann 的乘法满足

$$
u\wedge v=-v\wedge u,\qquad v\wedge v=0.
$$

它自然生成有向线、面积、体积与更高维子空间。一个二向量不是普通向量，而是“某个有向平面元素”；三个方向的外积则形成有向体积。

Grassmann 的书过于抽象、记号陌生，首版几乎没有得到理解；1862 年重写版仍传播缓慢。他晚年转向语言学并取得更广泛承认。历史在这里提醒我们：一个概念的深度与它当时的可读性并不相同。

### Clifford 看见两条道路可以汇合

William Kingdon Clifford 同时受到 Hamilton、Grassmann、Cayley 和非欧几何的影响。他在 1873 年研究双四元数，并在 1878 年的《Grassmann 扩张代数的应用》中提出后来称为 Clifford 代数的结构。

Grassmann 的外积保存方向和维数，却没有自行指定长度；Hamilton 的乘法包含范数和旋转，但紧密绑定于四元数。Clifford 从二次型 $Q(v)$ 出发，规定

$$
v^2=Q(v).
$$

对 $u+v$ 展开后可得

$$
uv+vu=2\langle u,v\rangle.
$$

于是向量乘积的对称部分由度量决定，反对称部分则恢复 Grassmann 外积。Hamilton 的四元数也可在适当 Clifford 代数的偶子代数中出现。

### 为什么它比“拼接两套符号”更深

Clifford 的统一说明，测量与定向扩张可以来自同一个乘法：

- 二次型决定长度、正交性以及基向量平方的正负号；
- 外积决定线、面、体及其取向；
- 乘法的可逆元素生成反射与旋转。

更换度量签名，就能从欧氏空间转向双曲结构和相对论时空。Clifford 只活到 33 岁，没有看到这套代数在 20 世纪物理中的回归；但他已经把“空间是什么”转化为一个可计算问题：先给出二次型，再研究它生成的代数。
