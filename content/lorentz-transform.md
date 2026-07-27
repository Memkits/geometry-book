---
{}
  :id |lorentz-transform
  :title "|Lorentz 变换"
  :summary "|保持 Minkowski 间隔的时空变换。"
  :kind :theorem
  :era "|1895—1905"
  :formula "|x′ = LxL⁻¹"
  :links $ [] |minkowski-spacetime |maxwell-field
  :relations $ []
    {} (:direction :incoming) (:source |minkowski-spacetime) (:kind :theorem) (:label "|对称变换")
    {} (:direction :outgoing) (:target |maxwell-field) (:kind :application) (:label "|混合电磁分量")
---
# Lorentz 变换

保持 Minkowski 间隔的时空变换。

## 历史脉络

Lorentz、Poincaré 与 Einstein 从电磁学和相对性原理中发展出来。

这条路线并非“一个公式突然取代 Newton 力学”。Maxwell 方程给出的光速在 Galilei 速度叠加下不应保持不变；Lorentz 为保持电磁方程形式引入长度收缩与地方时；Poincaré 强调相对性原理并识别变换的群结构；Einstein 则把同时性的定义置于理论核心。Minkowski 最终指出，真正应被保持的不是单独的空间距离或时间间隔，而是四维事件之间的二次型关系。

## 数学结构

$$
x′ = LxL⁻¹
$$

沿 $x$ 方向、速度为 $v$ 的 boost 通常写为

$$
\begin{aligned}
t'&=\gamma\left(t-\frac{vx}{c^2}\right),\\
x'&=\gamma(x-vt),\\
y'&=y,\qquad z'=z,
\end{aligned}
\qquad
\gamma=\frac1{\sqrt{1-v^2/c^2}}.
$$

它保持的量是

$$
c^2t^2-x^2-y^2-z^2.
$$

与普通平面旋转保持 $x^2+y^2$ 相比，关键差别是符号。圆的参数是三角函数；双曲线的参数是双曲函数。令 $\tanh\varphi=v/c$，则 boost 的组合遵循双曲角 $\varphi$ 相加。这使速度合成不再是简单相加，而是先加 rapidity 再映回 $v/c$。

在 Clifford 语言中，取时向单位向量 $\gamma_0$ 与空间向量 $\gamma_1$ 张成的二向量 $K=\gamma_1\gamma_0$ 满足 $K^2=+1$，故

$$
R=\exp\!\left(-\frac\varphi2K\right)
$$

生成的是双曲旋转，而向量按 $x\mapsto Rx\widetilde R$ 变换。这与欧氏 rotor 形式相同，只是生成平面的平方符号不同。

## 现实意义

在时空代数中，速度变换可视为双曲旋转。

“时间变慢、长度变短”不是两条彼此独立的视觉效果，而是同一不变量在不同观察者分解下的投影。光锥 $s^2=0$ 将事件分为可因果影响与不可因果影响的区域；任何 Lorentz 变换都不能把类时关系变成类空关系。因果结构比坐标读数更接近理论的骨架。

电场和磁场的混合也来自同一事实。改变观察者的时间方向，就是以新的方式把电磁场张量分解为“电”和“磁”；它们分别不变，完整的时空场才是对象。

## 深入理解

它统一长度收缩、时间膨胀与同时性的相对性。

需要区分 **坐标变换** 与 **主动变换**。前者是同一事件由不同参考系标记，后者是把几何对象在固定坐标背景下作用一个群元素；二者在公式上密切相关，却回答不同问题。这个区分也是后续理解张量、旋量与规范变换时避免混淆的起点。
