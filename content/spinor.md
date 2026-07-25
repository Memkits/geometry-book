---
{}
  :id |spinor
  :title "|旋量"
  :summary "|不是普通向量，而是空间旋转群双覆盖下的基本对象。"
  :kind :concept
  :era "|1913 起"
  :formula "|ψ′ = Rψ"
  :links $ [] |su2 |clifford-algebra |quantum-spin |dirac-equation |cartan-spinors |dirac-square-root
  :relations $ []
    {} (:direction :incoming) (:source |su2) (:kind :constructs) (:label "|基本表示")
    {} (:direction :incoming) (:source |clifford-algebra) (:kind :constructs) (:label "|最小理想")
    {} (:direction :outgoing) (:target |quantum-spin) (:kind :application) (:label "|描述")
    {} (:direction :outgoing) (:target |dirac-equation) (:kind :depends) (:label "|波函数类型")
    {} (:direction :incoming) (:source |cartan-spinors) (:kind :constructs) (:label "|系统发现")
    {} (:direction :outgoing) (:target |dirac-square-root) (:kind :depends) (:label "|电子状态")
---
# 旋量

不是普通向量，而是空间旋转群双覆盖下的基本对象。

## 历史脉络

Cartan 系统发展旋量，Pauli 与 Dirac 将其带入量子物理。

## 数学结构

$$
ψ′ = Rψ
$$

## 现实意义

旋量揭示空间对称性具有向量看不到的“半角”结构。

## 深入理解

电子波函数是旋量；其符号在 360° 旋转后改变。
