---
{}
  :id |computer-graphics
  :title "|计算机图形学"
  :summary "|用四元数和 rotor 控制相机、骨骼、动画与姿态插值。"
  :kind :application
  :era "|20世纪后半叶"
  :formula "|slerp(q₀,q₁,t)"
  :links $ [] |quaternion-rotation
  :relations $ []
    {} (:direction :incoming) (:source |quaternion-rotation) (:kind :application) (:label "|姿态插值")
---
# 计算机图形学

用四元数和 rotor 控制相机、骨骼、动画与姿态插值。

## 历史脉络

Shoemake 在 1985 年将四元数旋转系统引入计算机图形学。

## 数学结构

$$
slerp(q₀,q₁,t)
$$

## 现实意义

避免欧拉角万向节死锁，并沿旋转空间最短路径平滑插值。

## 深入理解

游戏引擎、视觉特效与 VR 跟踪普遍使用单位四元数。
