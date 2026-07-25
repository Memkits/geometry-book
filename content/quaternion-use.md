---
{}
  :id |quaternion-use
  :title "|从争论到现代姿态计算"
  :summary "|四元数在向量分析兴起后退居边缘，却因单位四元数能稳定表示姿态、避免万向节死锁而在图形学、机器人和航天中复兴。"
  :kind :section
  :parent |quaternions
  :tags $ #{} "|应用" "|计算机图形学"
  :links $ [] |vector-analysis-debate |computer-graphics |robotics
---
## 从争论到现代姿态计算

### 19 世纪：一场关于“几何语言”的争论

Hamilton 和他的学生 Peter Guthrie Tait 希望四元数成为几何与物理的统一语言。Maxwell 熟悉四元数，并从中吸收了标量部分与向量部分的表达方式，但在电磁理论中，完整的四元数记法并不总是最简洁。

19 世纪末，Josiah Willard Gibbs 与 Oliver Heaviside 分别发展出更直接的三维向量分析。他们把纯虚四元数乘积中蕴含的两种成分拆开：

- 点积单独处理投影、功与通量；
- 叉积单独处理旋度、力矩与有向法向。

这种写法更适合工程教材和当时的电磁计算，四元数因此退出许多主流课程。争论表面上是符号优劣，深层问题却是：空间规律应当由一个统一乘法表达，还是拆成若干针对性运算？

### 20 世纪：群论解释它没有真正消失

四元数虽然在初等向量分析中退居边缘，却通过旋转群重新进入现代数学。单位四元数组成三维球面 $S^3$，并与群 $SU(2)$ 同构；它对 $SO(3)$ 是双重覆盖。这一结构后来出现在角动量、量子自旋和旋量理论中。

换言之，Gibbs–Heaviside 语言简化了三维局部计算，Hamilton 语言则保留了旋转复合的整体结构。二者解决的并不是完全相同的问题。

### 从航天姿态到计算机动画

现代姿态系统用四个数和一个单位约束表示三维旋转。它没有 Euler 角在俯仰 $\pm90^\circ$ 附近的坐标奇点，组合旋转只需乘法，归一化也容易控制数值漂移。

航天器必须连续估计自身朝向，不能容忍 Euler 角在特定姿态附近出现参数退化。单位四元数因此适合惯性导航、星敏感器融合和姿态控制。机器人用它组合关节或末端执行器的朝向；计算机视觉用它估计相机位姿。

1985 年，Ken Shoemake 把四元数系统引入计算机图形学动画，并推广球面线性插值 SLERP。它沿单位四元数球面给出恒定角速度的短路径过渡：

$$
\operatorname{Slerp}(q_0,q_1;t)
=\frac{\sin((1-t)\Omega)}{\sin\Omega}q_0
 \frac{\sin(t\Omega)}{\sin\Omega}q_1.
$$

这段历史说明，数学语言的“胜负”往往取决于任务。四元数没有取代向量分析，但当问题从单次点积、叉积转向连续姿态、插值和旋转复合时，它保存的整体结构重新变得不可替代。

### 继续查证

- [MacTutor：William Rowan Hamilton](https://mathshistory.st-andrews.ac.uk/Biographies/Hamilton/)
- [MacTutor：向量分析形成中的问题与争论](https://mathshistory.st-andrews.ac.uk/Extras/Vector_calculus_problems/)
