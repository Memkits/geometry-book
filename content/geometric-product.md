---
{}
  :id |geometric-product
  :title "|几何乘积"
  :summary "|把内积与外积合并为单一、可逆且结合的乘法。"
  :kind :operation
  :era "|1878"
  :formula "|uv = u·v + u∧v"
  :links $ [] |wedge-product |inner-product |clifford-algebra |reflection
  :relations $ []
    {} (:direction :incoming) (:source |wedge-product) (:kind :component) (:label "|方向部分")
    {} (:direction :incoming) (:source |inner-product) (:kind :component) (:label "|度量部分")
    {} (:direction :incoming) (:source |clifford-algebra) (:kind :constructs) (:label "|定义核心乘法")
    {} (:direction :outgoing) (:target |reflection) (:kind :theorem) (:label "|推导")
---
# 几何乘积

把内积与外积合并为单一、可逆且结合的乘法。

## 历史脉络

Clifford 代数的核心运算，20 世纪由 Hestenes 等重新推广。

Clifford 的出发点并不是否定 Grassmann，而是补上外代数有意搁置的度量问题。Grassmann 可以稳定表达有向面积，却不能从 $u\wedge v$ 单独恢复夹角与长度。Clifford 在 1878 年提出，让向量平方直接等于给定二次型：$v^2=Q(v)$。这样长度不再是乘法之外附加的测量，而被写进代数本身。

## 数学结构

$$
uv = u·v + u∧v
$$

把乘积反对称与对称化，可分别取回两部分：

$$
u\cdot v=\frac12(uv+vu),\qquad
u\wedge v=\frac12(uv-vu).
$$

因此几何乘积不是把两种操作拼贴在一起，而是一种更原始的乘法：对称部分问“两个方向有多少共线成分”，反对称部分问“它们共同张成哪个有向平面”。若 $u,v$ 是单位向量且夹角为 $\theta$，在它们张成的平面中可写成

$$
uv=\cos\theta+B\sin\theta,
$$

其中 $B$ 是该平面的单位二向量，满足 $B^2=-1$。这与复数 $\cos\theta+i\sin\theta$ 极其相似，只是虚单位不再固定为唯一的 $i$，而是随旋转平面而变。

这条公式解释了一个历史上的综合：复数擅长一个固定平面的旋转，四元数擅长三维旋转，Clifford 代数则允许每个有向二维平面都贡献自己的“平方为负一”的二向量。

## 现实意义

一个运算同时回答“多接近同向”和“张成什么平面”。

几何乘积还让反射和旋转成为同一类夹心作用。对可逆法向量 $n$，超平面反射可写作

$$
v'=-nvn^{-1}.
$$

连续两次反射给出旋转；把两个单位向量的乘积适当归一化，得到 rotor，再以 $Rv\widetilde R$ 作用于向量。这就是“旋转是两次反射”的 Cartan—Dieudonné 思想在代数中的可计算形式。

当二次型的符号改变，几何乘积也改变其空间意义。在欧氏签名中某些单位二向量平方为 $-1$，对应圆旋转；在 Minkowski 签名中另一些二向量平方为 $+1$，对应双曲旋转，也就是 Lorentz boost。于是同一乘法可跨越欧氏空间与时空。

## 深入理解

交换部分是内积，反交换部分是外积。

这里需要避免一个常见误解：几何乘积本身并不神奇地消除所有坐标选择。它提供的是一个能同时保留度量、取向、分次与可逆变换的容器。选择基、选择签名、选择具体矩阵表示，仍取决于所研究的空间；但不同表示背后的关系 $uv+vu=2u\cdot v$ 不变。
