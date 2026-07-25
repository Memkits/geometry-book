---
{}
  :id |complex-numbers
  :title |复数
  :summary "|把两个实数组织成 a+bi，使二维方向、尺度和旋转进入同一种乘法。"
  :kind :topic
  :era |16—19世纪
  :formula "|z = a + bi = reⁱᶿ"
  :tags $ #{} |代数史 |二维空间 |数系 |旋转
  :links $ [] |imaginary-unit |argand-plane |euler-formula |fundamental-theorem-algebra |quaternions |wessel-argand-gauss |bombelli-algebra
  :queue $ [] |complex-equations |complex-plane-section |complex-multiplication
  :relations $ []
    {} (:direction :incoming) (:source |imaginary-unit) (:kind :constructs) (:label "|生成")
    {} (:direction :outgoing) (:target |argand-plane) (:kind :represents) (:label "|几何表示")
    {} (:direction :outgoing) (:target |euler-formula) (:kind :theorem) (:label "|指数结构")
    {} (:direction :outgoing) (:target |fundamental-theorem-algebra) (:kind :theorem) (:label "|代数闭包")
    {} (:direction :outgoing) (:target |quaternions) (:kind :extends) (:label "|高维推广")
    {} (:direction :incoming) (:source |bombelli-algebra) (:kind :constructs) (:label "|建立算术")
    {} (:direction :outgoing) (:target |wessel-argand-gauss) (:kind :history) (:label "|获得几何解释")
---
# 复数：从方程障碍到二维空间语言

复数不是为了给“虚构的数”安排一个位置，而是人类逐步认识到：**二维空间中的尺度与方向，可以被编码进一种乘法结构。**

沿着下面三个小章节，可以看到它如何从三次方程里的计算中间量，变成平面旋转、波动和相位的自然语言。
