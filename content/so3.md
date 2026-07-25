---
{}
  :id |so3
  :title "|旋转群 SO(3)"
  :summary "|所有保持三维长度与定向的线性变换组成的群。"
  :kind :structure
  :era "|19世纪"
  :formula "|RᵀR=I, detR=1"
  :links $ [] |quaternion-rotation |su2 |rotor
  :relations $ []
    {} (:direction :incoming) (:source |quaternion-rotation) (:kind :represents) (:label "|表示旋转")
    {} (:direction :incoming) (:source |su2) (:kind :covers) (:label "|双重覆盖")
    {} (:direction :incoming) (:source |rotor) (:kind :represents) (:label "|覆盖表示")
---
# 旋转群 SO(3)

所有保持三维长度与定向的线性变换组成的群。

## 历史脉络

Lie 群理论将连续对称变换系统化。

## 数学结构

$$
RᵀR=I, detR=1
$$

## 现实意义

它描述刚体真正可见的姿态空间，但拓扑上不是简单连通的。

## 深入理解

矩阵表示直观，但插值和数值优化常不如四元数稳定。
