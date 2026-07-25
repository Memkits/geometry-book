---
{}
  :id |clifford-algebra
  :title "|Clifford 代数"
  :summary "|由向量和二次型生成、统一长度与子空间的分次代数。"
  :kind :concept
  :era "|1878"
  :formula "|uv+vu = 2g(u,v)"
  :tags $ #{} "|几何代数" "|任意维" "|度量" "|旋量"
  :links $ [] |clifford |quaternions |exterior-algebra |geometric-product |spinor |minkowski-spacetime |maxwell-field |dirac-equation |conformal-geometric-algebra |cartan-spinors
  :queue $ [] |clifford-synthesis |geometric-product-card |clifford-physics
  :relations $ []
    {} (:direction :incoming) (:source |clifford) (:kind :history) (:label "|统一创建")
    {} (:direction :incoming) (:source |quaternions) (:kind :unified-by) (:label "|特殊结构")
    {} (:direction :incoming) (:source |exterior-algebra) (:kind :extends) (:label "|加入度量")
    {} (:direction :outgoing) (:target |geometric-product) (:kind :constructs) (:label "|定义核心乘法")
    {} (:direction :outgoing) (:target |spinor) (:kind :constructs) (:label "|最小理想")
    {} (:direction :outgoing) (:target |minkowski-spacetime) (:kind :represents) (:label "|时空代数")
    {} (:direction :outgoing) (:target |maxwell-field) (:kind :application) (:label "|统一表达")
    {} (:direction :outgoing) (:target |dirac-equation) (:kind :application) (:label "|γ矩阵关系")
    {} (:direction :outgoing) (:target |conformal-geometric-algebra) (:kind :extends) (:label "|增加零维度")
    {} (:direction :outgoing) (:target |cartan-spinors) (:kind :history) (:label "|表示工具")
---
# Clifford 代数

由向量和二次型生成、统一长度与子空间的分次代数。

## 历史脉络

Clifford 综合四元数的度量乘法与 Grassmann 的外代数。

## 数学结构

$$
uv+vu = 2g(u,v)
$$

## 现实意义

复数、四元数、旋量和 Dirac 矩阵都可置于共同框架中。

## 深入理解

不同度量签名 Cl(p,q) 描述不同几何与时空结构。
