
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |reel.calcit/ |respo-markdown.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |*knowledge-network-instances $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defatom *knowledge-network-instances $ {}
          :examples $ []
        |card-queue $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn card-queue (node blueprint)
              if (some? blueprint)
                let
                    queue $ or (:queue blueprint) ([])
                  if (empty? queue) (markdown-chapter-cards blueprint)
                    filter
                      map queue $ fn (id) (get knowledge-docs id)
                      , some?
                knowledge-sections node
          :examples $ []
        |card-recommendations $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn card-recommendations (selected-id active-card blueprint)
              let
                  related-items $ related-knowledge-nodes selected-id
                  explicit $ concat
                    or (:links active-card) ([])
                    or (:links blueprint) ([])
                  ids $ distinct
                    concat explicit $ map related-items
                      fn (item) (:id item)
                map (take ids 10)
                  fn (id)
                    let
                        node $ find-knowledge-node id
                        card $ find-card-blueprint id
                        relation-info $ find related-items
                          fn (item)
                            = id $ :id item
                      {} (:id id)
                        :label $ :label node
                        :summary $ :summary node
                        :kind $ kind-label (:kind node)
                        :relation $ or (:relation relation-info) "|相关线索"
                        :direction $ or (:direction relation-info) "|↗"
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
        |comp-global-map-network $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defcomp comp-global-map-network (graph-data)
              [] (effect-knowledge-network graph-data)
                div
                  {} $ :class-name style-overview-network
                  div
                    {} $ :class-name style-overview-network-note
                    <> "|关系网络 · 拖动空白处平移，滚轮缩放；颜色对应数域、四元数、几何代数与时空主线。"
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
                  map-view? $ = (:view state) :map
                  related $ card-recommendations selected-id active-section blueprint
                  timeline-active-id $ or
                    find history-timeline-ids $ fn (id) (= id selected-id)
                    find history-timeline-ids $ fn (id)
                      = id $ :parent blueprint
                    , selected-id
                  navigate! $ fn (target-id d!)
                    d! cursor $ {} (:selected target-id) (:active-section |history)
                      :history $ take-last
                        conj
                          filter visit-history $ fn (id) (not= id selected-id)
                          , selected-id
                        , 12
                div
                  {} $ :class-name style-reader-page
                  div
                    {} $ :class-name style-history-timeline
                    div
                      {} $ :class-name style-history-overview
                      div
                        {} $ :class-name style-history-kicker
                        <> |HISTORY
                      div
                        {} $ :class-name style-history-caption
                        <> "|数域 › 几何 › 时空"
                    list->
                      {} $ :class-name style-history-track
                      map-indexed history-timeline-ids $ fn (idx id)
                        let
                            target $ find-knowledge-node id
                            current? $ = id timeline-active-id
                            visited? $ some?
                              find visit-history $ fn (visited-id) (= visited-id id)
                          [] idx $ div
                            {} $ :class-name style-history-item
                            button
                              {}
                                :class-name $ if current? (str-spaced style-history-node style-history-node-current)
                                  if visited? (str-spaced style-history-node style-history-node-visited) style-history-node
                                :on-click $ fn (e d!) (navigate! id d!)
                              div
                                {} $ :class-name style-history-era
                                <> $ history-milestone-era id
                              div
                                {} $ :class-name style-history-label
                                <> $ :label target
                            when
                              < idx $ dec (count history-timeline-ids)
                              cond
                                  = idx 1
                                  span
                                    {} $ :class-name style-history-connector-group
                                    <> "|↳ 几何"
                                (= idx 3)
                                  span
                                    {} $ :class-name style-history-connector-group
                                    <> "|↳ 时空"
                                true $ span
                                  {} $ :class-name style-history-connector
                                  <> "|→"
                    button
                      {} (:class-name style-history-map-toggle)
                        :on-click $ fn (e d!)
                          d! cursor $ assoc state :view :map
                      <> |MAP
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
                        <> "|当前文章结构"
                      div
                        {} $ :class-name style-reader-nav-title
                        <> $ str "|共 " (count sections) "| 节 · 点击小节定位"
                      list->
                        {} $ :class-name style-reader-outline-list
                        map-indexed sections $ fn (idx section)
                          [] idx $ button
                            {}
                              :class-name $ if
                                = active-id $ :id section
                                str-spaced style-reader-outline-item style-reader-outline-active
                                , style-reader-outline-item
                              :on-click $ fn (e d!)
                                d! cursor $ assoc state :active-section (:id section)
                            span
                              {} $ :class-name style-reader-outline-index
                              <> $ str |0 (+ idx 1)
                            span
                              {} $ :class-name style-reader-outline-label
                              <> $ :title section
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
                          map-indexed
                            distinct $ reverse visit-history
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
                      list->
                        {} $ :class-name style-reader-dimension-grid
                        map-indexed (knowledge-dimensions node)
                          fn (idx dimension)
                            [] idx $ div
                              {} $ :class-name style-reader-dimension-card
                              div
                                {} $ :class-name style-reader-dimension-label
                                <> $ :label dimension
                              div
                                {} $ :class-name style-reader-dimension-value
                                <> $ :value dimension
                      when
                        some? $ :tags blueprint
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
                            {} $ :class-name style-reader-section-head
                            div
                              {} $ :class-name style-reader-section-heading
                              span
                                {} $ :class-name style-reader-section-number
                                <> $ str |0 (+ idx 1)
                              div
                                {} $ :class-name style-reader-section-title
                                <> $ :title section
                            div
                              {} $ :class-name style-reader-section-tags
                              <> $ str |#
                                join-str
                                  .to-list $ or (:tags section) (#{} "|文章")
                                  , "|　#"
                          div
                            {} $ :class-name style-reader-section-preview
                            comp-md-block
                              markdown-body-without-title $ :content section
                              {}
                          when
                            not $ empty?
                              or (:links section) ([])
                            div
                              {} $ :class-name style-reader-section-footer
                              span
                                {} $ :class-name style-reader-section-footer-label
                                <> |LINKS
                              span
                                {} $ :class-name style-reader-section-footer-links
                                <> $ section-links-text section
                  div
                    {} $ :class-name style-reader-right
                    div
                      {} $ :class-name style-reader-detail-kicker
                      <> "|RELATIONS / NEXT"
                    div
                      {} $ :class-name style-reader-detail-title
                      <> "|关系与推荐"
                    div
                      {} $ :class-name style-reader-detail-hint
                      <> $ str "|基于“" (:title active-section) "|”的链接、标签与知识边生成"
                    list->
                      {} $ :class-name style-reader-related-cards
                      map-indexed related $ fn (idx item)
                        [] idx $ button
                          {} (:class-name style-reader-related-card)
                            :on-click $ fn (e d!)
                              navigate! (:id item) d!
                          div
                            {} $ :class-name style-reader-related-relation
                            <> $ str (:direction item) "|  " (:relation item) "|  ·  " (:kind item)
                          div
                            {} $ :class-name style-reader-related-title
                            <> $ :label item
                          div
                            {} $ :class-name style-reader-related-summary
                            <> $ :summary item
                          when
                            some? $ :tags item
                            div
                              {} $ :class-name style-reader-tag-row
                              list-> ({})
                                map-indexed
                                  take
                                    .to-list $ :tags item
                                    , 4
                                  fn (tag-idx tag)
                                    [] tag-idx $ span
                                      {} $ :class-name style-reader-tag
                                      <> $ str |# tag
                  when map-view? $ div
                    {} $ :class-name style-overview-map
                    div
                      {} $ :class-name style-overview-map-head
                      div
                        {} $ :class-name style-overview-map-kicker
                        <> |GLOBAL-MAP
                      button
                        {} (:class-name style-overview-map-close)
                          :on-click $ fn (e d!)
                            d! cursor $ assoc state :view :reader
                        <> "|返回阅读"
                    div
                      {} $ :class-name style-overview-map-title
                      <> "|从数域扩张到时空结构"
                    div
                      {} $ :class-name style-overview-map-note
                      <> $ str "|按四条主线浏览 " (count knowledge-nodes) "| 个知识节点；每张卡片都保留其历史位置、数学角色、空间维度和可继续追踪的关系。"
                    comp-global-map-network $ knowledge-network-elements
                    div
                      {} $ :class-name style-overview-map-summary
                      span ({}) (<> "|浅蓝：复数与数域")
                      span ({}) (<> "|浅紫：四元数与旋转")
                      span ({}) (<> "|浅绿：外代数与几何代数")
                      span ({}) (<> "|浅橙：时空、旋量与量子")
          :examples $ []
        |effect-knowledge-network $ %{} :CodeEntry (:doc |)
          :code $ quote
            defeffect effect-knowledge-network (graph-data) (action el at-place?)
              when (= action :mount) (fcose cytoscape)
              when (= action :mount)
                let
                    options $ js-object (:container el)
                      :elements $ to-js-data graph-data
                      :autoungrabify true
                      :boxSelectionEnabled false
                      :style $ to-js-data
                        concat
                          [] $ {} (:selector |node)
                            :style $ {} (:label "|data(label)") (:shape |round-rectangle)
                          [] $ {} (:selector |node)
                            :style $ {} (:width 148) (:height 54)
                          [] $ {} (:selector |node)
                            :style $ {} (:padding 0) (:font-size |11px)
                          [] $ {} (:selector |node)
                            :style $ {} (:font-weight |600) (:text-wrap |wrap)
                          [] $ {} (:selector |node)
                            :style $ {} (:text-max-width |110px) (:text-valign |center)
                          [] $ {} (:selector |node)
                            :style $ {} (:text-halign |center) (:color |#36506e)
                          [] $ {} (:selector |node)
                            :style $ {} (:background-color |#edf6ff) (:border-width |1px)
                          [] $ {} (:selector |node)
                            :style $ {} (:border-color |#9fc8ed) (:overlay-opacity |0)
                          [] $ {} (:selector "|node[domain = 'complex']")
                            :style $ {} (:background-color |#e8f3ff) (:border-color |#8abcea)
                          [] $ {} (:selector "|node[domain = 'quaternion']")
                            :style $ {} (:background-color |#f2edff) (:border-color |#ad98e8)
                          [] $ {} (:selector "|node[domain = 'geometric']")
                            :style $ {} (:background-color |#e8f8f2) (:border-color |#8acfb3)
                          [] $ {} (:selector "|node[domain = 'spacetime']")
                            :style $ {} (:background-color |#fff3e6) (:border-color |#efb783)
                          [] $ {} (:selector |edge)
                            :style $ {} (:width |1.2px) (:line-color |#b9cce0)
                          [] $ {} (:selector |edge)
                            :style $ {} (:target-arrow-color |#b9cce0) (:target-arrow-shape |triangle)
                          [] $ {} (:selector |edge)
                            :style $ {} (:curve-style |bezier) (:arrow-scale |0.7)
                          [] $ {} (:selector |edge)
                            :style $ {} (:opacity |0.72) (:overlay-opacity |0)
                      :layout $ js-object (:name |fcose) (:animate false) (:fit false) (:padding 96) (:quality |proof) (:nodeRepulsion 90000) (:idealEdgeLength 380) (:edgeElasticity 0.15) (:nodeSeparation 120) (:gravity 0.02) (:gravityRange 3.8) (:numIter 2500) (:tilingPaddingVertical 60) (:tilingPaddingHorizontal 60) (:tile true) (:randomize true) (:nodeDimensionsIncludeLabels true)
                    cy $ cytoscape options
                  swap! *knowledge-network-instances $ fn (instances) (assoc instances el cy)
                  js/window.setTimeout
                    fn () (.!resize cy) (.!center cy)
                    , 24
              when (= action :unmount)
                let
                    cy $ get @*knowledge-network-instances el
                  when (some? cy) (.!destroy cy)
                    swap! *knowledge-network-instances $ fn (instances) (dissoc instances el)
          :examples $ []
          :schema $ :: :fn
            {} (:return :dynamic)
              :args $ [] :dynamic
              :features $ #{} :js-ffi
        |find-card-blueprint $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn find-card-blueprint (id) (get knowledge-docs id)
          :examples $ []
        |find-knowledge-node $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn find-knowledge-node (id)
              find knowledge-nodes $ fn (node)
                = id $ :id node
          :examples $ []
        |graph-domain-key $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn graph-domain-key (doc)
              let
                  id $ :id doc
                cond
                    contains? (#{} |real-numbers |complex-numbers |complex-origin |complex-equations |complex-plane-section |complex-multiplication |complex-structure |imaginary-unit |argand-plane |cardano-casus |bombelli-algebra |wessel-argand-gauss |euler-formula |fundamental-theorem-algebra) id
                    , |complex
                  (contains? (#{} |quaternions |quaternion-problem |quaternion-product |quaternion-rotation |quaternion-use |hamilton |noncommutativity |so3 |su2 |robotics |computer-graphics) id)
                    , |quaternion
                  (contains? (#{} |minkowski-spacetime |spacetime-unification |hyperbolic-rotation |spacetime-fields |lorentz-transform |maxwell-field |dirac-equation |dirac-square-root |quantum-spin) id)
                    , |spacetime
                  true |geometric
          :examples $ []
        |history-milestone-era $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn history-milestone-era (id)
              case-default id "|跨时期" (|complex-numbers "|1545—1831") (|quaternions |1843) (|grassmann |1844) (|clifford-algebra |1878) (|minkowski-spacetime |1908) (|spinor |1913) (|dirac-equation |1928)
          :examples $ []
        |history-timeline-ids $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def history-timeline-ids $ [] |complex-numbers |quaternions |grassmann |clifford-algebra |minkowski-spacetime |spinor |dirac-equation
          :examples $ []
        |kind-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn kind-label (kind)
              case-default kind "|知识节点" (:concept "|核心概念") (:theorem "|定理与公式") (:person "|历史人物") (:operation "|代数运算") (:principle "|基本原理") (:structure "|数学结构") (:representation "|几何表示") (:application "|现实应用")
          :examples $ []
        |knowledge-bundle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-bundle $ load-knowledge-docs
          :examples $ []
        |knowledge-dimensions $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn knowledge-dimensions (doc)
              []
                {} (:label "|历史时间")
                  :value $ or (:era doc) "|跨时期"
                {} (:label "|数域／结构")
                  :value $ number-domain-label doc
                {} (:label "|空间维度")
                  :value $ space-dimension-label doc
                {} (:label "|知识角色")
                  :value $ kind-label (:kind doc)
          :examples $ []
        |knowledge-doc-diagnostics $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-doc-diagnostics $ :diagnostics knowledge-bundle
          :examples $ []
        |knowledge-doc-reference-ids $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn knowledge-doc-reference-ids (doc)
              concat
                or (:links doc) ([])
                concat
                  or (:queue doc) ([])
                  concat
                    if
                      some? $ :parent doc
                      [] $ :parent doc
                      []
                    map
                      or (:relations doc) ([])
                      fn (relation)
                        if
                          = :outgoing $ :direction relation
                          :target relation
                          :source relation
          :examples $ []
        |knowledge-doc-warnings $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-doc-warnings $ :warnings knowledge-doc-diagnostics
          :examples $ []
        |knowledge-docs $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-docs $ :docs knowledge-bundle
          :examples $ []
        |knowledge-edges $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-edges $ mapcat
              .to-list $ vals knowledge-docs
              fn (doc)
                map
                  filter
                    or (:relations doc) ([])
                    fn (relation)
                      = :outgoing $ :direction relation
                  fn (relation)
                    {}
                      :source $ :id doc
                      :target $ :target relation
                      :relation $ :label relation
                      :kind $ :kind relation
          :examples $ []
        |knowledge-network-elements $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn knowledge-network-elements () $ concat
              map knowledge-nodes $ fn (doc)
                {} $ :data
                  {}
                    :id $ :id doc
                    :label $ :label doc
                    :era $ :era doc
                    :domain $ graph-domain-key doc
                    :kind $ kind-label (:kind doc)
              map knowledge-edges $ fn (edge)
                {} $ :data
                  {}
                    :id $ str (:source edge) "|→" (:target edge)
                    :source $ :source edge
                    :target $ :target edge
                    :label $ :relation edge
                    :kind $ :kind edge
          :examples $ []
        |knowledge-nodes $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-nodes $ filter
              .to-list $ vals knowledge-docs
              fn (doc)
                not= :section $ :kind doc
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
        |load-knowledge-docs $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defmacro load-knowledge-docs () $ let
                paths $ filter (read-dir |content true)
                  fn (path) (not= path |content/README.md)
                pairs $ map paths
                  fn (path)
                    let
                        lines $ split-lines (read-file path)
                        closing-index $ inc
                          find-index (rest lines)
                            fn (line) (= line |---)
                        metadata $ parse-cirru-edn
                          join-str (slice lines 1 closing-index) "|\n"
                        body $ join-str
                          slice lines (inc closing-index) (count lines)
                          , "|\n"
                        doc $ assoc
                          assoc (assoc metadata :content body) :source path
                          , :label (:title metadata)
                      [] (:id doc) doc
                diagnostics $ validate-knowledge-docs! pairs
                errors $ :errors diagnostics
                warnings $ :warnings diagnostics
                _warnings $ &doseq (warning warnings)
                  eprintln |[knowledge-warning] $ :message warning
                _errors $ when-not (empty? errors)
                  raise $ str "|Knowledge validation failed:\n"
                    join-str
                      map errors $ fn (error)
                        str "|- " $ :message error
                      , "|\n"
                serialized $ format-cirru-edn
                  {}
                    :docs $ pairs-map pairs
                    :diagnostics diagnostics
              quasiquote $ parse-cirru-edn ~serialized
          :examples $ []
        |markdown-body-without-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn markdown-body-without-title (content)
              let
                  lines $ split-lines content
                  first-line $ first lines
                if (starts-with? first-line "|## ")
                  join-str (rest lines) "|\n"
                  , content
          :examples $ []
        |markdown-chapter-cards $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn markdown-chapter-cards (doc)
              let
                  parts $ split (:content doc) "|\n## "
                map-indexed parts $ fn (idx part)
                  let
                      lines $ split-lines part
                      first-line $ first lines
                      heading-in-content? $ starts-with? first-line "|## "
                      chapter-title $ if heading-in-content? (slice first-line 3)
                        if (= idx 0)
                          str (:title doc) "|：概览"
                          , first-line
                      chapter-content $ if
                        or heading-in-content? $ > idx 0
                        join-str (rest lines) "|\n"
                        , part
                    {}
                      :id $ str (:id doc) |-chapter- idx
                      :title chapter-title
                      :tags $ or (:tags doc)
                        #{} $ kind-label (:kind doc)
                      :links $ or (:links doc) ([])
                      :content chapter-content
          :examples $ []
        |number-domain-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn number-domain-label (doc)
              let
                  id $ :id doc
                cond
                    contains? (#{} |real-numbers) id
                    , "|实数域 ℝ"
                  (contains? (#{} |complex-numbers |complex-origin |complex-equations |complex-plane-section |complex-multiplication |complex-structure |imaginary-unit |argand-plane |cardano-casus |bombelli-algebra |wessel-argand-gauss |euler-formula |fundamental-theorem-algebra) id)
                    , "|复数域 ℂ"
                  (contains? (#{} |quaternions |quaternion-problem |quaternion-product |quaternion-rotation |quaternion-use |hamilton |noncommutativity |so3 |su2 |robotics |computer-graphics) id)
                    , "|四元数代数 ℍ"
                  (contains? (#{} |exterior-algebra |grassmann |wedge-product |inner-product |geometric-product |geometric-product-card |clifford-algebra |clifford |clifford-synthesis |clifford-physics |reflection |rotor |spinor |cartan-spinors |conformal-geometric-algebra) id)
                    , "|外代数 / Clifford"
                  (contains? (#{} |minkowski-spacetime |spacetime-unification |hyperbolic-rotation |spacetime-fields |lorentz-transform |maxwell-field |dirac-equation |dirac-square-root |quantum-spin) id)
                    , "|时空与算子代数"
                  true "|跨结构"
          :examples $ []
        |overview-lanes $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def overview-lanes $ []
              {} (:title "|复数与数域扩张") (:note "|从方程障碍、虚数单位到复平面与旋转的统一语言")
                :ids $ [] |real-numbers |cardano-casus |bombelli-algebra |imaginary-unit |complex-origin |complex-numbers |complex-equations |fundamental-theorem-algebra |euler-formula |wessel-argand-gauss |argand-plane |complex-structure |complex-multiplication
              {} (:title "|四元数与旋转群") (:note "|非交换乘法如何组织三维旋转、姿态与计算实现")
                :ids $ [] |hamilton |quaternion-problem |quaternions |quaternion-product |noncommutativity |quaternion-rotation |quaternion-use |so3 |su2 |robotics |computer-graphics
              {} (:title "|外代数与几何代数") (:note "|方向、面积、度量和变换怎样进入统一代数结构")
                :ids $ [] |grassmann |exterior-algebra |wedge-product |inner-product |geometric-product |geometric-product-card |clifford |clifford-algebra |reflection |rotor |conformal-geometric-algebra |frobenius-theorem |vector-analysis-debate
              {} (:title "|时空、旋量与量子") (:note "|由不定度量、Lorentz 对称性走向 Dirac 方程与物理解释")
                :ids $ [] |minkowski-spacetime |hyperbolic-rotation |lorentz-transform |maxwell-field |spacetime-unification |spacetime-fields |spinor |cartan-spinors |dirac-square-root |dirac-equation |quantum-spin |clifford-physics |clifford-synthesis
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
        |section-links-text $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn section-links-text (section)
              let
                  links $ or (:links section) ([])
                  labels $ map links
                    fn (id)
                      let
                          doc $ get knowledge-docs id
                          target $ find-knowledge-node id
                        or (:title doc) (:label target) id
                join-str labels "| · "
          :examples $ []
        |space-dimension-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn space-dimension-label (doc)
              let
                  id $ :id doc
                cond
                    contains? (#{} |real-numbers) id
                    , |1D
                  (contains? (#{} |complex-numbers |complex-plane-section |complex-multiplication |complex-structure |argand-plane |imaginary-unit |euler-formula |wessel-argand-gauss) id)
                    , |2D
                  (contains? (#{} |quaternions |quaternion-rotation |quaternion-use |computer-graphics |robotics |so3 |su2) id)
                    , "|3D 旋转"
                  (contains? (#{} |minkowski-spacetime |spacetime-unification |hyperbolic-rotation |spacetime-fields |lorentz-transform |maxwell-field |dirac-equation |dirac-square-root) id)
                    , "|4D 时空"
                  (contains? (#{} |exterior-algebra |wedge-product |inner-product |geometric-product |clifford-algebra |reflection |rotor |spinor |conformal-geometric-algebra) id)
                    , "|nD 可扩展"
                  true "|结构维度"
          :examples $ []
        |style-history-caption $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-caption $ {}
              |& $ {} (:margin-top |1px) (:font-size |11px) (:font-weight |680) (:color |#50647f)
          :examples $ []
        |style-history-connector $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-connector $ {}
              |& $ {} (:display |flex) (:align-items |center) (:justify-content |center) (:flex "|0 0 10px") (:margin "|0 1px") (:font-size |10px) (:font-weight |700) (:color |#b4c3d4)
          :examples $ []
        |style-history-connector-group $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-connector-group $ {}
              |& $ {} (:display |flex) (:align-items |center) (:justify-content |center) (:flex "|0 0 42px") (:margin "|0 2px") (:font-size |9px) (:font-weight |720) (:letter-spacing |0.03em) (:color |#91a6c0) (:white-space |nowrap)
          :examples $ []
        |style-history-era $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-era $ {}
              |& $ {} (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |9px) (:font-weight |650) (:letter-spacing |0.06em) (:color |#9aacbf) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
          :examples $ []
        |style-history-item $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-item $ {}
              |& $ {} (:display |flex) (:align-items |center) (:flex "|0 0 auto") (:min-width |0px)
          :examples $ []
        |style-history-kicker $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-kicker $ {}
              |& $ {} (:font-size |9px) (:font-weight |760) (:letter-spacing |0.15em) (:color |#91a5bd)
          :examples $ []
        |style-history-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-label $ {}
              |& $ {} (:margin-top |0px) (:font-size |11px) (:font-weight |720) (:line-height |1.25) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
          :examples $ []
        |style-history-map-toggle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-map-toggle $ {}
              |& $ {} (:flex "|0 0 auto") (:padding "|5px 7px") (:border "|1px solid #cbdff4") (:border-radius |6px) (:background |#ffffff) (:color |#3b6895) (:font-size |10px) (:font-weight |700) (:letter-spacing |.06em) (:cursor |pointer)
          :examples $ []
        |style-history-node $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-node $ {}
              |& $ {} (:flex "|0 0 auto") (:min-width |0px) (:padding "|4px 6px") (:border "|1px solid #dfeaf6") (:border-radius |6px) (:background "|rgba(255,255,255,.72)") (:text-align |left) (:color |#64758d) (:cursor |pointer) (:transition "|background-color 150ms ease, border-color 150ms ease, box-shadow 150ms ease, transform 150ms ease") (:outline |none) (:display |flex) (:align-items |center) (:gap |4px)
              |&:hover $ {} (:transform "|translateY(-1px)") (:border-color |#bfd5ef) (:background |#ffffff) (:box-shadow "|0 6px 16px rgba(89, 125, 170, .09)")
          :examples $ []
        |style-history-node-current $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-node-current $ {}
              |& $ {} (:border-color |#9fc3ef) (:background "|linear-gradient(145deg, #ffffff, #eef6ff)") (:color |#34587f) (:box-shadow "|0 0 0 2px rgba(152, 194, 242, .16), 0 7px 18px rgba(83, 125, 176, .10)")
          :examples $ []
        |style-history-node-visited $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-node-visited $ {}
              |& $ {} (:background |#f7fbff) (:border-color |#d2e2f3) (:color |#71859e)
          :examples $ []
        |style-history-overview $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-overview $ {}
              |& $ {} (:display |flex) (:align-items |center) (:gap |5px) (:flex "|0 0 116px") (:min-width |116px) (:padding-left |2px) (:white-space |nowrap)
          :examples $ []
        |style-history-timeline $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-timeline $ {}
              |& $ {} (:grid-column "|1 / -1") (:display |flex) (:align-items |center) (:gap |12px) (:min-height |52px) (:box-sizing |border-box) (:padding "|6px 14px") (:background "|rgba(250, 253, 255, .90)") (:border-bottom "|1px solid #dce9f6") (:box-shadow "|0 8px 28px rgba(82, 117, 166, .06)") (:backdrop-filter "|blur(18px)") (:z-index |10)
          :examples $ []
        |style-history-track $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-history-track $ {}
              |& $ {} (:display |flex) (:align-items |center) (:flex |1) (:min-width |0px) (:overflow-x |auto) (:padding "|2px 0 4px")
          :examples $ []
        |style-overview-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card $ {}
              |& $ {} (:width |100%) (:padding |12px) (:border "|1px solid #dce8f4") (:border-radius |9px) (:background |#ffffff) (:color |#334b68) (:text-align |left) (:cursor |pointer) (:transition "|transform 160ms ease, box-shadow 160ms ease, border-color 160ms ease")
              |&:hover $ {} (:transform "|translateY(-2px)") (:border-color |#afd2f5) (:box-shadow "|0 10px 22px rgba(74, 125, 181, .12)")
          :examples $ []
        |style-overview-card-era $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-era $ {}
              |& $ {} (:font-size |10px) (:font-weight |720) (:letter-spacing |.08em) (:color |#7190b1)
          :examples $ []
        |style-overview-card-list $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-list $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |10px)
          :examples $ []
        |style-overview-card-meta $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-meta $ {}
              |& $ {} (:display |flex) (:align-items |center) (:justify-content |space-between) (:gap |6px) (:font-size |10px) (:font-weight |700) (:letter-spacing |.04em) (:color |#7190b1)
          :examples $ []
        |style-overview-card-metric $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-metric $ {}
              |& $ {} (:padding "|3px 5px") (:border-radius |4px) (:background |#eff5fb)
          :examples $ []
        |style-overview-card-metrics $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-metrics $ {}
              |& $ {} (:display |flex) (:flex-wrap |wrap) (:gap |4px) (:margin-top |9px) (:font-size |10px) (:color |#66809d)
          :examples $ []
        |style-overview-card-summary $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-summary $ {}
              |& $ {} (:font-size |12px) (:line-height |1.55) (:color |#62768e)
          :examples $ []
        |style-overview-card-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-card-title $ {}
              |& $ {} (:margin "|4px 0 6px") (:font-size |16px) (:font-weight |720) (:color |#2a4c70)
          :examples $ []
        |style-overview-lane $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-lane $ {}
              |& $ {} (:min-height |0px) (:padding |15px) (:border "|1px solid #d8e7f5") (:border-radius |12px) (:background "|rgba(255,255,255,.72)") (:box-shadow "|0 12px 32px rgba(83, 119, 165, .07)")
          :examples $ []
        |style-overview-lane-note $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-lane-note $ {}
              |& $ {} (:margin "|5px 0 15px") (:font-size |12px) (:line-height |1.45) (:color |#71839a)
          :examples $ []
        |style-overview-lane-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-lane-title $ {}
              |& $ {} (:font-size |17px) (:font-weight |720) (:color |#294b70)
          :examples $ []
        |style-overview-map $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map $ {}
              |& $ {} (:position |fixed) (:top |52px) (:right |0px) (:bottom |0px) (:left |0px) (:z-index |20) (:box-sizing |border-box) (:overflow-y |auto) (:padding "|26px 32px 36px") (:background "|linear-gradient(135deg, #f6fbff 0%, #fbf9ff 52%, #f2fcfb 100%)") (:color |#263650)
          :examples $ []
        |style-overview-map-close $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-close $ {}
              |& $ {} (:padding "|8px 11px") (:border "|1px solid #bdd8f4") (:border-radius |7px) (:background |#ffffff) (:color |#3d6a98) (:font-size |12px) (:font-weight |650) (:cursor |pointer)
          :examples $ []
        |style-overview-map-grid $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-grid $ {}
              |& $ {} (:display |grid) (:grid-template-columns "|repeat(4, minmax(240px, 1fr))") (:gap |14px) (:margin "|0px auto") (:max-width |1740px)
          :examples $ []
        |style-overview-map-head $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-head $ {}
              |& $ {} (:display |flex) (:align-items |center) (:justify-content |space-between) (:gap |20px) (:margin "|0 auto 24px") (:max-width |1500px)
          :examples $ []
        |style-overview-map-kicker $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-kicker $ {}
              |& $ {} (:font-size |10px) (:font-weight |760) (:letter-spacing |.14em) (:color |#6080a2)
          :examples $ []
        |style-overview-map-note $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-note $ {}
              |& $ {} (:margin "|4px auto 18px") (:max-width |1740px) (:font-size |13px) (:line-height |1.45) (:color |#667d98)
          :examples $ []
        |style-overview-map-summary $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-summary $ {}
              |& $ {} (:display |flex) (:gap |10px) (:flex-wrap |wrap) (:max-width |1740px) (:margin "|0 auto 10px") (:color |#6e86a2) (:font-size |13px)
          :examples $ []
        |style-overview-map-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-map-title $ {}
              |& $ {} (:margin-top |5px) (:font-size |27px) (:font-weight |720) (:letter-spacing |-.035em) (:color |#1e3858)
          :examples $ []
        |style-overview-network $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-network $ {}
              |& $ {} (:height "|calc(100vh - 176px)") (:min-height |760px) (:margin "|0 auto 16px") (:max-width |1740px) (:border "|1px solid #d7e7f5") (:border-radius |12px) (:background "|rgba(255,255,255,.78)") (:box-shadow "|0 10px 30px rgba(83, 119, 165, .07)") (:overflow |hidden) (:position |relative)
          :examples $ []
        |style-overview-network-note $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-overview-network-note $ {}
              |& $ {} (:position |absolute) (:top |12px) (:left |14px) (:z-index |2) (:padding "|5px 7px") (:border "|1px solid rgba(193, 216, 238, .84)") (:border-radius |5px) (:background "|rgba(250,253,255,.90)") (:color |#607a98) (:font-size |11px) (:pointer-events |none)
          :examples $ []
        |style-reader-article-head $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-article-head $ {}
              |& $ {} (:max-width |1180px) (:margin |0) (:padding "|8px 0 24px") (:border-bottom "|1px solid #d6e6f7")
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
        |style-reader-dimension-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-dimension-card $ {}
              |& $ {} (:min-width 0) (:padding "|10px 12px 12px") (:border "|1px solid #d8e6f5") (:border-radius |8px) (:background "|linear-gradient(145deg, rgba(255,255,255,.92), rgba(242,247,255,.84))") (:box-shadow "|0 5px 16px rgba(82,117,166,.06)")
          :examples $ []
        |style-reader-dimension-grid $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-dimension-grid $ {}
              |& $ {} (:display |grid) (:grid-template-columns "|repeat(4, minmax(0, 1fr))") (:gap |8px) (:margin-top |20px)
          :examples $ []
        |style-reader-dimension-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-dimension-label $ {}
              |& $ {} (:font-size |10px) (:font-weight |700) (:letter-spacing |0.08em) (:color |#8292aa)
          :examples $ []
        |style-reader-dimension-value $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-dimension-value $ {}
              |& $ {} (:margin-top |5px) (:font-size |14px) (:font-weight |680) (:color |#3c567a) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
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
              |& $ {} (:width |100%) (:min-height |40px) (:padding "|8px 12px") (:border "|1px solid #dce7f3") (:border-radius |8px) (:background "|rgba(255,255,255,.72)") (:color |#53657f) (:font-size |14px) (:font-weight |600) (:text-align |left) (:cursor |pointer)
              |&:hover $ {} (:border-color |#b8d1f1) (:background |#f6faff)
          :examples $ []
        |style-reader-left $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-left $ {}
              |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|20px 16px 32px") (:background "|rgba(247, 251, 255, .82)") (:overflow-y |auto) (:border-right "|1px solid #d9e7f6") (:box-shadow "|8px 0 30px rgba(85, 119, 166, .07)") (:backdrop-filter "|blur(18px)") (:min-height |0px)
          :examples $ []
        |style-reader-meta $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-meta $ {}
              |& $ {} (:font-size |13px) (:font-weight |720) (:letter-spacing |0.08em) (:color |#5b77a1)
          :examples $ []
        |style-reader-middle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-middle $ {}
              |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|24px clamp(24px, 2.5vw, 48px) 48px") (:background "|rgba(255, 255, 255, .76)") (:overflow-y |auto) (:backdrop-filter "|blur(12px)") (:min-height |0px)
          :examples $ []
        |style-reader-nav-button $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-button $ {}
              |& $ {} (:width |100%) (:min-height |44px) (:padding "|12px 12px") (:border "|1px solid #d7e4f3") (:border-left "|3px solid #aac8ef") (:border-radius |8px) (:background "|rgba(255,255,255,.82)") (:box-shadow "|0 6px 18px rgba(82,117,166,.07)") (:color |#33445f) (:font-size |15px) (:font-weight |650) (:text-align |left) (:cursor |pointer) (:transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease")
              |&:hover $ {} (:border-color |#b4cff1) (:box-shadow "|0 10px 22px rgba(82,117,166,.12)") (:transform "|translateY(-1px)")
          :examples $ []
        |style-reader-nav-list $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-list $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |10px)
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
        |style-reader-outline-active $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-outline-active $ {}
              |& $ {} (:background |#f8fbff) (:border-color |#b9d7f6) (:color |#24598c) (:box-shadow "|0 4px 12px rgba(81, 135, 194, .08)")
          :examples $ []
        |style-reader-outline-index $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-outline-index $ {}
              |& $ {} (:flex "|0 0 19px") (:width |19px) (:height |19px) (:border-radius |50%) (:background |#eaf2fb) (:color |#7591af) (:font-size |9px) (:font-weight |700) (:line-height |19px) (:text-align |center)
          :examples $ []
        |style-reader-outline-item $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-outline-item $ {}
              |& $ {} (:display |flex) (:align-items |center) (:gap |7px) (:width |100%) (:padding "|7px 8px") (:border "|1px solid transparent") (:border-radius |7px) (:background |transparent) (:color |#73839a) (:font-size |12px) (:line-height |1.25) (:text-align |left) (:cursor |pointer) (:transition "|background-color 150ms ease, border-color 150ms ease, color 150ms ease")
              |&:hover $ {} (:background |#ffffff) (:border-color |#d8e6f5) (:color |#435b78)
          :examples $ []
        |style-reader-outline-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-outline-label $ {}
              |& $ {} (:overflow |hidden) (:white-space |nowrap) (:text-overflow |ellipsis)
          :examples $ []
        |style-reader-outline-list $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-outline-list $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |4px) (:margin-top |8px)
          :examples $ []
        |style-reader-page $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-page $ {}
              |& $ {} (:position |fixed) (:inset 0) (:display |grid) (:grid-template-columns "|272px minmax(680px, 1fr) minmax(340px, 410px)") (:background "|linear-gradient(135deg, #edf5ff 0%, #f7f4ff 48%, #eef9fb 100%)") (:font-family "|Inter, IBM Plex Sans, Segoe UI, -apple-system, sans-serif") (:color |#263650) (:overflow |hidden) (:grid-template-rows "|auto minmax(0, 1fr)")
          :examples $ []
        |style-reader-related-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-card $ {}
              |& $ {} (:padding "|16px 16px 20px") (:border "|1px solid #d7e5f4") (:border-top "|2px solid #b8d1f2") (:border-radius |8px) (:background "|linear-gradient(145deg, rgba(255,255,255,.94), rgba(245,249,255,.88))") (:box-shadow "|0 8px 24px rgba(82,117,166,.08)") (:text-align |left) (:cursor |pointer) (:transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease, background-color 160ms ease")
              |&:hover $ {} (:border-color |#afcbef) (:border-top-color |#82aef2) (:background |#f7fbff) (:box-shadow "|0 12px 30px rgba(82,117,166,.13)") (:transform "|translateY(-2px)")
          :examples $ []
        |style-reader-related-cards $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-cards $ {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |8px) (:margin-top |18px)
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
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |4px) (:width |100%) (:padding "|12px 12px") (:border "|1px solid #d7e5f4") (:border-left "|3px solid #a9c9f2") (:border-radius |8px) (:background "|rgba(255,255,255,.80)") (:box-shadow "|0 6px 18px rgba(82,117,166,.07)") (:text-align |left) (:cursor |pointer) (:transition "|border-color 160ms ease, transform 160ms ease, box-shadow 160ms ease")
              |&:hover $ {} (:border-color |#b2cef1) (:transform "|translateY(-1px)") (:box-shadow "|0 10px 24px rgba(82,117,166,.11)")
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
              |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|24px 20px 40px") (:background "|rgba(248, 251, 255, .82)") (:border-left "|1px solid #d9e7f6") (:box-shadow "|-8px 0 30px rgba(85, 119, 166, .06)") (:overflow-y |auto) (:backdrop-filter "|blur(18px)") (:min-height |0px)
          :examples $ []
        |style-reader-section-active $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-active $ {}
              |& $ {} (:border-color |#a9c9f4) (:border-left-color |#79a9ef) (:background "|linear-gradient(135deg, #f7fbff 0%, #f5f3ff 100%)") (:box-shadow "|0 16px 38px rgba(100, 126, 189, .16), 0 0 0 1px rgba(137,178,238,.12)") (:transform "|translateY(-2px)")
          :examples $ []
        |style-reader-section-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-card $ {}
              |& $ {} (:width |100%) (:box-sizing |border-box) (:padding "|24px 28px 28px") (:border "|1px solid #d8e6f5") (:border-left "|4px solid #b9d3f4") (:border-radius |8px) (:background "|linear-gradient(145deg, rgba(255,255,255,.96), rgba(247,251,255,.90))") (:box-shadow "|0 10px 28px rgba(82, 117, 166, .09), inset 0 1px 0 rgba(255,255,255,.95)") (:text-align |left) (:color |#263650) (:cursor |pointer) (:transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease, background-color 160ms ease")
              |&:hover $ {} (:border-color |#a9c9f4) (:border-left-color |#82aef2) (:transform "|translateY(-2px)") (:box-shadow "|0 14px 34px rgba(82, 117, 166, .14), 0 0 0 1px rgba(166,203,247,.18)")
          :examples $ []
        |style-reader-section-footer $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-footer $ {}
              |& $ {} (:display |flex) (:align-items |baseline) (:gap |10px) (:margin-top |18px) (:padding-top |11px) (:border-top "|1px solid #e8f0f8") (:font-size |12px) (:line-height |1.5) (:color |#8b9bb0)
          :examples $ []
        |style-reader-section-footer-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-footer-label $ {}
              |& $ {} (:flex-shrink |0) (:font-size |10px) (:font-weight |720) (:letter-spacing |0.11em) (:text-transform |uppercase) (:color |#a2b0c2)
          :examples $ []
        |style-reader-section-footer-links $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-footer-links $ {}
              |& $ {} (:overflow |hidden) (:text-overflow |ellipsis) (:white-space |nowrap) (:color |#7e90a8)
          :examples $ []
        |style-reader-section-grid $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-grid $ {}
              |& $ {} (:max-width |1180px) (:margin "|16px 0 0") (:display |flex) (:flex-direction |column) (:gap |12px) (:padding-bottom |24px)
          :examples $ []
        |style-reader-section-head $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-head $ {}
              |& $ {} (:display |flex) (:align-items |baseline) (:justify-content |space-between) (:gap |18px) (:width |100%)
          :examples $ []
        |style-reader-section-heading $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-heading $ {}
              |& $ {} (:display |flex) (:align-items |baseline) (:min-width |0px) (:flex |1)
          :examples $ []
        |style-reader-section-hint $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-hint $ {}
              |& $ {} (:margin-top |8px) (:font-size |13px) (:font-weight |620) (:color |#7890ae)
          :examples $ []
        |style-reader-section-number $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-number $ {}
              |& $ {} (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |12px) (:font-weight |720) (:color |#86a0c3)
          :examples $ []
        |style-reader-section-preview $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-preview $ {}
              |& $ {} (:margin-top |20px) (:font-size |17px) (:line-height |1.92) (:letter-spacing |0.005em) (:color |#48576c) (:white-space |pre-wrap)
          :examples $ []
        |style-reader-section-tags $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-tags $ {}
              |& $ {} (:flex-shrink |0) (:max-width |48%) (:font-size |12px) (:font-weight |600) (:line-height |1.5) (:letter-spacing |0.01em) (:text-align |right) (:color |#8295ad)
          :examples $ []
        |style-reader-section-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-title $ {}
              |& $ {} (:margin-top |0px) (:font-size |25px) (:font-weight |750) (:letter-spacing |-0.02em) (:line-height |1.3)
          :examples $ []
        |style-reader-tag $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-tag $ {}
              |& $ {} (:padding "|4px 8px") (:border-radius |6px) (:background "|linear-gradient(135deg, #edf5ff, #f2efff)") (:border "|1px solid #d9e6f5") (:color |#53709a) (:font-size |12px) (:font-weight |620)
          :examples $ []
        |style-reader-tag-row $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-tag-row $ {}
              |& $ {} (:display |flex) (:flex-wrap |wrap) (:gap |7px) (:margin-top |18px)
          :examples $ []
        |validate-knowledge-docs! $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn validate-knowledge-docs! (pairs)
              let
                  ids $ map pairs first
                  docs $ pairs-map pairs
                  duplicates $ distinct
                    filter ids $ fn (id)
                      >
                        count $ filter ids
                          fn (candidate) (= id candidate)
                        , 1
                  duplicate-errors $ map duplicates
                    fn (id)
                      {} (:level :error) (:code :duplicate-id) (:source id)
                        :message $ str "|Duplicate knowledge id: " id
                  broken-reference-errors $ mapcat pairs
                    fn (pair)
                      let
                          doc-id $ first pair
                          doc $ last pair
                          missing $ filter (knowledge-doc-reference-ids doc)
                            fn (target-id)
                              not $ contains? docs target-id
                        map missing $ fn (target-id)
                          {} (:level :error) (:code :broken-reference) (:source doc-id) (:target target-id)
                            :message $ str "|Broken knowledge reference: " doc-id "|→" target-id
                  queue-errors $ mapcat pairs
                    fn (pair)
                      let
                          doc-id $ first pair
                          doc $ last pair
                          invalid $ filter
                            or (:queue doc) ([])
                            fn (target-id)
                              let
                                  target $ get docs target-id
                                or (nil? target)
                                  not= :section $ :kind target
                                  not= doc-id $ :parent target
                        map invalid $ fn (target-id)
                          {} (:level :error) (:code :invalid-queue-entry) (:source doc-id) (:target target-id)
                            :message $ str "|Invalid knowledge queue: " doc-id "|→" target-id
                  relation-errors $ mapcat pairs
                    fn (pair)
                      let
                          doc-id $ first pair
                          invalid $ filter
                            or
                              :relations $ last pair
                              []
                            fn (relation)
                              or
                                not $ or
                                  = :outgoing $ :direction relation
                                  = :incoming $ :direction relation
                                and
                                  = :outgoing $ :direction relation
                                  nil? $ :target relation
                                and
                                  = :incoming $ :direction relation
                                  nil? $ :source relation
                        map invalid $ fn (relation)
                          {} (:level :error) (:code :invalid-relation) (:source doc-id) (:relation relation)
                            :message $ str "|Invalid knowledge relation: " doc-id "|→" (format-cirru-edn relation)
                  warnings $ mapcat pairs
                    fn (pair)
                      let
                          doc-id $ first pair
                          doc $ last pair
                          missing-summary? $ or
                            nil? $ :summary doc
                            = || $ :summary doc
                          missing-tags? $ and
                            not= :section $ :kind doc
                            or
                              nil? $ :tags doc
                              empty? $ :tags doc
                          isolated? $ and
                            not= :section $ :kind doc
                            empty? $ or (:links doc) ([])
                            empty? $ or (:relations doc) ([])
                        concat
                          if missing-summary?
                            [] $ {} (:level :warning) (:code :missing-summary) (:source doc-id)
                              :message $ str "|Missing summary: " doc-id
                            []
                          concat
                            if missing-tags?
                              [] $ {} (:level :warning) (:code :missing-tags) (:source doc-id)
                                :message $ str "|Missing tags: " doc-id
                              []
                            if isolated?
                              [] $ {} (:level :warning) (:code :isolated-node) (:source doc-id)
                                :message $ str "|Isolated knowledge node: " doc-id
                              []
                {}
                  :errors $ concat duplicate-errors
                    concat broken-reference-errors $ concat queue-errors relation-errors
                  :warnings warnings
          :examples $ []
      :ns $ %{} :NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp defeffect <> >> div button span list->
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
            respo-md.comp.md :refer $ comp-md-block
            |cytoscape :default cytoscape
            |cytoscape-fcose :default fcose
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
