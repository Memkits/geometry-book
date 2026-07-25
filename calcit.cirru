
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |reel.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |card-queue $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn card-queue (node blueprint)
              if (some? blueprint) (:queue blueprint) (knowledge-sections node)
          :examples $ []
        |card-recommendations $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn card-recommendations (selected-id active-card blueprint)
              let
                  explicit $ concat
                    or (:links active-card) ([])
                    or (:links blueprint) ([])
                  ids $ distinct
                    concat explicit $ map (related-knowledge-nodes selected-id)
                      fn (item) (:id item)
                map (take ids 10)
                  fn (id)
                    let
                        node $ find-knowledge-node id
                        card $ find-card-blueprint id
                      {} (:id id)
                        :label $ :label node
                        :summary $ :summary node
                        :tags $ or (:tags card)
                          #{} $ kind-label (:kind node)
          :examples $ []
        |comp-container $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defcomp comp-container (reel)
              let
                  store $ :store reel
                  states $ :states store
                div ({})
                  comp-knowledge-graph $ >> states :knowledge-graph
                  when dev? $ comp-reel (>> states :reel) reel ({})
          :examples $ []
        |comp-knowledge-graph $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defcomp comp-knowledge-graph (states)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    {} (:selected |complex-numbers) (:active-section |history)
                      :history $ []
                  selected-id $ or (:selected state) |complex-numbers
                  node $ or (find-knowledge-node selected-id) (first knowledge-nodes)
                  blueprint $ find-card-blueprint selected-id
                  sections $ card-queue node blueprint
                  requested-id $ or (:active-section state)
                    :id $ first sections
                  active-section $ or
                    find sections $ fn (section)
                      = requested-id $ :id section
                    first sections
                  active-id $ :id active-section
                  visit-history $ or (:history state) ([])
                  related $ card-recommendations selected-id active-section blueprint
                  navigate! $ fn (target-id d!)
                    d! cursor $ {} (:selected target-id) (:active-section |history)
                      :history $ take-last (conj visit-history selected-id) 12
                div
                  {} $ :class-name style-reader-page
                  div
                    {} $ :class-name style-reader-left
                    div
                      {} $ :class-name style-reader-brand
                      div
                        {} $ :class-name style-reader-eyebrow
                        <> "|MATHEMATICS · SPACE"
                      div
                        {} $ :class-name style-reader-brand-title
                        <> "|空间规律阅读地图"
                      div
                        {} $ :class-name style-reader-brand-note
                        <> "|向左回看 · 在中间阅读 · 向右继续"
                    div
                      {} $ :class-name style-reader-nav-section
                      div
                        {} $ :class-name style-reader-nav-title
                        <> "|起点卡片"
                      list->
                        {} $ :class-name style-reader-nav-list
                        map-indexed ([] |complex-numbers |quaternions |clifford-algebra |minkowski-spacetime)
                          fn (idx id)
                            let
                                target $ find-knowledge-node id
                              [] idx $ button
                                {} (:class-name style-reader-nav-button)
                                  :inner-text $ :label target
                                  :on-click $ fn (e d!) (navigate! id d!)
                    div
                      {} $ :class-name style-reader-nav-section
                      div
                        {} $ :class-name style-reader-nav-title
                        <> "|访问历史"
                      if (empty? visit-history)
                        div
                          {} $ :class-name style-reader-empty-note
                          <> "|访问其他主题后，可从这里返回。"
                        list->
                          {} $ :class-name style-reader-nav-list
                          map-indexed (reverse visit-history)
                            fn (idx id)
                              let
                                  target $ find-knowledge-node id
                                [] idx $ button
                                  {} (:class-name style-reader-history-button)
                                    :inner-text $ str "|←" | (:label target)
                                    :on-click $ fn (e d!) (navigate! id d!)
                    div
                      {} $ :class-name style-reader-nav-section
                      div
                        {} $ :class-name style-reader-nav-title
                        <> "|可返回的关系卡片"
                      list->
                        {} $ :class-name style-reader-nav-list
                        map-indexed related $ fn (idx item)
                          [] idx $ button
                            {} (:class-name style-reader-relation-button)
                              :on-click $ fn (e d!)
                                navigate! (:id item) d!
                            span
                              {} $ :class-name style-reader-relation-tag
                              <> "|关系"
                            span
                              {} $ :class-name style-reader-relation-name
                              <> $ :label item
                  div
                    {} $ :class-name style-reader-middle
                    div
                      {} $ :class-name style-reader-article-head
                      div
                        {} $ :class-name style-reader-meta
                        <> $ str
                          kind-label $ :kind node
                          , "|　·　" (:era node)
                      div
                        {} $ :class-name style-reader-article-title
                        <> $ :label node
                      div
                        {} $ :class-name style-reader-article-summary
                        <> $ :summary node
                      div
                        {} $ :class-name style-reader-formula
                        <> $ :formula node
                      when (some? blueprint)
                        list->
                          {} $ :class-name style-reader-tag-row
                          map-indexed
                            .to-list $ :tags blueprint
                            fn (idx tag)
                              [] idx $ span
                                {} $ :class-name style-reader-tag
                                <> $ str |# tag
                    list->
                      {} $ :class-name style-reader-section-grid
                      map-indexed sections $ fn (idx section)
                        [] idx $ button
                          {}
                            :class-name $ if
                              = active-id $ :id section
                              str-spaced style-reader-section-card style-reader-section-active
                              , style-reader-section-card
                            :on-click $ fn (e d!)
                              d! cursor $ assoc state :active-section (:id section)
                          div
                            {} $ :class-name style-reader-section-number
                            <> $ str |0 (+ idx 1)
                          div
                            {} $ :class-name style-reader-section-title
                            <> $ :title section
                          div
                            {} $ :class-name style-reader-section-hint
                            <> $ str |#
                              join-str
                                .to-list $ or (:tags section) (#{} "|文章")
                                , "|　#"
                          div
                            {} $ :class-name style-reader-section-preview
                            <> $ :content section
                  div
                    {} $ :class-name style-reader-right
                    div
                      {} $ :class-name style-reader-detail-kicker
                      <> "|DEEP READING"
                    div
                      {} $ :class-name style-reader-detail-title
                      <> $ :title active-section
                    div
                      {} $ :class-name style-reader-detail-hint
                      <> "|当前文章卡片"
                    div
                      {} $ :class-name style-reader-detail-body
                      <> $ :content active-section
                    div $ {} (:class-name style-reader-detail-divider)
                    div
                      {} $ :class-name style-reader-detail-subtitle
                      <> "|由 links 与 tags 推荐"
                    list->
                      {} $ :class-name style-reader-related-cards
                      map-indexed related $ fn (idx item)
                        [] idx $ button
                          {} (:class-name style-reader-related-card)
                            :on-click $ fn (e d!)
                              navigate! (:id item) d!
                          div
                            {} $ :class-name style-reader-related-relation
                            <> "|推荐卡片"
                          div
                            {} $ :class-name style-reader-related-title
                            <> $ :label item
                          div
                            {} $ :class-name style-reader-related-summary
                            <> $ :summary item
          :examples $ []
        |find-card-blueprint $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn find-card-blueprint (id)
              find knowledge-card-blueprints $ fn (card)
                = id $ :id card
          :examples $ []
        |find-knowledge-node $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn find-knowledge-node (id)
              find knowledge-nodes $ fn (node)
                = id $ :id node
          :examples $ []
        |kind-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn kind-label (kind)
              case-default kind "|知识节点" (:concept "|核心概念") (:theorem "|定理与公式") (:person "|历史人物") (:operation "|代数运算") (:principle "|基本原理") (:structure "|数学结构") (:representation "|几何表示") (:application "|现实应用")
          :examples $ []
        |knowledge-card-blueprints $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-card-blueprints $ []
              {} (:id |complex-numbers)
                :tags $ #{} "|数系" "|二维空间" "|旋转" "|代数史"
                :links $ [] |imaginary-unit |argand-plane |quaternions
                :queue $ []
                  {} (:id |complex-origin) (:title "|方程逼出的新数")
                    :tags $ #{} "|代数史" "|方程"
                    :links $ [] |cardano-casus |bombelli-algebra
                    :content "|三次方程的不可约情形使数学家即使只求实根，也必须经过负数平方根。复数首先不是几何对象，而是一套在计算中无法回避的中间语言。"
                  {} (:id |complex-plane) (:title "|从符号到平面")
                    :tags $ #{} "|二维空间" "|几何表示"
                    :links $ [] |wessel-argand-gauss |argand-plane
                    :content "|Wessel、Argand 与 Gauss 把 a+bi 放入平面。此时 i 不再神秘：乘以 i 是旋转四分之一周，复数乘法同时组合尺度与角度。"
                  {} (:id |complex-structure) (:title "|乘法中的空间规律")
                    :tags $ #{} "|旋转" "|结构"
                    :links $ [] |euler-formula |fundamental-theorem-algebra
                    :content "|极坐标形式 z=reⁱᶿ 揭示乘法把模长相乘、辐角相加。代数运算因此直接编码二维相似变换，并成为波、振动与相位的自然语言。"
              {} (:id |quaternions)
                :tags $ #{} "|数系" "|三维空间" "|旋转" "|非交换"
                :links $ [] |complex-numbers |hamilton |clifford-algebra
                :queue $ []
                  {} (:id |quaternion-problem) (:title "|为什么三元数失败")
                    :tags $ #{} "|代数史" "|维数"
                    :links $ [] |hamilton |frobenius-theorem
                    :content "|Hamilton 想把复数推广到三维，却发现保留熟悉算律的三元数无法成立。突破来自增加一个标量维度，并接受乘法不再交换。"
                  {} (:id |quaternion-product) (:title "|次序成为几何信息")
                    :tags $ #{} "|非交换" "|旋转"
                    :links $ [] |noncommutativity |quaternion-rotation
                    :content "|ij=k 而 ji=-k。这里的非交换不是缺陷，而是准确记录三维旋转次序：先绕一个轴再绕另一个轴，结果依赖操作顺序。"
                  {} (:id |quaternion-use) (:title "|从争论到现代姿态计算")
                    :tags $ #{} "|应用" "|计算机图形学"
                    :links $ [] |vector-analysis-debate |computer-graphics |robotics
                    :content "|四元数在向量分析兴起后退居边缘，却因单位四元数能稳定表示姿态、避免万向节死锁而在图形学、机器人和航天中复兴。"
              {} (:id |clifford-algebra)
                :tags $ #{} "|几何代数" "|任意维" "|度量" "|旋量"
                :links $ [] |exterior-algebra |quaternions |spinor
                :queue $ []
                  {} (:id |clifford-synthesis) (:title "|Hamilton 与 Grassmann 的汇合")
                    :tags $ #{} "|代数史" "|统一"
                    :links $ [] |grassmann |clifford
                    :content "|Grassmann 的外积记录有向面积与高维扩张，Hamilton 的乘法携带度量和旋转。Clifford 用二次型把两条道路合并。"
                  {} (:id |geometric-product-card) (:title "|一个乘法同时容纳度量与方向")
                    :tags $ #{} "|度量" "|外积"
                    :links $ [] |inner-product |wedge-product |geometric-product
                    :content "|几何乘积 uv=u·v+u∧v。对称部分测量长度和夹角，反对称部分记录张成的有向平面；旋转与反射由统一的夹心乘积表达。"
                  {} (:id |clifford-physics) (:title "|旋量、时空与量子")
                    :tags $ #{} "|旋量" "|物理"
                    :links $ [] |cartan-spinors |minkowski-spacetime |dirac-square-root
                    :content "|Clifford 关系后来成为旋量表示与 Dirac γ 矩阵的结构基础。描述空间规律的代数，也因此进入电子自旋和相对论时空。"
              {} (:id |minkowski-spacetime)
                :tags $ #{} "|时空" "|相对论" "|不定度量" "|物理"
                :links $ [] |lorentz-transform |maxwell-field |dirac-equation
                :queue $ []
                  {} (:id |spacetime-unification) (:title "|空间与时间成为一个对象")
                    :tags $ #{} "|时空" "|相对论"
                    :links $ [] |lorentz-transform
                    :content "|Minkowski 将不同观察者的空间和时间分解统一为四维时空。坐标会改变，但时空间隔保持不变。"
                  {} (:id |hyperbolic-rotation) (:title "|速度变换是双曲旋转")
                    :tags $ #{} "|不定度量" "|变换"
                    :links $ [] |lorentz-transform |clifford-algebra
                    :content "|欧氏旋转保持正定长度，Lorentz 变换保持不定的时空间隔。Clifford 代数让两者都可理解为由度量决定的旋转结构。"
                  {} (:id |spacetime-fields) (:title "|场与粒子共享时空代数")
                    :tags $ #{} "|电磁场" "|量子"
                    :links $ [] |maxwell-field |dirac-square-root |spinor
                    :content "|电场与磁场是同一时空场的不同分解；Dirac 方程则把时空二次型开平方，自然引出反对易关系与旋量。"
          :examples $ []
        |knowledge-edges $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-edges $ []
              {} (:source |real-numbers) (:target |imaginary-unit) (:relation "|扩张") (:kind :depends)
              {} (:source |imaginary-unit) (:target |complex-numbers) (:relation "|生成") (:kind :constructs)
              {} (:source |complex-numbers) (:target |argand-plane) (:relation "|几何表示") (:kind :represents)
              {} (:source |complex-numbers) (:target |euler-formula) (:relation "|指数结构") (:kind :theorem)
              {} (:source |complex-numbers) (:target |fundamental-theorem-algebra) (:relation "|代数闭包") (:kind :theorem)
              {} (:source |complex-numbers) (:target |quaternions) (:relation "|高维推广") (:kind :extends)
              {} (:source |hamilton) (:target |quaternions) (:relation "|发现") (:kind :history)
              {} (:source |quaternions) (:target |noncommutativity) (:relation "|核心性质") (:kind :principle)
              {} (:source |quaternions) (:target |quaternion-rotation) (:relation "|实现") (:kind :theorem)
              {} (:source |quaternion-rotation) (:target |so3) (:relation "|表示旋转") (:kind :represents)
              {} (:source |quaternions) (:target |su2) (:relation "|同构于单位群") (:kind :structure)
              {} (:source |su2) (:target |so3) (:relation "|双重覆盖") (:kind :covers)
              {} (:source |noncommutativity) (:target |quantum-spin) (:relation "|物理体现") (:kind :application)
              {} (:source |grassmann) (:target |exterior-algebra) (:relation "|创立") (:kind :history)
              {} (:source |exterior-algebra) (:target |wedge-product) (:relation "|核心运算") (:kind :constructs)
              {} (:source |wedge-product) (:target |geometric-product) (:relation "|方向部分") (:kind :component)
              {} (:source |inner-product) (:target |geometric-product) (:relation "|度量部分") (:kind :component)
              {} (:source |clifford) (:target |clifford-algebra) (:relation "|统一创建") (:kind :history)
              {} (:source |quaternions) (:target |clifford-algebra) (:relation "|特殊结构") (:kind :unified-by)
              {} (:source |exterior-algebra) (:target |clifford-algebra) (:relation "|加入度量") (:kind :extends)
              {} (:source |clifford-algebra) (:target |geometric-product) (:relation "|定义核心乘法") (:kind :constructs)
              {} (:source |geometric-product) (:target |reflection) (:relation "|推导") (:kind :theorem)
              {} (:source |reflection) (:target |rotor) (:relation "|两次反射复合") (:kind :constructs)
              {} (:source |rotor) (:target |quaternion-rotation) (:relation "|三维特例") (:kind :specializes)
              {} (:source |rotor) (:target |so3) (:relation "|覆盖表示") (:kind :represents)
              {} (:source |su2) (:target |spinor) (:relation "|基本表示") (:kind :constructs)
              {} (:source |clifford-algebra) (:target |spinor) (:relation "|最小理想") (:kind :constructs)
              {} (:source |spinor) (:target |quantum-spin) (:relation "|描述") (:kind :application)
              {} (:source |inner-product) (:target |minkowski-spacetime) (:relation "|不定度量") (:kind :extends)
              {} (:source |minkowski-spacetime) (:target |lorentz-transform) (:relation "|对称变换") (:kind :theorem)
              {} (:source |clifford-algebra) (:target |minkowski-spacetime) (:relation "|时空代数") (:kind :represents)
              {} (:source |lorentz-transform) (:target |maxwell-field) (:relation "|混合电磁分量") (:kind :application)
              {} (:source |clifford-algebra) (:target |maxwell-field) (:relation "|统一表达") (:kind :application)
              {} (:source |minkowski-spacetime) (:target |dirac-equation) (:relation "|相对论背景") (:kind :depends)
              {} (:source |spinor) (:target |dirac-equation) (:relation "|波函数类型") (:kind :depends)
              {} (:source |clifford-algebra) (:target |dirac-equation) (:relation "|γ矩阵关系") (:kind :application)
              {} (:source |dirac-equation) (:target |quantum-spin) (:relation "|理论解释") (:kind :theorem)
              {} (:source |quaternion-rotation) (:target |computer-graphics) (:relation "|姿态插值") (:kind :application)
              {} (:source |quaternion-rotation) (:target |robotics) (:relation "|姿态控制") (:kind :application)
              {} (:source |rotor) (:target |conformal-geometric-algebra) (:relation "|运动算子") (:kind :extends)
              {} (:source |clifford-algebra) (:target |conformal-geometric-algebra) (:relation "|增加零维度") (:kind :extends)
              {} (:source |conformal-geometric-algebra) (:target |robotics) (:relation "|刚体运动") (:kind :application)
              {} (:source |cardano-casus) (:target |imaginary-unit) (:relation "|问题压力") (:kind :history)
              {} (:source |cardano-casus) (:target |bombelli-algebra) (:relation "|促成运算法则") (:kind :history)
              {} (:source |bombelli-algebra) (:target |complex-numbers) (:relation "|建立算术") (:kind :constructs)
              {} (:source |complex-numbers) (:target |wessel-argand-gauss) (:relation "|获得几何解释") (:kind :history)
              {} (:source |wessel-argand-gauss) (:target |argand-plane) (:relation "|平面模型") (:kind :represents)
              {} (:source |quaternions) (:target |frobenius-theorem) (:relation "|唯一性分类") (:kind :theorem)
              {} (:source |quaternions) (:target |vector-analysis-debate) (:relation "|语言竞争") (:kind :history)
              {} (:source |vector-analysis-debate) (:target |inner-product) (:relation "|拆出点积") (:kind :constructs)
              {} (:source |vector-analysis-debate) (:target |wedge-product) (:relation "|高维替代") (:kind :principle)
              {} (:source |clifford-algebra) (:target |cartan-spinors) (:relation "|表示工具") (:kind :history)
              {} (:source |cartan-spinors) (:target |spinor) (:relation "|系统发现") (:kind :constructs)
              {} (:source |spinor) (:target |dirac-square-root) (:relation "|电子状态") (:kind :depends)
              {} (:source |minkowski-spacetime) (:target |dirac-square-root) (:relation "|二次型") (:kind :depends)
              {} (:source |dirac-square-root) (:target |dirac-equation) (:relation "|推导") (:kind :theorem)
          :examples $ []
        |knowledge-nodes $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-nodes $ []
              {} (:id |real-numbers) (:label "|实数") (:kind :concept) (:era "|古代—17世纪") (:summary "|用一条有序数轴统一数量、长度、比例与连续变化。") (:history "|从古希腊比例论、印度负数到笛卡尔数轴，实数逐步成为解析几何与微积分的底座。") (:formula "|x ∈ ℝ") (:meaning "|它把一维空间中的位置和尺度变成可计算对象，但无法封闭求解 x²+1=0。") (:detail "|完备性保证柯西序列收敛，是极限、连续性和微积分成立的深层条件。")
              {} (:id |imaginary-unit) (:label "|虚数单位 i") (:kind :concept) (:era "|16—18世纪") (:summary "|满足 i²=-1 的新单位，突破实数轴的封闭边界。") (:history "|Cardano 在三次方程中遇到负数平方根；Bombelli 首次系统计算，Euler 推广符号 i。") (:formula "|i² = -1") (:meaning "|它不是虚构数量，而是二维平面四分之一转动的代数生成元。") (:detail "|引入 i 后，多项式方程在复数域中获得代数封闭性。")
              {} (:id |complex-numbers) (:label "|复数") (:kind :concept) (:era "|16—19世纪") (:summary "|把两个实数组织成 a+bi，使二维方向和旋转进入乘法。") (:history "|Bombelli 建立运算法则，Argand 与 Gauss 给出平面几何解释。") (:formula "|z = a + bi = reⁱᶿ") (:meaning "|乘法同时完成尺度相乘与角度相加，是波、振动和二维旋转的自然语言。") (:detail "|共轭给出镜像，模长给出距离，辐角给出方向。")
              {} (:id |argand-plane) (:label "|复平面") (:kind :representation) (:era "|1799—1831") (:summary "|将 a+bi 表示为平面点 (a,b)，让代数运算获得几何图像。") (:history "|Wessel、Argand 与 Gauss 分别推进了这一解释。") (:formula "|a+bi ↔ (a,b)") (:meaning "|加法是平移，乘法是旋转与缩放，解析与几何开始真正融合。") (:detail "|复平面使解析函数、保角映射和复分析成为可能。")
              {} (:id |euler-formula) (:label "|Euler 公式") (:kind :theorem) (:era |1748) (:summary "|指数、三角函数和复数旋转在同一公式中相遇。") (:history "|Euler 在《无穷分析引论》中系统使用复指数关系。") (:formula "|eⁱᶿ = cos θ + i sin θ") (:meaning "|连续旋转可由指数生成；微分方程、信号处理与量子相位因此共享语言。") (:detail "|令 θ=π 得 eⁱπ+1=0，连接五个基础常数。")
              {} (:id |fundamental-theorem-algebra) (:label "|代数学基本定理") (:kind :theorem) (:era |1799) (:summary "|每个非常数复系数多项式都在复数中有根。") (:history "|Gauss 的博士论文给出早期证明，后来又提出多种证明。") (:formula "|p(z)=0 has a root in ℂ") (:meaning "|复数不是随意扩张，而是多项式求根所要求的自然闭包。") (:detail "|n 次多项式按重数恰有 n 个复根。")
              {} (:id |hamilton) (:label |Hamilton) (:kind :person) (:era "|1805—1865") (:summary "|试图把复数的二维旋转能力推广到空间，最终发现四元数。") (:history "|1843 年 10 月 16 日，他在都柏林布鲁厄姆桥刻下 i²=j²=k²=ijk=-1。") (:formula "|i²=j²=k²=ijk=-1") (:meaning "|他的突破是接受乘法不交换，从而让代数忠实反映三维旋转的次序。") (:detail "|四元数一度被视为统一物理语言，后来其向量部分推动了向量分析。")
              {} (:id |quaternions) (:label "|四元数") (:kind :concept) (:era |1843) (:summary "|四维实代数 a+bi+cj+dk，用非交换乘法编码三维旋转。") (:history "|Hamilton 寻找三维复数多年，发现三维系统不成立而必须增加第四维标量。") (:formula "|q = a+bi+cj+dk") (:meaning "|单位四元数稳定表示姿态，无万向节死锁，适合连续插值。") (:detail "|纯虚四元数可对应三维向量；共轭与范数给出逆元。")
              {} (:id |noncommutativity) (:label "|非交换性") (:kind :principle) (:era |1843) (:summary "|操作顺序会改变结果：ij=k，而 ji=-k。") (:history "|四元数首次让非交换代数进入主流数学。") (:formula "|ab ≠ ba") (:meaning "|先绕 x 轴再绕 y 轴，不等于相反次序；代数结构映射了真实空间运动。") (:detail "|矩阵、算符和量子可观测量后来都以非交换性为核心。")
              {} (:id |quaternion-rotation) (:label "|四元数旋转") (:kind :theorem) (:era "|19世纪") (:summary "|通过夹心乘积把向量旋转，同时保持长度。") (:history "|Hamilton 的共轭结构后来被系统用于旋转群表示。") (:formula "|v′ = qvq⁻¹") (:meaning "|q 与 -q 表示同一旋转，揭示旋转群存在双覆盖结构。") (:detail "|单位四元数构成三维球面 S³，并对应群 SU(2)。")
              {} (:id |grassmann) (:label |Grassmann) (:kind :person) (:era "|1809—1877") (:summary "|把向量组合推广为有向面积、体积及高维元素。") (:history "|1844 年《线性扩张论》远超时代，数十年后才被充分理解。") (:formula "|u ∧ v") (:meaning "|他把空间从点和坐标提升为可组合的方向子空间。") (:detail "|线性代数、外代数和微分形式都承继了他的思想。")
              {} (:id |exterior-algebra) (:label "|外代数") (:kind :concept) (:era |1844) (:summary "|用分次对象统一标量、向量、有向面积和体积。") (:history "|源自 Grassmann 的扩张论，后来被 Cartan 用于微分形式。") (:formula "|Λ(V)=Λ⁰V⊕Λ¹V⊕⋯") (:meaning "|它自然表达面积、体积、行列式与取向，并推广到任意维。") (:detail "|k-向量表示 k 维有向平行体，而不是普通坐标列表。")
              {} (:id |wedge-product) (:label "|外积") (:kind :operation) (:era |1844) (:summary "|两个方向生成一个有向平面元素。") (:history "|Grassmann 将几何扩张形式化为反对称乘法。") (:formula "|u∧v = -v∧u") (:meaning "|u∧u=0 表示平行方向不能张成面积。") (:detail "|外积的大小等于平行四边形面积，符号记录取向。")
              {} (:id |inner-product) (:label "|内积") (:kind :operation) (:era "|19世纪体系化") (:summary "|从两个向量提取长度、夹角和投影信息。") (:history "|从欧氏几何与解析几何逐步抽象为一般向量空间上的度量。") (:formula "|u·v = ‖u‖‖v‖cosθ") (:meaning "|内积规定了空间如何测量，是几何与拓扑结构之间的重要桥梁。") (:detail "|不同符号的内积产生欧氏空间或 Minkowski 时空。")
              {} (:id |clifford) (:label |Clifford) (:kind :person) (:era "|1845—1879") (:summary "|将 Hamilton 与 Grassmann 的思想结合成统一几何代数。") (:history "|1878 年提出适用于任意维与任意二次型的几何代数。") (:formula "|v² = Q(v)") (:meaning "|他认识到同一个乘法可以同时容纳度量和方向扩张。") (:detail "|Clifford 还预见空间曲率可能与物质分布相关。")
              {} (:id |clifford-algebra) (:label "|Clifford 代数") (:kind :concept) (:era |1878) (:summary "|由向量和二次型生成、统一长度与子空间的分次代数。") (:history "|Clifford 综合四元数的度量乘法与 Grassmann 的外代数。") (:formula "|uv+vu = 2g(u,v)") (:meaning "|复数、四元数、旋量和 Dirac 矩阵都可置于共同框架中。") (:detail "|不同度量签名 Cl(p,q) 描述不同几何与时空结构。")
              {} (:id |geometric-product) (:label "|几何乘积") (:kind :operation) (:era |1878) (:summary "|把内积与外积合并为单一、可逆且结合的乘法。") (:history "|Clifford 代数的核心运算，20 世纪由 Hestenes 等重新推广。") (:formula "|uv = u·v + u∧v") (:meaning "|一个运算同时回答“多接近同向”和“张成什么平面”。") (:detail "|交换部分是内积，反交换部分是外积。")
              {} (:id |reflection) (:label "|反射公式") (:kind :theorem) (:era "|Clifford 几何") (:summary "|单位向量可直接充当镜面法向，夹心乘积完成反射。") (:history "|Cartan–Dieudonné 定理进一步说明正交变换都可分解为反射。") (:formula "|v′ = -nvn⁻¹") (:meaning "|旋转不再是基本操作，而是两次反射的复合。") (:detail "|这为统一旋转、反射与 Lorentz 变换提供算法基础。")
              {} (:id |rotor) (:label |Rotor) (:kind :concept) (:era "|20世纪") (:summary "|Clifford 代数偶子代数中的旋转算子。") (:history "|由旋量与几何代数传统发展而来。") (:formula "|R=e⁻ᴮᶿ⁄², v′=RvR̃") (:meaning "|旋转由平面双向量 B 生成，可自然推广到任意维。") (:detail "|四元数是三维欧氏几何 rotor 的一种具体表现。")
              {} (:id |so3) (:label "|旋转群 SO(3)") (:kind :structure) (:era "|19世纪") (:summary "|所有保持三维长度与定向的线性变换组成的群。") (:history "|Lie 群理论将连续对称变换系统化。") (:formula "|RᵀR=I, detR=1") (:meaning "|它描述刚体真正可见的姿态空间，但拓扑上不是简单连通的。") (:detail "|矩阵表示直观，但插值和数值优化常不如四元数稳定。")
              {} (:id |su2) (:label "|SU(2)") (:kind :structure) (:era "|19—20世纪") (:summary "|二维复酉矩阵中行列式为 1 的群，也是单位四元数群。") (:history "|在 Lie 群与量子力学中成为自旋的核心对称群。") (:formula "|SU(2) → SO(3)") (:meaning "|它双重覆盖 SO(3)，解释自旋 1/2 粒子旋转 720° 才完全复原。") (:detail "|q 和 -q 映射到同一个三维旋转。")
              {} (:id |spinor) (:label "|旋量") (:kind :concept) (:era "|1913 起") (:summary "|不是普通向量，而是空间旋转群双覆盖下的基本对象。") (:history "|Cartan 系统发展旋量，Pauli 与 Dirac 将其带入量子物理。") (:formula "|ψ′ = Rψ") (:meaning "|旋量揭示空间对称性具有向量看不到的“半角”结构。") (:detail "|电子波函数是旋量；其符号在 360° 旋转后改变。")
              {} (:id |minkowski-spacetime) (:label "|Minkowski 时空") (:kind :concept) (:era |1908) (:summary "|把时间与三维空间统一为具有不定度量的四维几何。") (:history "|Minkowski 将 Einstein 狭义相对论重写为时空几何。") (:formula "|s²=c²t²-x²-y²-z²") (:meaning "|不同观察者的空间与时间分解不同，但时空间隔保持不变。") (:detail "|对应 Clifford 代数的度量签名可取 Cl(1,3) 或 Cl(3,1)。")
              {} (:id |lorentz-transform) (:label "|Lorentz 变换") (:kind :theorem) (:era "|1895—1905") (:summary "|保持 Minkowski 间隔的时空变换。") (:history "|Lorentz、Poincaré 与 Einstein 从电磁学和相对性原理中发展出来。") (:formula "|x′ = LxL⁻¹") (:meaning "|在时空代数中，速度变换可视为双曲旋转。") (:detail "|它统一长度收缩、时间膨胀与同时性的相对性。")
              {} (:id |maxwell-field) (:label "|Maxwell 电磁场") (:kind :application) (:era |1865) (:summary "|电场和磁场是同一时空场的不同观察者分解。") (:history "|Maxwell 方程先以分量形式出现，Clifford 语言可将其压缩为一个方程。") (:formula "|∇F = J") (:meaning "|几何代数把四条 Maxwell 方程统一，清楚呈现场的时空结构。") (:detail "|F 是双向量，电与磁在 Lorentz 变换下相互混合。")
              {} (:id |dirac-equation) (:label "|Dirac 方程") (:kind :theorem) (:era |1928) (:summary "|兼容量子力学与狭义相对论的电子方程。") (:history "|Dirac 寻找 Klein–Gordon 方程的一阶平方根，引入 γ 矩阵。") (:formula "|(iγᵘ∂ᵤ-m)ψ=0") (:meaning "|它预言反物质，并表明粒子自旋来自时空 Clifford 结构。") (:detail "|γ 矩阵满足 Clifford 关系 γᵘγᵛ+γᵛγᵘ=2gᵘᵛ。")
              {} (:id |quantum-spin) (:label "|量子自旋") (:kind :application) (:era "|1920年代") (:summary "|粒子的内禀角动量，不是经典小球自转。") (:history "|Stern–Gerlach 实验、Pauli 矩阵与 Dirac 理论共同确立自旋。") (:formula "|S = ℏσ/2") (:meaning "|自旋把 SU(2)、旋量与可观测量的非交换性连接起来。") (:detail "|不同方向的自旋算符不交换，导致测量次序具有物理后果。")
              {} (:id |computer-graphics) (:label "|计算机图形学") (:kind :application) (:era "|20世纪后半叶") (:summary "|用四元数和 rotor 控制相机、骨骼、动画与姿态插值。") (:history "|Shoemake 在 1985 年将四元数旋转系统引入计算机图形学。") (:formula "|slerp(q₀,q₁,t)") (:meaning "|避免欧拉角万向节死锁，并沿旋转空间最短路径平滑插值。") (:detail "|游戏引擎、视觉特效与 VR 跟踪普遍使用单位四元数。")
              {} (:id |robotics) (:label "|机器人与航天") (:kind :application) (:era "|现代") (:summary "|姿态估计、传感器融合、轨迹规划都依赖旋转几何。") (:history "|从航天器制导到现代 SLAM，四元数成为标准姿态表示之一。") (:formula "|q̇ = ½ωq") (:meaning "|紧凑、稳定的旋转表示直接影响控制精度与系统安全。") (:detail "|双四元数和共形几何代数还能统一旋转与平移。")
              {} (:id |conformal-geometric-algebra) (:label "|共形几何代数") (:kind :concept) (:era "|20世纪末") (:summary "|通过增加两个零向量维度，把点、圆、球、直线和平面统一为代数对象。") (:history "|由 Clifford 代数和共形几何结合发展。") (:formula "|Cl(4,1)") (:meaning "|交、并、旋转、平移和反演可在同一框架中计算。") (:detail "|在机器人、视觉和几何计算中具有统一建模潜力。")
              {} (:id |cardano-casus) (:label "|Cardano 与不可约情形") (:kind :history) (:era |1545) (:summary "|三次方程迫使数学家穿过负数平方根，才能返回真实答案。") (:history "|Cardano 在《大术》中公布三次方程公式。对 x³=15x+4，公式出现 √−121，尽管 x=4 明明是实根；这后来称为 casus irreducibilis。") (:formula "|∛(2+√−121)+∛(2−√−121)=4") (:meaning "|复数不是凭空添加的装饰，而是实数问题内部出现的必经中间语言。") (:detail "|当三次方程有三个不同实根时，若坚持只用实根式，Cardano 公式无法绕开复数。求根问题由此暴露实数体系的表达边界。") (:context "|16 世纪代数仍依附几何量，负数尚且可疑，负数的平方根更缺乏直观。") (:breakthrough "|关键转变是承认形式运算可以先于直观，并产生可检验的正确结果。") (:debate "|Cardano 称这些量精微而无用；它们是否是数，取决于存在由直观、运算法则还是解题能力担保。") (:sources "|Cardano《Ars Magna》(1545)；MacTutor《代数学基本定理》历史专题。")
              {} (:id |bombelli-algebra) (:label "|Bombelli 的运算革命") (:kind :history) (:era |1572) (:summary "|Bombelli 首次把虚量当作遵循稳定规则的可计算对象。") (:history "|Bombelli 在《代数学》中系统给出正负虚量的加减乘法，并用它化解 Cardano 公式里的复数中间项。") (:formula "|∛(2+11i)=2+i, ∛(2−11i)=2−i") (:meaning "|数学对象可以先由一致的运算关系获得合法性，几何解释则可能晚两个世纪。") (:detail "|他识别出一对共轭立方根，相加得到 4。这是从无法解释的符号到可控计算系统的关键一步。") (:context "|当时代数记号尚不成熟，Bombelli 还必须发展足以承载新计算的表达方式。") (:breakthrough "|封闭运算法则让虚数从公式故障变成能够配对、消去和验证的对象。") (:legacy "|它奠定复数算术，并预示现代结构观点：对象的意义来自其关系与运算。") (:sources "|Bombelli《L'Algebra》(1572)；MacTutor Rafael Bombelli 传记。")
              {} (:id |wessel-argand-gauss) (:label "|复数获得平面") (:kind :history) (:era "|1799—1831") (:summary "|Wessel、Argand 与 Gauss 让虚数单位成为平面中的四分之一转动。") (:history "|测量员 Wessel 于 1799 年发表几何表示却长期无人注意；Argand 1806 年私印论文；Gauss 的使用与权威推动复数成为标准语言。") (:formula "|(r,θ)(s,φ)=(rs,θ+φ)") (:meaning "|二维几何不是复数的插图：乘法本身就是缩放与旋转的组合律。") (:detail "|把 a+bi 放在 (a,b) 后，共轭是关于实轴反射，模长是距离，乘法使辐角相加；代数与平面相似变换因此汇合。") (:context "|同一观念由测量员、业余数学家与职业数学家多次提出，传播受身份和发表渠道影响。") (:breakthrough "|i²=−1 被重读为两次 90° 旋转等于一次 180° 旋转。") (:debate "|Argand 图这一名称遮蔽 Wessel 更早的公开发表，数学史并非单线英雄史。") (:sources "|Wessel(1799)；Argand(1806)；MacTutor Argand 传记。")
              {} (:id |frobenius-theorem) (:label "|Frobenius 分类定理") (:kind :theorem) (:era |1877) (:summary "|有限维实结合除代数只有 ℝ、ℂ、ℍ；三元数注定失败。") (:history "|Frobenius 证明：若要求有限维、实数上、结合且每个非零元素可除，可能性被压缩为三种。") (:formula "|A ≅ ℝ, ℂ or ℍ") (:meaning "|一维、二维、四维的扩张具有刚性，四元数并非偶然试验品。") (:detail "|定理解释 Hamilton 为何多年找不到三维数系。继续到八元数必须放弃结合律；结构扩张总伴随算律取舍。") (:context "|19 世纪数学从发现单个新数系转向按公理分类所有可能结构。") (:breakthrough "|问题从还能发明什么数，变成给定公理后允许什么结构。") (:legacy "|它引向 Hurwitz 定理：实赋范除代数只可能是 ℝ、ℂ、ℍ、𝕆。") (:sources "|Frobenius《Über lineare Substitutionen und bilineare Formen》(1877)。")
              {} (:id |vector-analysis-debate) (:label "|四元数与向量分析之争") (:kind :history) (:era "|1880—1910") (:summary "|物理计算从四元数拆出点积与叉积，换来简洁，也失去统一乘法。") (:history "|Maxwell 使用过四元数思想；Gibbs 与 Heaviside 为电磁学发展三维向量分析，Tait 等四元数拥护者与新向量派激烈争论。") (:formula "|ab = −a·b + a×b（纯虚四元数）") (:meaning "|今天熟悉的点积和叉积不是唯一语言，而是一次历史性的表示选择。") (:detail "|向量分析对三维工程计算高效，却将标量与有向平面信息拆成不同运算；几何代数后来尝试重新统一。") (:context "|争论涉及教学成本、记号、物理直观与统一性，数学语言的胜出不只由逻辑决定。") (:debate "|叉积高度依赖三维；外积与几何乘积则自然推广到任意维。") (:legacy "|教材最终采用 Gibbs–Heaviside 体系，而图形学与机器人又让四元数复兴。") (:sources "|MacTutor Quaternion Association；Gibbs/Wilson《Vector Analysis》(1901)。")
              {} (:id |cartan-spinors) (:label "|Cartan 的旋量") (:kind :history) (:era |1913) (:summary "|Cartan 发现有些空间对称对象无法由普通向量或张量表达。") (:history "|Cartan 在研究简单 Lie 代数表示时系统发现旋量；Brauer 与 Weyl 于 1935 年用 Clifford 代数构造它们。") (:formula "|Spin(n) → SO(n), kernel={±1}") (:meaning "|向量只看到旋转终点，旋量还记得抵达终点的旋转路径。") (:detail "|360° 旋转在 SO(3) 中回到同一姿态，却让自旋 1/2 旋量变号；720° 后才完全复原。") (:context "|旋量先是表示论的抽象对象，十余年后才获得电子量子理论的物理意义。") (:breakthrough "|描述空间中的物体，与描述空间对称性本身的表示，是两个层次。") (:sources "|Encyclopedia of Mathematics《Spinor representation》；Cartan(1938)。")
              {} (:id |dirac-square-root) (:label "|Dirac：时空方程的平方根") (:kind :history) (:era |1928) (:summary "|Dirac 将相对论能量关系线性化，Clifford 关系随之出现。") (:history "|为兼容量子力学与相对论，Dirac 寻找对时间和空间导数均为一阶的电子方程。") (:formula "|(γ·p)²=p² ⇒ γμγν+γνγμ=2gμν") (:meaning "|γ 矩阵不是技巧：它们是 Minkowski 二次型的 Clifford 代数表示。") (:detail "|线性算符平方后必须恢复 E²=p²c²+m²c⁴，迫使不同方向的 γ 反对易；方程自然包含自旋和负能解。") (:context "|量子力学与狭义相对论各自成功，却使用不兼容的时间与能量结构。") (:breakthrough "|给二次型开平方，把几何度量、非交换代数和粒子波函数锁在同一结构中。") (:legacy "|负能解促成正电子预言，1932 年 Anderson 实验发现正电子。") (:sources "|Dirac《The Quantum Theory of the Electron》(1928)；Encyclopedia of Mathematics。")
          :examples $ []
        |knowledge-sections $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn knowledge-sections (node)
              filter
                []
                  {} (:id |history) (:title "|历史脉络") (:hint "|这个观念为什么会在当时出现")
                    :content $ :history node
                  {} (:id |context) (:title "|时代问题") (:hint "|数学家当时面对的阻力与边界")
                    :content $ :context node
                  {} (:id |detail) (:title "|数学内核") (:hint "|定义、结构与推理的核心")
                    :content $ :detail node
                  {} (:id |breakthrough) (:title "|关键突破") (:hint "|真正改变思考方式的一步")
                    :content $ :breakthrough node
                  {} (:id |meaning) (:title "|现实意义") (:hint "|它怎样改变空间、运动与物理描述")
                    :content $ :meaning node
                  {} (:id |debate) (:title "|争议与误区") (:hint "|容易被简化或误读的地方")
                    :content $ :debate node
                  {} (:id |legacy) (:title "|后续影响") (:hint "|它打开了哪些后续方向")
                    :content $ :legacy node
                  {} (:id |sources) (:title "|资料线索") (:hint "|继续阅读的原始文献与历史资料")
                    :content $ :sources node
                fn (section)
                  some? $ :content section
          :examples $ []
        |related-knowledge-nodes $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn related-knowledge-nodes (id)
              map
                filter knowledge-edges $ fn (edge)
                  or
                    = id $ :source edge
                    = id $ :target edge
                fn (edge)
                  let
                      outgoing? $ = id (:source edge)
                      other-id $ if outgoing? (:target edge) (:source edge)
                      other $ find-knowledge-node other-id
                    {} (:id other-id)
                      :label $ :label other
                      :summary $ :summary other
                      :relation $ :relation edge
                      :direction $ if outgoing? "|→" "|←"
          :examples $ []
        |related-knowledge-text $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn related-knowledge-text (id)
              let
                  edges $ filter knowledge-edges
                    fn (edge)
                      or
                        = id $ :source edge
                        = id $ :target edge
                  labels $ map edges
                    fn (edge)
                      let
                          outgoing? $ = id (:source edge)
                          other-id $ if outgoing? (:target edge) (:source edge)
                          other $ find-knowledge-node other-id
                          arrow $ if outgoing? "|→" "|←"
                        str (:relation edge) "| " arrow "| " $ :label other
                if (empty? labels) "|暂无直接关系" $ join-str labels "|　/　"
          :examples $ []
        |style-reader-article-head $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-article-head $ {}
              |& $ {} (:max-width |880px) (:margin |auto) (:padding-bottom |30px) (:border-bottom "|1px solid #dce3ec")
          :examples $ []
        |style-reader-article-summary $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-article-summary $ {}
              |& $ {} (:margin-top |18px) (:max-width |790px) (:font-size |19px) (:line-height |1.72) (:color |#536278)
          :examples $ []
        |style-reader-article-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-article-title $ {}
              |& $ {} (:margin-top |10px) (:font-size "|clamp(36px, 4vw, 58px)") (:font-weight |780) (:letter-spacing |-0.05em) (:line-height |1.05)
          :examples $ []
        |style-reader-brand $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-brand $ {}
              |& $ {} (:padding "|4px 4px 24px") (:border-bottom "|1px solid #d6dee9")
          :examples $ []
        |style-reader-brand-note $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-brand-note $ {}
              |& $ {} (:margin-top |8px) (:font-size |14px) (:line-height |1.55) (:color |#69788d)
          :examples $ []
        |style-reader-brand-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-brand-title $ {}
              |& $ {} (:margin-top |9px) (:font-size |25px) (:font-weight |760) (:letter-spacing |-0.025em)
          :examples $ []
        |style-reader-detail-body $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-body $ {}
              |& $ {} (:margin-top |26px) (:font-size |18px) (:line-height |1.9) (:color |#435167)
          :examples $ []
        |style-reader-detail-divider $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-divider $ {}
              |& $ {} (:height |1px) (:margin "|34px 0 26px") (:background |#e4e9f0)
          :examples $ []
        |style-reader-detail-hint $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-hint $ {}
              |& $ {} (:margin-top |8px) (:font-size |14px) (:color |#8a96a7)
          :examples $ []
        |style-reader-detail-kicker $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-kicker $ {}
              |& $ {} (:font-size |11px) (:font-weight |760) (:letter-spacing |0.15em) (:color |#7390b7)
          :examples $ []
        |style-reader-detail-subtitle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-subtitle $ {}
              |& $ {} (:font-size |15px) (:font-weight |730) (:color |#243550)
          :examples $ []
        |style-reader-detail-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-detail-title $ {}
              |& $ {} (:margin-top |11px) (:font-size |31px) (:font-weight |770) (:letter-spacing |-0.035em)
          :examples $ []
        |style-reader-empty-note $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-empty-note $ {}
              |& $ {} (:padding "|10px 4px") (:font-size |13px) (:line-height |1.5) (:color |#73849e)
          :examples $ []
        |style-reader-eyebrow $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-eyebrow $ {}
              |& $ {} (:font-size |11px) (:font-weight |750) (:letter-spacing |0.16em) (:color |#5b77a1)
          :examples $ []
        |style-reader-formula $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-formula $ {}
              |& $ {} (:margin-top |22px) (:display |inline-block) (:padding "|13px 17px") (:border "|1px solid #cbd9ec") (:border-radius |10px) (:background |#eaf0f8) (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |18px) (:color |#234d88)
          :examples $ []
        |style-reader-history-button $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-history-button $ {}
              |& $ {} (:width |100%) (:padding "|9px 11px") (:border |none) (:border-radius |8px) (:background |transparent) (:color |#52647d) (:font-size |14px) (:text-align |left) (:cursor |pointer)
              |&:hover $ {} (:background |#ffffff) (:color |#244d82)
          :examples $ []
        |style-reader-left $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-left $ {}
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|28px 22px 40px") (:background |#e9eef5) (:overflow-y |auto) (:border-right "|1px solid #d6dee9")
          :examples $ []
        |style-reader-meta $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-meta $ {}
              |& $ {} (:font-size |13px) (:font-weight |720) (:letter-spacing |0.08em) (:color |#5b77a1)
          :examples $ []
        |style-reader-middle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-middle $ {}
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|42px clamp(32px, 4vw, 70px) 80px") (:background |#f5f7fa) (:overflow-y |auto)
          :examples $ []
        |style-reader-nav-button $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-button $ {}
              |& $ {} (:width |100%) (:padding "|11px 13px") (:border "|1px solid #d8e0ea") (:border-radius |9px) (:background |#ffffff) (:color |#26364e) (:font-size |14px) (:font-weight |650) (:text-align |left) (:cursor |pointer) (:transition "|background-color 180ms ease, transform 180ms ease")
              |&:hover $ {} (:background |#f8fbff) (:transform "|translateX(2px)")
          :examples $ []
        |style-reader-nav-list $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-list $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |7px)
          :examples $ []
        |style-reader-nav-section $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-section $ {}
              |& $ {} (:margin-top |27px)
          :examples $ []
        |style-reader-nav-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-title $ {}
              |& $ {} (:margin "|0 4px 11px") (:font-size |12px) (:font-weight |720) (:letter-spacing |0.1em) (:color |#8091ab)
          :examples $ []
        |style-reader-page $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-page $ {}
              |& $ {} (:position |fixed) (:inset 0) (:display |grid) (:grid-template-columns "|300px minmax(520px, 1fr) minmax(390px, 480px)") (:background |#eef2f7) (:font-family "|-apple-system, BlinkMacSystemFont, Segoe UI, sans-serif") (:color |#182236) (:overflow |hidden)
          :examples $ []
        |style-reader-related-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-card $ {}
              |& $ {} (:padding |15px) (:border "|1px solid #e0e6ee") (:border-radius |11px) (:background |#f8fafc) (:text-align |left) (:cursor |pointer) (:transition "|border-color 180ms ease, transform 180ms ease, background-color 180ms ease")
              |&:hover $ {} (:border-color |#9bb4d5) (:background |#f3f7fc) (:transform "|translateX(-2px)")
          :examples $ []
        |style-reader-related-cards $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-cards $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |10px) (:margin-top |13px)
          :examples $ []
        |style-reader-related-relation $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-relation $ {}
              |& $ {} (:font-size |11px) (:font-weight |720) (:color |#6f8caf)
          :examples $ []
        |style-reader-related-summary $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-summary $ {}
              |& $ {} (:margin-top |6px) (:font-size |13px) (:line-height |1.5) (:color |#788596)
          :examples $ []
        |style-reader-related-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-title $ {}
              |& $ {} (:margin-top |5px) (:font-size |16px) (:font-weight |710) (:color |#26364e)
          :examples $ []
        |style-reader-relation-button $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-relation-button $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |5px) (:width |100%) (:padding "|10px 12px") (:border "|1px solid #d8e0ea") (:border-radius |9px) (:background |#ffffff) (:text-align |left) (:cursor |pointer) (:transition "|border-color 180ms ease, background-color 180ms ease")
              |&:hover $ {} (:border-color |#8fb3e8) (:background |#f8fbff)
          :examples $ []
        |style-reader-relation-name $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-relation-name $ {}
              |& $ {} (:font-size |14px) (:font-weight |650) (:color |#26364e)
          :examples $ []
        |style-reader-relation-tag $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-relation-tag $ {}
              |& $ {} (:font-size |11px) (:font-weight |700) (:color |#7fa6dd)
          :examples $ []
        |style-reader-right $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-right $ {}
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|42px 34px 70px") (:background |#ffffff) (:border-left "|1px solid #dbe2eb") (:overflow-y |auto)
          :examples $ []
        |style-reader-section-active $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-active $ {}
              |& $ {} (:border-color |#4f7fbd) (:background |#f9fbff) (:box-shadow "|0 10px 28px rgba(47,91,151,.15)") (:transform "|translateY(-2px)")
          :examples $ []
        |style-reader-section-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-card $ {}
              |& $ {} (:min-height |210px) (:padding |22px) (:border "|1px solid #d9e0e9") (:border-radius |14px) (:background |#ffffff) (:box-shadow "|0 5px 18px rgba(36,54,80,.055)") (:text-align |left) (:color |#1d2a3e) (:cursor |pointer) (:transition "|border-color 180ms ease, box-shadow 180ms ease, transform 180ms ease, background-color 180ms ease")
              |&:hover $ {} (:transform "|translateY(-2px)") (:box-shadow "|0 10px 28px rgba(47,91,151,.12)")
          :examples $ []
        |style-reader-section-grid $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-grid $ {}
              |& $ {} (:max-width |880px) (:margin "|28px auto 0") (:display |grid) (:grid-template-columns "|repeat(2, minmax(0, 1fr))") (:gap |16px)
          :examples $ []
        |style-reader-section-hint $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-hint $ {}
              |& $ {} (:margin-top |6px) (:font-size |13px) (:color |#8a96a7)
          :examples $ []
        |style-reader-section-number $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-number $ {}
              |& $ {} (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |12px) (:font-weight |720) (:color |#86a0c3)
          :examples $ []
        |style-reader-section-preview $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-preview $ {}
              |& $ {} (:margin-top |15px) (:font-size |15px) (:line-height |1.67) (:color |#59677a) (:display |-webkit-box) (:-webkit-line-clamp 4) (:-webkit-box-orient |vertical) (:overflow |hidden)
          :examples $ []
        |style-reader-section-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-title $ {}
              |& $ {} (:margin-top |10px) (:font-size |21px) (:font-weight |740)
          :examples $ []
        |style-reader-tag $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-tag $ {}
              |& $ {} (:padding "|5px 9px") (:border-radius |999px) (:background |#e5edf8) (:font-size |12px) (:color |#496a97)
          :examples $ []
        |style-reader-tag-row $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-tag-row $ {}
              |& $ {} (:display |flex) (:flex-wrap |wrap) (:gap |7px) (:margin-top |18px)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp <> >> div button span list->
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
    |app.config $ %{} :FileEntry
      :defs $ {}
        |dev? $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def dev? $ = |dev (get-env |mode |release)
          :examples $ []
        |site $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def site $ {} (:storage-key |workflow)
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.config)
    |app.main $ %{} :FileEntry
      :defs $ {}
        |*reel $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defatom *reel $ -> reel-schema/reel (assoc :base schema/store) (assoc :store schema/store)
          :examples $ []
        |dispatch! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn dispatch! (op)
              when
                and config/dev? $ not= op :states
                js/console.log |Dispatch: op
              reset! *reel $ reel-updater updater @*reel op
          :examples $ []
        |main! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn main! ()
              println "|Running mode:" $ if config/dev? |dev |release
              if config/dev? $ load-console-formatter!
              render-app!
              add-watch *reel :changes $ fn (reel prev) (render-app!)
              listen-devtools! |k dispatch!
              js/window.addEventListener |beforeunload $ fn (event) (persist-storage!)
              js/window.addEventListener |visibilitychange $ fn (event)
                if (= |hidden js/document.visibilityState) (persist-storage!)
              flipped js/setInterval 60000 persist-storage!
              let
                  raw $ js/localStorage.getItem (:storage-key config/site)
                when (some? raw)
                  dispatch! $ :: :hydrate-storage (parse-cirru-edn raw)
              println "|App started."
          :examples $ []
          :schema $ :: :fn
            {} (:return :dynamic)
              :args $ []
              :features $ #{} :js-ffi
        |mount-target $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def mount-target $ js/document.querySelector |.app
          :examples $ []
        |persist-storage! $ %{} :CodeEntry (:doc |)
          :code $ quote
            defn persist-storage! ()
              println "|Saved at" $ .!toISOString (new js/Date)
              js/localStorage.setItem (:storage-key config/site)
                format-cirru-edn $ :store @*reel
          :examples $ []
          :schema $ :: :fn
            {} (:return :dynamic)
              :args $ []
              :features $ #{} :js-ffi
        |reload! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn reload! () $ if (nil? build-errors)
              do (remove-watch *reel :changes) (clear-cache!)
                add-watch *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ refresh-reel @*reel schema/store updater
                hud! |ok~ |Ok
              hud! |error build-errors
          :examples $ []
        |render-app! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn render-app! () $ render! mount-target (comp-container @*reel) dispatch!
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.core :refer $ reel-updater refresh-reel
            reel.schema :as reel-schema
            app.config :as config
            |./calcit.build-errors :default build-errors
            |bottom-tip :default hud!
    |app.schema $ %{} :FileEntry
      :defs $ {}
        |store $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote (ns app.schema)
    |app.updater $ %{} :FileEntry
      :defs $ {}
        |updater $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn updater (store op op-id op-time)
              tag-match op
                (:states cursor s) (update-states store cursor s)
                (:hydrate-storage data) data
                _ $ do (eprintln "|unknown op:" op) store
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
