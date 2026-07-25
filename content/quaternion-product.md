---
{}
  :id |quaternion-product
  :title "|次序成为几何信息"
  :summary "|ij=k 而 ji=-k。这里的非交换不是缺陷，而是准确记录三维旋转次序：先绕一个轴再绕另一个轴，结果依赖操作顺序。"
  :kind :section
  :parent |quaternions
  :tags $ #{} "|非交换" "|旋转"
  :links $ [] |noncommutativity |quaternion-rotation
---
## 次序成为几何信息

### 非交换性记录“先做什么”

基本关系 $ij=k$ 而 $ji=-k$ 表明，交换两个相互垂直的虚方向会反转结果方向。这里的非交换不是缺陷，而是对三维空间事实的忠实编码：先绕一个轴旋转，再绕另一个轴旋转，通常不等于相反的执行顺序。

把四元数写成“标量 + 向量”

$$
q=s+\mathbf v,
$$

两个纯虚四元数 $\mathbf a,\mathbf b$ 的乘积可拆为


$$
\mathbf a\mathbf b=-\mathbf a\cdot\mathbf b+\mathbf a\times\mathbf b.
$$

对称部分给出夹角与长度，反对称部分给出有向法向；交换两个因子会反转叉积方向，所以 $ij=k$ 而 $ji=-k$。非交换性保存了“先做什么、后做什么”的操作信息。

### 共轭与范数把几何量提取出来

四元数共轭把虚部反向：

$$
\bar q=s-\mathbf v.
$$

于是

$$
q\bar q=s^2+\|\mathbf v\|^2
$$

是普通实数。它把方向信息消去，留下四维欧氏范数，并给出逆元 $q^{-1}=\bar q/|q|^2$。这个“对象乘以反向对象得到度量”的结构，后来会在 Clifford 代数中以更一般的形式出现。

### Cayley 与旋转的夹心作用

Hamilton 很快研究了四元数对空间的作用；Cayley 在 1845 年也写出了与旋转矩阵相关的公式。现代写法把三维向量嵌入纯虚四元数，并令单位四元数 $q$ 作用为

$$
\mathbf v'=q\mathbf vq^{-1}.
$$

若

$$
q=\cos\frac{\theta}{2}
 +\mathbf n\sin\frac{\theta}{2},
$$

其中 $\mathbf n$ 是单位轴，那么夹心作用产生绕该轴的 $\theta$ 旋转。半角不是记号偶然：$q$ 与 $-q$ 产生同一个空间旋转，所以单位四元数以二对一方式覆盖 $SO(3)$。

两个旋转的组合对应四元数乘法，乘法顺序就是变换复合顺序。由此看，四元数不是“奇怪的四维数”，而是三维旋转背后更平滑的参数空间。它也预示了后来 $Spin(3)\cong SU(2)$ 与旋量的双覆盖结构。
