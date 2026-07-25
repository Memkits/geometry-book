---
{}
  :id |dirac-equation
  :title "|Dirac 方程"
  :summary "|兼容量子力学与狭义相对论的电子方程。"
  :kind :theorem
  :era "|1928"
  :formula "|(iγᵘ∂ᵤ-m)ψ=0"
  :links $ [] |minkowski-spacetime |spinor |clifford-algebra |quantum-spin |dirac-square-root
  :relations $ []
    {} (:direction :incoming) (:source |minkowski-spacetime) (:kind :depends) (:label "|相对论背景")
    {} (:direction :incoming) (:source |spinor) (:kind :depends) (:label "|波函数类型")
    {} (:direction :incoming) (:source |clifford-algebra) (:kind :application) (:label "|γ矩阵关系")
    {} (:direction :outgoing) (:target |quantum-spin) (:kind :theorem) (:label "|理论解释")
    {} (:direction :incoming) (:source |dirac-square-root) (:kind :theorem) (:label "|推导")
---
# Dirac 方程

兼容量子力学与狭义相对论的电子方程。

## 历史脉络

Dirac 寻找 Klein–Gordon 方程的一阶平方根，引入 γ 矩阵。

## 数学结构

$$
(iγᵘ∂ᵤ-m)ψ=0
$$

## 现实意义

它预言反物质，并表明粒子自旋来自时空 Clifford 结构。

## 深入理解

γ 矩阵满足 Clifford 关系 γᵘγᵛ+γᵛγᵘ=2gᵘᵛ。
