---
{}
  :id |hyperbolic-rotation
  :title "|速度变换是双曲旋转"
  :summary "|欧氏旋转保持正定长度，Lorentz 变换保持不定的时空间隔。Clifford 代数让两者都可理解为由度量决定的旋转结构。"
  :kind :section
  :parent |minkowski-spacetime
  :tags $ #{} "|不定度量" "|变换"
  :links $ [] |lorentz-transform |clifford-algebra
---
## 速度变换是双曲旋转

### Lorentz 变换究竟保持什么

在欧氏平面中，旋转改变坐标，却保持 $x^2+y^2$。在一维空间与时间组成的平面中，Lorentz boost 改变 $ct$ 与 $x$，却保持

$$
(ct)^2-x^2.
$$

因此 boost 可以理解为不定度量下的“旋转”。差异不在于是否有几何，而在于几何所保持的二次型具有不同符号。

### 快度把速度合成重新线性化

令速度参数满足

$$
\frac{v}{c}=\tanh\phi,
$$

$\phi$ 称为快度。Lorentz boost 可写成

$$
\begin{pmatrix}ct'\\x'\end{pmatrix}=
\begin{pmatrix}\cosh\phi&-\sinh\phi\\-\sinh\phi&\cosh\phi\end{pmatrix}
\begin{pmatrix}ct\\x\end{pmatrix}.
$$

普通旋转使用 $\cos^2\theta+\sin^2\theta=1$，双曲旋转使用 $\cosh^2\phi-\sinh^2\phi=1$；正负号差异来自度量签名，而非两套无关技巧。

连续同方向 boost 时快度直接相加：

$$
\phi_{\mathrm{total}}=\phi_1+\phi_2.
$$

换回速度后才得到熟悉的非线性合成

$$
v_{\mathrm{total}}
=\frac{v_1+v_2}{1+v_1v_2/c^2}.
$$

所以相对论速度合成之所以看起来复杂，部分原因是速度 $v$ 不是变换群最自然的加法参数。快度才扮演类似普通旋转角的角色。

### Poincaré、Minkowski 与群的视角

Poincaré 识别 Lorentz 变换的群结构，Minkowski 则把群作用的对象明确为四维时空。由此，参考系变化不再是一组临时坐标技巧，而是时空度量的对称变换。

在三维空间中，不同方向的 boost 一般不交换；连续不同方向 boost 的组合还会产生 Thomas–Wigner 旋转。这再次出现 Hamilton 已遇到的事实：高维空间变换的次序携带几何信息。

### Clifford 代数中的统一写法

在时空 Clifford 代数中，欧氏旋转和 Lorentz boost 都可由 rotor 的夹心作用表示。区别来自生成二向量的平方：欧氏旋转平面的生成元平方为负，产生三角函数；时空平面的生成元平方为正，产生双曲函数。

于是复数旋转、四元数旋转和 Lorentz boost 不是三套偶然相似的公式，而是“由度量决定的指数变换”在不同维度和签名下的表现。
