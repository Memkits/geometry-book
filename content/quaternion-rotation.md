---
{}
  :id |quaternion-rotation
  :title "|四元数旋转"
  :summary "|通过夹心乘积把向量旋转，同时保持长度。"
  :kind :theorem
  :era "|19世纪"
  :formula "|v′ = qvq⁻¹"
  :links $ [] |quaternions |so3 |rotor |computer-graphics |robotics
  :relations $ []
    {} (:direction :incoming) (:source |quaternions) (:kind :theorem) (:label "|实现")
    {} (:direction :outgoing) (:target |so3) (:kind :represents) (:label "|表示旋转")
    {} (:direction :incoming) (:source |rotor) (:kind :specializes) (:label "|三维特例")
    {} (:direction :outgoing) (:target |computer-graphics) (:kind :application) (:label "|姿态插值")
    {} (:direction :outgoing) (:target |robotics) (:kind :application) (:label "|姿态控制")
---
# 四元数旋转

通过夹心乘积把向量旋转，同时保持长度。

## 历史脉络

Hamilton 的共轭结构后来被系统用于旋转群表示。

Hamilton 在 1843 年首先得到的是一种新数系，而不是今天工程课本中的姿态算法。19 世纪后期，四元数与 Gibbs—Heaviside 向量分析的竞争使“用四元数做旋转”长期处于不同记号体系之间。20 世纪的群论澄清了它的准确位置：单位四元数不是三维旋转本身，而是旋转群 $SO(3)$ 的双重覆盖 $SU(2)\cong S^3$。这正解释了为什么它既适合组合旋转，又不会遭遇欧拉角的坐标奇异。

## 数学结构

$$
v′ = qvq⁻¹
$$

把三维向量嵌入为纯虚四元数 $v=xi+yj+zk$。若 $\mathbf n$ 是单位旋转轴，转角为 $\theta$，取

$$
q=\cos\frac\theta2+\mathbf n\sin\frac\theta2,
\qquad q^{-1}=\bar q.
$$

则 $qvq^{-1}$ 仍是纯虚四元数，并恰好是把 $v$ 绕 $\mathbf n$ 旋转 $\theta$ 后的结果。半角不是人为技巧：四元数共轭在左右各作用一次，因此参数中的 $\theta/2$ 在最终向量上合成为 $\theta$。

长度保持来自乘法范数：当 $|q|=1$ 时，

$$
|qvq^{-1}|=|q|\,|v|\,|q^{-1}|=|v|.
$$

同时，四元数乘法的非交换性精确保存了旋转的次序。若先做 $q_1$ 再做 $q_2$，合成旋转是 $q_2q_1$；这个反序并非记号麻烦，而是“作用先后”进入乘法结构的证据。

## 现实意义

q 与 -q 表示同一旋转，揭示旋转群存在双覆盖结构。

这一点有直接的几何后果。沿着单位四元数球面从 $q$ 连续走到 $-q$，在 $SO(3)$ 看来已经回到了同一姿态；但作为旋量参数，它们仍是两个不同点。故而 $360^\circ$ 会让旋量变号，$720^\circ$ 才回到原值。对刚体姿态而言，二者产生同一个空间方向；对量子自旋态而言，符号差会参与干涉。

工程上常把姿态存成单位四元数并定期归一化。它避免了欧拉角在俯仰接近 $90^\circ$ 时的万向锁，也比直接插值旋转矩阵更容易保持正交性。球面线性插值（slerp）沿 $S^3$ 的大圆前进，因此能给出角速度均匀的转动路径。

## 深入理解

单位四元数构成三维球面 S³，并对应群 SU(2)。

不要把“四元数有四个分量”误读为旋转发生在四维物理空间。四个实分量是对三维旋转的无奇异参数化；真正被旋转的是嵌入为纯虚四元数的三维子空间。下一步的 rotor 会把这个夹心结构推广到任意维 Clifford 代数：旋转不再依赖 $i,j,k$ 三个特定单位，而来自两个向量张成的有向平面。
