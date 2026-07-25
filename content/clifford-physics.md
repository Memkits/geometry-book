---
{}
  :id |clifford-physics
  :title "|旋量、时空与量子"
  :summary "|Clifford 关系后来成为旋量表示与 Dirac γ 矩阵的结构基础。描述空间规律的代数，也因此进入电子自旋和相对论时空。"
  :kind :section
  :parent |clifford-algebra
  :tags $ #{} "|旋量" "|物理"
  :links $ [] |cartan-spinors |minkowski-spacetime |dirac-square-root
---
## 旋量、时空与量子

### Cartan：旋转还有一种更深的表示

Élie Cartan 在 1913 年研究正交群表示时系统引入旋量。普通向量旋转 $360^\circ$ 后回到自身；旋量却可能改变符号，要旋转 $720^\circ$ 才完全复原。这不是物体真的需要转两圈，而是旋量所在的表示空间以二对一方式覆盖普通旋转群。

在群论语言中，

$$
Spin(n)\longrightarrow SO(n)
$$

是双重覆盖。Clifford 代数的偶可逆元素自然生成 $Spin(n)$，因此 Clifford 乘法提供了旋量最直接的代数住所。

### Pauli 与 Dirac：空间代数进入量子理论

1920 年代，量子力学迫使物理学家处理不交换的观测量。Pauli 矩阵描述自旋 $1/2$，并满足与三维欧氏 Clifford 关系相近的反对易结构。

1928 年，Paul Dirac 寻找同时满足量子叠加和狭义相对论的电子方程。他希望把二次能量关系

$$
E^2=c^2\mathbf p^2+m^2c^4
$$

写成对时间和空间导数都为一阶的方程。为使“平方”恢复原来的二次型，系数不能是普通数，而必须满足


$$
\gamma^\mu\gamma^\nu+\gamma^\nu\gamma^\mu=2\eta^{\mu\nu}I,
$$

这正是由 Minkowski 度量 $\eta$ 生成的 Clifford 关系。Dirac 方程于是写成

$$
(i\gamma^\mu\partial_\mu-m)\psi=0.
$$

方程不仅给出电子自旋，还带来负能量解，并最终导向反粒子预言。1932 年正电子被发现，使这条由代数一致性推出的路线获得实验支持。

### Brauer、Weyl 与结构的重新辨认

Dirac 最初使用矩阵解决物理问题；随后 Brauer 与 Weyl 等人在 1930 年代明确连接 Clifford 代数、旋量和正交群表示。矩阵不是结构本身，而是 Clifford 代数在某个向量空间上的一种表示。换一组 γ 矩阵不会改变底层几何关系。

因此 Clifford 代数在现代物理中承担三项相互关联的工作：

- 编码时空度量及其签名；
- 生成 Lorentz/Spin 变换；
- 提供费米子态和 Dirac 算子的表示空间。

从 Grassmann 的有向面积、Clifford 的二次型，到 Cartan 的旋量和 Dirac 的电子方程，抽象代数一步步变成描述物质如何存在于时空中的语言。下一篇文章将从物理侧回看同一次汇合：Maxwell、Lorentz、Poincaré、Einstein 与 Minkowski 如何把空间和时间改写为一个四维几何对象。

### 继续查证

- [MacTutor：Hermann Grassmann](https://mathshistory.st-andrews.ac.uk/Biographies/Grassmann/)
- [MacTutor：William Kingdon Clifford](https://mathshistory.st-andrews.ac.uk/Biographies/Clifford/)
- [Nobel Prize：Paul Dirac 生平与相对论电子理论](https://www.nobelprize.org/prizes/physics/1933/dirac/biographical/)
