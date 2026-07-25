---
{}
  :id |robotics
  :title "|机器人与航天"
  :summary "|姿态估计、传感器融合、轨迹规划都依赖旋转几何。"
  :kind :application
  :era "|现代"
  :formula "|q̇ = ½ωq"
  :links $ [] |quaternion-rotation |conformal-geometric-algebra
  :relations $ []
    {} (:direction :incoming) (:source |quaternion-rotation) (:kind :application) (:label "|姿态控制")
    {} (:direction :incoming) (:source |conformal-geometric-algebra) (:kind :application) (:label "|刚体运动")
---
# 机器人与航天

姿态估计、传感器融合、轨迹规划都依赖旋转几何。

## 历史脉络

从航天器制导到现代 SLAM，四元数成为标准姿态表示之一。

## 数学结构

$$
q̇ = ½ωq
$$

## 现实意义

紧凑、稳定的旋转表示直接影响控制精度与系统安全。

## 深入理解

双四元数和共形几何代数还能统一旋转与平移。
