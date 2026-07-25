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

## 数学结构

$$
v′ = qvq⁻¹
$$

## 现实意义

q 与 -q 表示同一旋转，揭示旋转群存在双覆盖结构。

## 深入理解

单位四元数构成三维球面 S³，并对应群 SU(2)。
