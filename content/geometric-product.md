---
{}
  :id |geometric-product
  :title "|几何乘积"
  :summary "|把内积与外积合并为单一、可逆且结合的乘法。"
  :kind :operation
  :era "|1878"
  :formula "|uv = u·v + u∧v"
  :links $ [] |wedge-product |inner-product |clifford-algebra |reflection
  :relations $ []
    {} (:direction :incoming) (:source |wedge-product) (:kind :component) (:label "|方向部分")
    {} (:direction :incoming) (:source |inner-product) (:kind :component) (:label "|度量部分")
    {} (:direction :incoming) (:source |clifford-algebra) (:kind :constructs) (:label "|定义核心乘法")
    {} (:direction :outgoing) (:target |reflection) (:kind :theorem) (:label "|推导")
---
# 几何乘积

把内积与外积合并为单一、可逆且结合的乘法。

## 历史脉络

Clifford 代数的核心运算，20 世纪由 Hestenes 等重新推广。

## 数学结构

$$
uv = u·v + u∧v
$$

## 现实意义

一个运算同时回答“多接近同向”和“张成什么平面”。

## 深入理解

交换部分是内积，反交换部分是外积。
