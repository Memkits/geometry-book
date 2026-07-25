---
{}
  :id |quaternions
  :title "|四元数"
  :summary "|四维实代数 a+bi+cj+dk，用非交换乘法编码三维旋转。"
  :kind :concept
  :era "|1843"
  :formula "|q = a+bi+cj+dk"
  :tags $ #{} "|数系" "|三维空间" "|旋转" "|非交换"
  :links $ [] |complex-numbers |hamilton |noncommutativity |quaternion-rotation |su2 |clifford-algebra |frobenius-theorem |vector-analysis-debate
  :queue $ [] |quaternion-problem |quaternion-product |quaternion-use
  :relations $ []
    {} (:direction :incoming) (:source |complex-numbers) (:kind :extends) (:label "|高维推广")
    {} (:direction :incoming) (:source |hamilton) (:kind :history) (:label "|发现")
    {} (:direction :outgoing) (:target |noncommutativity) (:kind :principle) (:label "|核心性质")
    {} (:direction :outgoing) (:target |quaternion-rotation) (:kind :theorem) (:label "|实现")
    {} (:direction :outgoing) (:target |su2) (:kind :structure) (:label "|同构于单位群")
    {} (:direction :outgoing) (:target |clifford-algebra) (:kind :unified-by) (:label "|特殊结构")
    {} (:direction :outgoing) (:target |frobenius-theorem) (:kind :theorem) (:label "|唯一性分类")
    {} (:direction :outgoing) (:target |vector-analysis-debate) (:kind :history) (:label "|语言竞争")
---
# 四元数

四维实代数 a+bi+cj+dk，用非交换乘法编码三维旋转。

## 历史脉络

Hamilton 寻找三维复数多年，发现三维系统不成立而必须增加第四维标量。

## 数学结构

$$
q = a+bi+cj+dk
$$

## 现实意义

单位四元数稳定表示姿态，无万向节死锁，适合连续插值。

## 深入理解

纯虚四元数可对应三维向量；共轭与范数给出逆元。
