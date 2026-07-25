---
{}
  :id |minkowski-spacetime
  :title "|Minkowski 时空"
  :summary "|把时间与三维空间统一为具有不定度量的四维几何。"
  :kind :concept
  :era "|1908"
  :formula "|s²=c²t²-x²-y²-z²"
  :tags $ #{} "|时空" "|相对论" "|不定度量" "|物理"
  :links $ [] |inner-product |lorentz-transform |clifford-algebra |dirac-equation |dirac-square-root |maxwell-field
  :queue $ [] |spacetime-unification |hyperbolic-rotation |spacetime-fields
  :relations $ []
    {} (:direction :incoming) (:source |inner-product) (:kind :extends) (:label "|不定度量")
    {} (:direction :outgoing) (:target |lorentz-transform) (:kind :theorem) (:label "|对称变换")
    {} (:direction :incoming) (:source |clifford-algebra) (:kind :represents) (:label "|时空代数")
    {} (:direction :outgoing) (:target |dirac-equation) (:kind :depends) (:label "|相对论背景")
    {} (:direction :outgoing) (:target |dirac-square-root) (:kind :depends) (:label "|二次型")
---
# Minkowski 时空

把时间与三维空间统一为具有不定度量的四维几何。

## 历史脉络

Minkowski 将 Einstein 狭义相对论重写为时空几何。

## 数学结构

$$
s²=c²t²-x²-y²-z²
$$

## 现实意义

不同观察者的空间与时间分解不同，但时空间隔保持不变。

## 深入理解

对应 Clifford 代数的度量签名可取 Cl(1,3) 或 Cl(3,1)。
