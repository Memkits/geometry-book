
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!) (:target :browser)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |reel.calcit/ |respo-markdown.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        '*knowledge-network-instances $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *knowledge-network-instances ({})
          :examples $ []
          :schema $ :: 'Ref $ :: 'Map 'Dynamic 'Dynamic
        'card-queue $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn card-queue (node blueprint)
            let
                queue $ option:unwrap-or (:queue blueprint) ([])
              if (empty? queue) (markdown-chapter-cards blueprint)
                map queue $ fn (id)
                  option:unwrap $ get knowledge-docs id
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/KnowledgeDoc 'app.schema/KnowledgeDoc
            :return $ :: 'List 'app.schema/KnowledgeDoc
        'card-recommendations $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn card-recommendations (selected-id active-card blueprint)
            let
                related-items $ related-knowledge-nodes selected-id
                explicit $ concat
                  option:unwrap-or (:links active-card) ([])
                  option:unwrap-or (:links blueprint) ([])
                ids $ distinct $ concat explicit
                  map related-items $ fn (item)
                    option:unwrap $ get item :id
              map (take ids 10)
                fn (id)
                  let
                      node $ option:unwrap $ find-knowledge-node id
                      card $ option:unwrap $ find-card-blueprint id
                      relation-info $ find related-items $ fn (item)
                        = id $
                          get item :id
                          , .unwrap
                    app.schema/KnowledgeRecommendation :id id :label (:label node) :summary
                      (:summary node) .unwrap-or ||
                      , :kind
                        kind-label $
                          :kind node
                          , .unwrap-or :concept
                        , :relation
                          (get (option:unwrap-or relation-info ({})) :relation)
                            , .unwrap-or "|相关线索"
                          , :direction
                            (get (option:unwrap-or relation-info ({})) :direction)
                              , .unwrap-or "|↗"
                            , :tags $
                              :tags card
                              , .unwrap-or $ #{}
                                kind-label $
                                  :kind node
                                  , .unwrap-or :concept
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String 'app.schema/KnowledgeDoc 'app.schema/KnowledgeDoc
            :return $ :: 'List 'app.schema/KnowledgeRecommendation
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (reel)
            let
                store $ :store reel
                states $
                  get store :states
                  , .unwrap-or $ {}
                branch $ >> states :knowledge-graph
                cursor $ decode-map-as
                  option:unwrap-or (get branch :cursor) ([])
                  :: 'List 'Dynamic
                reader-state $ app.schema/decode-reader-state $ option:unwrap-or (get branch :data) ({})
              div ({}) (comp-knowledge-graph cursor reader-state)
                when dev? $ comp-typed-reel (>> states :reel) reel $ {}
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'reel.typed/State 'app.schema/Op (:: 'Map 'Tag 'Dynamic)
        'comp-global-map-network $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-global-map-network (graph-data)
            [] (effect-knowledge-network graph-data)
              div
                {} $ :class-name style-overview-network
                div
                  {} $ :class-name style-overview-network-note
                  <> "|关系网络 · 拖动空白处平移，滚轮缩放；颜色对应数域、四元数、几何代数与时空主线。"
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] $ :: 'List (:: 'Map 'Tag 'Dynamic)
        'comp-heatmap-view $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-heatmap-view (state cursor)
            div
              {} $ :class-name style-overview-map
              div
                {} $ :class-name style-overview-map-head
                div
                  {} $ :class-name style-overview-map-kicker
                  <> |HEATMAP
                button
                  {} (:class-name style-overview-map-close)
                    :on-click $ fn (e d!)
                      hint-fn $ {}
                        :args $ [] (:: 'Map 'Tag 'Dynamic)
                          :: 'Fn $ {}
                            :args $ [] 'Dynamic
                            :rest 'Dynamic
                            :return 'Unit
                        :return 'Unit
                      d! $ Op :states cursor $ struct-with state (:view :reader)
                      , &unit
                  <> "|返回阅读"
              div
                {} $ :class-name style-overview-map-title
                <> "|领域 × 历史阶段的知识覆盖"
              div
                {} $ :class-name style-overview-map-note
                <> "|颜色深浅表示该领域在该阶段已有的关键卡片数量；点击方格进入该组最早的卡片。"
              div
                {} $ :class-name style-heatmap-board
                div
                  {} $ :class-name style-heatmap-head-row
                  div
                    {} $ :class-name style-heatmap-row-label
                    <> "|领域 / 阶段"
                  list-> ({})
                    map-indexed historical-stages $ fn (idx stage)
                      [] (:id stage)
                        div
                          {} $ :class-name style-heatmap-head
                          <> $ :era stage
                list->
                  {} $ :class-name style-heatmap-rows
                  map-indexed heatmap-domains $ fn (domain-idx domain)
                    []
                        get domain :key
                        , .unwrap
                      div
                        {} $ :class-name style-heatmap-row
                        div
                          {} $ :class-name style-heatmap-row-label
                          <> $
                            get domain :label
                            , .unwrap-or ||
                        list-> ({})
                          map-indexed historical-stages $ fn (stage-idx stage)
                            let
                                matches $ filter knowledge-nodes $ fn (doc)
                                  and
                                    = (graph-domain-key doc)
                                      (get domain :key) .unwrap
                                    option:some? $ find (:ids stage)
                                      fn (id)
                                        = id $ :id doc
                                target $ first matches
                                amount $ count matches
                              []
                                str
                                    get domain :key
                                    , .unwrap
                                  , |- $ :id stage
                                button
                                  {}
                                    :class-name $ str-spaced style-heatmap-cell $ if (= amount 0) style-heatmap-cell-empty
                                      if (= amount 1) style-heatmap-cell-light $ if (= amount 2) style-heatmap-cell-medium style-heatmap-cell-strong
                                    :title $ str
                                        get domain :label
                                        , .unwrap-or ||
                                      , "| · " $ :era stage
                                    :on-click $ fn (e d!)
                                      hint-fn $ {}
                                        :args $ [] (:: 'Map 'Tag 'Dynamic)
                                          :: 'Fn $ {}
                                            :args $ [] 'Dynamic
                                            :rest 'Dynamic
                                            :return 'Unit
                                        :return 'Unit
                                      when (target .some?)
                                        d! $ Op :states cursor $ struct-with
                                          struct-with
                                            struct-with state $ :view :reader
                                            :selected $ :id $ target .unwrap
                                          :active-section |history
                                      , &unit
                                  div
                                    {} $ :class-name style-heatmap-count
                                    <> $ str amount
                                  div
                                    {} $ :class-name style-heatmap-caption
                                    <> $ if (= amount 0) "|暂无卡片" "|点击浏览"
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/ReaderState $ :: 'List 'Dynamic
        'comp-knowledge-graph $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-knowledge-graph (cursor state)
            let
                selected-id $ :selected state
                node $ option:unwrap-or (find-knowledge-node selected-id)
                  (first knowledge-nodes) .unwrap
                blueprint node
                sections $ card-queue node blueprint
                requested-id $ :active-section state
                active-section-option $ find sections $ fn (section)
                  = requested-id $ :id section
                active-section $ active-section-option .unwrap-or $
                  first sections
                  , .unwrap
                active-id $ :id active-section
                visit-history $ :history state
                map-view? $ = (:view state) :map
                related $ card-recommendations selected-id active-section blueprint
                timeline-selected $ find history-timeline-ids $ fn (id) (= id selected-id)
                timeline-parent $ find history-timeline-ids $ fn (id)
                  = id $
                    :parent blueprint
                    , .unwrap-or ||
                timeline-active-id $ timeline-selected .unwrap-or $ timeline-parent .unwrap-or selected-id
                navigate! $ fn (target-id d!)
                  hint-fn $ {}
                    :args $ [] 'String $ :: 'Fn
                      {}
                        :args $ [] 'Dynamic
                        :rest 'Dynamic
                        :return 'Unit
                    :return 'Unit
                  d! $ Op :states cursor $ app.schema/ReaderState :selected target-id :active-section |history :history
                    take-last
                      conj
                        filter visit-history $ fn (id) (not= id selected-id)
                        , selected-id
                      , 12
                    , :view :reader
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
                          target $ option:unwrap $ find-knowledge-node id
                          current? $ = id timeline-active-id
                          visited? $ option:some? $ find visit-history
                            fn (visited-id) (= visited-id id)
                        [] idx $ div
                          {} $ :class-name style-history-item
                          button
                            {}
                              :class-name $ if current? (str-spaced style-history-node style-history-node-current)
                                if visited? (str-spaced style-history-node style-history-node-visited) style-history-node
                              :on-click $ fn (e d!)
                                hint-fn $ {}
                                  :args $ [] (:: 'Map 'Tag 'Dynamic)
                                    :: 'Fn $ {}
                                      :args $ [] 'Dynamic
                                      :rest 'Dynamic
                                      :return 'Unit
                                  :return 'Unit
                                navigate! id d!
                                , &unit
                            div
                              {} $ :class-name style-history-era
                              <> $ history-milestone-era id
                            div
                              {} $ :class-name style-history-label
                              <> $ :label target
                          when
                            < idx $ dec $ count history-timeline-ids
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
                  div
                    {} $ :class-name style-history-view-switcher
                    button
                      {}
                        :class-name $ if
                          = (:view state) :map
                          str-spaced style-history-view-toggle style-history-view-toggle-active
                          , style-history-view-toggle
                        :on-click $ fn (e d!)
                          hint-fn $ {}
                            :args $ [] (:: 'Map 'Tag 'Dynamic)
                              :: 'Fn $ {}
                                :args $ [] 'Dynamic
                                :rest 'Dynamic
                                :return 'Unit
                            :return 'Unit
                          d! $ Op :states cursor $ struct-with state (:view :map)
                          , &unit
                      <> |MAP
                    button
                      {}
                        :class-name $ if
                          = (:view state) :timeline
                          str-spaced style-history-view-toggle style-history-view-toggle-active
                          , style-history-view-toggle
                        :on-click $ fn (e d!)
                          hint-fn $ {}
                            :args $ [] (:: 'Map 'Tag 'Dynamic)
                              :: 'Fn $ {}
                                :args $ [] 'Dynamic
                                :rest 'Dynamic
                                :return 'Unit
                            :return 'Unit
                          d! $ Op :states cursor $ struct-with state (:view :timeline)
                          , &unit
                      <> |TIME
                    button
                      {}
                        :class-name $ if
                          = (:view state) :heatmap
                          str-spaced style-history-view-toggle style-history-view-toggle-active
                          , style-history-view-toggle
                        :on-click $ fn (e d!)
                          hint-fn $ {}
                            :args $ [] (:: 'Map 'Tag 'Dynamic)
                              :: 'Fn $ {}
                                :args $ [] 'Dynamic
                                :rest 'Dynamic
                                :return 'Unit
                            :return 'Unit
                          d! $ Op :states cursor $ struct-with state (:view :heatmap)
                          , &unit
                      <> |HEAT
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
                              hint-fn $ {}
                                :args $ [] (:: 'Map 'Tag 'Dynamic)
                                  :: 'Fn $ {}
                                    :args $ [] 'Dynamic
                                    :rest 'Dynamic
                                    :return 'Unit
                                :return 'Unit
                              d! $ Op :states cursor $ struct-with state
                                :active-section $ :id section
                              , &unit
                          span
                            {} $ :class-name style-reader-outline-index
                            <> $ str |0 $ + idx 1
                          span
                            {} $ :class-name style-reader-outline-label
                            <> $
                              :title section
                              , .unwrap-or ||
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
                              target $ option:unwrap $ find-knowledge-node id
                            [] idx $ button $ {} (:class-name style-reader-nav-button)
                              :inner-text $ :label target
                              :on-click $ fn (e d!)
                                hint-fn $ {}
                                  :args $ [] (:: 'Map 'Tag 'Dynamic)
                                    :: 'Fn $ {}
                                      :args $ [] 'Dynamic
                                      :rest 'Dynamic
                                      :return 'Unit
                                  :return 'Unit
                                navigate! id d!
                                , &unit
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
                                target $ option:unwrap $ find-knowledge-node id
                              [] idx $ button $ {} (:class-name style-reader-history-button)
                                :inner-text $ str "|←" | $ :label target
                                :on-click $ fn (e d!)
                                  hint-fn $ {}
                                    :args $ [] (:: 'Map 'Tag 'Dynamic)
                                      :: 'Fn $ {}
                                        :args $ [] 'Dynamic
                                        :rest 'Dynamic
                                        :return 'Unit
                                    :return 'Unit
                                  navigate! id d!
                                  , &unit
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
                              hint-fn $ {}
                                :args $ [] (:: 'Map 'Tag 'Dynamic)
                                  :: 'Fn $ {}
                                    :args $ [] 'Dynamic
                                    :rest 'Dynamic
                                    :return 'Unit
                                :return 'Unit
                              navigate! (:id item) d!
                              , &unit
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
                        kind-label $
                          :kind node
                          , .unwrap-or :concept
                        , "|　·　" $
                          :era node
                          , .unwrap-or ||
                    div
                      {} $ :class-name style-reader-article-title
                      <> $ :label node
                    div
                      {} $ :class-name style-reader-article-summary
                      <> $
                        :summary node
                        , .unwrap-or ||
                    div
                      {} $ :class-name style-reader-formula
                      <> $
                        :formula node
                        , .unwrap-or ||
                    list->
                      {} $ :class-name style-reader-dimension-grid
                      map-indexed (knowledge-dimensions node)
                        fn (idx dimension)
                          [] idx $ div
                            {} $ :class-name style-reader-dimension-card
                            div
                              {} $ :class-name style-reader-dimension-label
                              <> $
                                get dimension :label
                                , .unwrap-or ||
                            div
                              {} $ :class-name style-reader-dimension-value
                              <> $
                                get dimension :value
                                , .unwrap-or ||
                    when
                        :tags blueprint
                        , .some?
                      list->
                        {} $ :class-name style-reader-tag-row
                        map-indexed
                          &set:to-list $
                            :tags blueprint
                            , .unwrap
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
                            hint-fn $ {}
                              :args $ [] (:: 'Map 'Tag 'Dynamic)
                                :: 'Fn $ {}
                                  :args $ [] 'Dynamic
                                  :rest 'Dynamic
                                  :return 'Unit
                              :return 'Unit
                            d! $ Op :states cursor $ struct-with state
                              :active-section $ :id section
                            , &unit
                        div
                          {} $ :class-name style-reader-section-head
                          div
                            {} $ :class-name style-reader-section-heading
                            span
                              {} $ :class-name style-reader-section-number
                              <> $ str |0 $ + idx 1
                            div
                              {} $ :class-name style-reader-section-title
                              <> $
                                :title section
                                , .unwrap-or ||
                          div
                            {} $ :class-name style-reader-section-tags
                            <> $ str |# $ join-string
                              &set:to-list $
                                :tags section
                                , .unwrap-or $ #{} "|文章"
                              , "|　#"
                        div
                          {} $ :class-name style-reader-section-preview
                          comp-md-block
                            markdown-body-without-title $ :content section
                            {}
                        when
                          not $ empty? $
                            :links section
                            , .unwrap-or ([])
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
                    <> $ str "|基于“"
                      (:title active-section) .unwrap-or ||
                      , "|”的链接、标签与知识边生成"
                  list->
                    {} $ :class-name style-reader-related-cards
                    map-indexed related $ fn (idx item)
                      [] idx $ button
                        {} (:class-name style-reader-related-card)
                          :on-click $ fn (e d!)
                            hint-fn $ {}
                              :args $ [] (:: 'Map 'Tag 'Dynamic)
                                :: 'Fn $ {}
                                  :args $ [] 'Dynamic
                                  :rest 'Dynamic
                                  :return 'Unit
                              :return 'Unit
                            navigate! (:id item) d!
                            , &unit
                        div
                          {} $ :class-name style-reader-related-relation
                          <> $ str (:direction item) "|  " (:relation item) "|  ·  " $ :kind item
                        div
                          {} $ :class-name style-reader-related-title
                          <> $ :label item
                        div
                          {} $ :class-name style-reader-related-summary
                          <> $ :summary item
                        when
                            Option :some $ :tags item
                            , .some?
                          div
                            {} $ :class-name style-reader-tag-row
                            list-> ({})
                              map-indexed
                                take
                                  &set:to-list $ :tags item
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
                          hint-fn $ {}
                            :args $ [] (:: 'Map 'Tag 'Dynamic)
                              :: 'Fn $ {}
                                :args $ [] 'Dynamic
                                :rest 'Dynamic
                                :return 'Unit
                            :return 'Unit
                          d! $ Op :states cursor $ struct-with state (:view :reader)
                          , &unit
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
                when
                  = (:view state) :timeline
                  comp-timeline-view state cursor
                when
                  = (:view state) :heatmap
                  comp-heatmap-view state cursor
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'List 'Dynamic) 'app.schema/ReaderState
        'comp-timeline-view $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-timeline-view (state cursor)
            div
              {} $ :class-name style-overview-map
              div
                {} $ :class-name style-overview-map-head
                div
                  {} $ :class-name style-overview-map-kicker
                  <> |TIMELINE
                button
                  {} (:class-name style-overview-map-close)
                    :on-click $ fn (e d!)
                      hint-fn $ {}
                        :args $ [] (:: 'Map 'Tag 'Dynamic)
                          :: 'Fn $ {}
                            :args $ [] 'Dynamic
                            :rest 'Dynamic
                            :return 'Unit
                        :return 'Unit
                      d! $ Op :states cursor $ struct-with state (:view :reader)
                      , &unit
                  <> "|返回阅读"
              div
                {} $ :class-name style-overview-map-title
                <> "|数学如何一步步抵达时空结构"
              div
                {} $ :class-name style-overview-map-note
                <> "|不是年代名录：沿时间脊柱观察每一代人面对的问题、分出的数学路线，以及哪些结构被带入下一阶段。"
              div
                {} $ :class-name style-timeline-board
                list->
                  {} $ :class-name style-timeline-vertical
                  map-indexed historical-stages $ fn (stage-idx stage)
                    [] (:id stage)
                      div
                        {} $ :class-name style-timeline-stage
                        div
                          {} $ :class-name style-timeline-stage-era
                          <> $ :era stage
                        div
                          {} $ :class-name style-timeline-stage-marker
                          <> $ str |0 $ + stage-idx 1
                        div
                          {} $ :class-name style-timeline-stage-content
                          div
                            {} $ :class-name style-timeline-stage-head
                            div
                              {} $ :class-name style-timeline-stage-title
                              <> $ :title stage
                            div
                              {} $ :class-name style-timeline-stage-count
                              <> $ str
                                count $ :ids stage
                                , "|个知识节点"
                          div
                            {} $ :class-name style-timeline-narrative
                            div
                              {} $ :class-name style-timeline-narrative-label
                              <> "|问题"
                            div
                              {} $ :class-name style-timeline-narrative-text
                              <> $ :question stage
                            div
                              {} $ :class-name style-timeline-narrative-label
                              <> "|结构性突破"
                            div
                              {} $ :class-name style-timeline-narrative-text
                              <> $ :breakthrough stage
                          list->
                            {} $ :class-name style-timeline-branches
                            map-indexed (:branches stage)
                              fn (branch-idx branch)
                                [] (:title branch)
                                  div
                                    {} $ :class-name style-timeline-branch
                                    div
                                      {} $ :class-name style-timeline-branch-head
                                      span
                                        {} $ :class-name style-timeline-branch-index
                                        <> $ str |0 $ + branch-idx 1
                                      div
                                        {} $ :class-name style-timeline-branch-title
                                        <> $ :title branch
                                    div
                                      {} $ :class-name style-timeline-branch-note
                                      <> $ :note branch
                                    list->
                                      {} $ :class-name style-timeline-event-list
                                      map-indexed (:ids branch)
                                        fn (card-idx id)
                                          let
                                              target $ option:unwrap $ find-card-blueprint id
                                            [] id $ button
                                              {} (:class-name style-timeline-event)
                                                :on-click $ fn (e d!)
                                                  hint-fn $ {}
                                                    :args $ [] (:: 'Map 'Tag 'Dynamic)
                                                      :: 'Fn $ {}
                                                        :args $ [] 'Dynamic
                                                        :rest 'Dynamic
                                                        :return 'Unit
                                                    :return 'Unit
                                                  d! $ Op :states cursor $ struct-with
                                                    struct-with state $ :view :reader
                                                    :selected $ if
                                                      =
                                                        option:unwrap-or (:kind target) :concept
                                                        , :section
                                                      option:unwrap $ :parent target
                                                      , id
                                                    :active-section $ if
                                                      =
                                                        option:unwrap-or (:kind target) :concept
                                                        , :section
                                                      , id |history
                                                  , &unit
                                              div
                                                {} $ :class-name style-timeline-event-order
                                                <> $ str |0 $ + card-idx 1
                                              div
                                                {} $ :class-name style-timeline-event-body
                                                div
                                                  {} $ :class-name style-timeline-event-meta
                                                  <> $ str
                                                    kind-label $
                                                      :kind target
                                                      , .unwrap-or :concept
                                                    , "| · " $
                                                      :era target
                                                      , .unwrap-or ||
                                                div
                                                  {} $ :class-name style-timeline-event-title
                                                  <> $ :label target
                                                div
                                                  {} $ :class-name style-timeline-event-summary
                                                  <> $
                                                    :summary target
                                                    , .unwrap-or ||
                          div
                            {} $ :class-name style-timeline-handoff
                            span
                              {} $ :class-name style-timeline-handoff-label
                              <> "|带向下一阶段"
                            <> $ :handoff stage
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/ReaderState $ :: 'List 'Dynamic
        'effect-knowledge-network $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-knowledge-network (graph-data) (action el at-place?)
            when (= action :mount) (fcose cytoscape)
            when (= action :mount)
              let
                  options $ js-object (:container el)
                    :elements $ to-js-data graph-data
                    :autoungrabify true
                    :boxSelectionEnabled false
                    :style $ to-js-data $ concat
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
                reset! *knowledge-network-instances $ assoc @*knowledge-network-instances el cy
                browser/set-timeout!
                  fn () (.!resize cy) (.!center cy) &unit
                  , 24
            when (= action :unmount)
              let
                  cy $ get @*knowledge-network-instances el
                when (option:some? cy)
                  .!destroy $ option:unwrap cy
                  reset! *knowledge-network-instances $ dissoc @*knowledge-network-instances el
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Effect)
            :args $ [] $ :: 'List (:: 'Map 'Tag 'Dynamic)
            :features $ #{} :js-ffi
        'find-card-blueprint $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn find-card-blueprint (id) (get knowledge-docs id)
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :return $ :: 'Option 'app.schema/KnowledgeDoc
        'find-knowledge-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn find-knowledge-node (id)
            find knowledge-nodes $ fn (node)
              = id $ :id node
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :return $ :: 'Option 'app.schema/KnowledgeDoc
        'graph-domain-key $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn graph-domain-key (doc)
            let
                id $ :id doc
              cond
                  contains?
                    #{} |real-numbers |complex-numbers |complex-origin |complex-equations |complex-plane-section |complex-multiplication |complex-structure |imaginary-unit |argand-plane |cardano-casus |bombelli-algebra |wessel-argand-gauss |euler-formula |fundamental-theorem-algebra
                    , id
                  , |complex
                (contains? (#{} |quaternions |quaternion-problem |quaternion-product |quaternion-rotation |quaternion-use |hamilton |noncommutativity |so3 |su2 |robotics |computer-graphics) id)
                  , |quaternion
                (contains? (#{} |minkowski-spacetime |spacetime-unification |hyperbolic-rotation |spacetime-fields |lorentz-transform |maxwell-field |dirac-equation |dirac-square-root |quantum-spin) id)
                  , |spacetime
                true |geometric
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'app.schema/KnowledgeDoc
        'heatmap-domains $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def heatmap-domains
            []
              {} (:key |complex) (:label "|数域与复数")
              {} (:key |quaternion) (:label "|四元数与旋转")
              {} (:key |geometric) (:label "|外代数与几何")
              {} (:key |spacetime) (:label "|时空与量子")
          :examples $ []
          :schema $ :: 'List $ :: 'Map 'Tag 'String
        'historical-stages $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def historical-stages
            []
              app.schema/HistoryStage :id |origins :era "|1545—1798" :title "|代数中的数系压力" :question "|当公式为了求出实数答案却必须穿过负数平方根，什么才算合法的数？" :breakthrough "|把对象的合法性从直观可测转向运算规则的一致、封闭与可检验。" :handoff "|复数先作为必要的中间语言出现；下一步才是为这套算术寻找空间解释。" :ids ([] |real-numbers |complex-equations |cardano-casus |bombelli-algebra |imaginary-unit) :branches $ []
                app.schema/HistoryBranch :title "|方程支线" :note "|三次方程的通用公式暴露出不可约情形：只许实数的中间步骤反而无法完成求解。Cardano公开公式，Bombelli把虚量的计算规则写稳。" :ids $ [] |cardano-casus |bombelli-algebra |complex-equations
                app.schema/HistoryBranch :title "|数域支线" :note "|负数曾经也不被承认；虚数的争议由此逼迫数学家区分“符号能否出现”与“运算系统能否自洽”。" :ids $ [] |real-numbers |imaginary-unit
              app.schema/HistoryStage :id |complex :era "|1799—1842" :title "|复数获得平面与结构" :question "|若a+bi不是数轴上的点，它究竟在描述位置、方向，还是一种对平面的作用？" :breakthrough "|把复数看成平面有向量后，乘法同时成为缩放与旋转；代数规则第一次直接说明空间动作。" :handoff "|二维旋转可以交换；三维旋转的先后顺序却不能，这迫使下一代人改变代数公理。" :ids ([] |wessel-argand-gauss |argand-plane |complex-numbers |complex-multiplication |euler-formula |fundamental-theorem-algebra |complex-plane-section) :branches $ []
                app.schema/HistoryBranch :title "|几何表示支线" :note "|Wessel的测量实践、Argand的独立论文与Gauss的系统化命名，让虚数单位成为平面中四分之一转动，而非无法解释的符号。" :ids $ [] |wessel-argand-gauss |argand-plane |complex-plane-section
                app.schema/HistoryBranch :title "|旋转与相位支线" :note "|极坐标把模长和辐角拆开；Euler公式说明连续旋转可由普通乘法复合，因而连接振动、波与相位。" :ids $ [] |complex-numbers |complex-multiplication |euler-formula
                app.schema/HistoryBranch :title "|代数闭包支线" :note "|代数学基本定理把“每个多项式都能找到根”变成复数域的结构事实，复数由技巧升级为自然工作场所。" :ids $ [] |fundamental-theorem-algebra
              app.schema/HistoryStage :id |algebra :era "|1843—1879" :title "|三维旋转的代数分叉" :question "|能否像复数编码平面旋转那样，用乘法编码三维方向、面积、体积与旋转顺序？" :breakthrough "|Hamilton接受非交换，Grassmann把方向推广为有向子空间，Clifford再把二次型与外积放到同一乘法中。" :handoff "|这里产生的不是唯一胜者，而是三条可互译的语言：四元数、向量/外代数与Clifford代数。" :ids
                [] |hamilton |quaternion-problem |quaternions |quaternion-product |noncommutativity |quaternion-rotation |grassmann |exterior-algebra |wedge-product |inner-product |clifford |clifford-algebra |geometric-product
                , :branches $ []
                  app.schema/HistoryBranch :title "|Hamilton支线：旋转次序" :note "|三元数失败说明维数和公理不能任意挑选。四元数以一个额外实维数换来封闭，并以ij=-ji保存先后旋转的差异。" :ids $ [] |hamilton |quaternion-problem |quaternions |quaternion-product |noncommutativity |quaternion-rotation
                  app.schema/HistoryBranch :title "|Grassmann支线：子空间与取向" :note "|向量不只相加；两个向量还能生成有向面积，三个向量生成有向体积。外积的反交换性记录了交换基向量会翻转取向。" :ids $ [] |grassmann |exterior-algebra |wedge-product |inner-product
                  app.schema/HistoryBranch :title "|Clifford支线：度量重新接回几何" :note "|仅有外积不能测长度。Clifford以v²=Q(v)把二次型装进乘法，使内积与外积成为同一几何积的不同部分。" :ids $ [] |clifford |clifford-algebra |geometric-product
              app.schema/HistoryStage :id |spacetime :era "|1880—1919" :title "|从空间向时空：变换成为主角" :question "|当电磁规律与Galilei时空不兼容，哪些量应该随观察者改变，哪些量必须保持不变？" :breakthrough "|从“物体在绝对空间中的运动”转为“观察者如何分解同一四维事件结构”；不变量与变换群成为核心。" :handoff "|时空几何不仅改写电磁场，也要求物质的量子态按旋量而非普通向量变换。" :ids
                [] |vector-analysis-debate |maxwell-field |lorentz-transform |hyperbolic-rotation |minkowski-spacetime |spacetime-unification |cartan-spinors |spinor
                , :branches $ []
                  app.schema/HistoryBranch :title "|电磁与记号支线" :note "|Maxwell方程催生了实用的向量分析。Gibbs与Heaviside拆出点积和叉积，计算更简洁，却让四元数的统一乘法暂时退到背景。" :ids $ [] |vector-analysis-debate |maxwell-field
                  app.schema/HistoryBranch :title "|相对论支线" :note "|Lorentz变换起初服务于电磁理论；Poincaré识别群结构，Einstein重写同时性，Minkowski则把保持不变的间隔看作真正的几何对象。" :ids $ [] |lorentz-transform |hyperbolic-rotation |minkowski-spacetime |spacetime-unification
                  app.schema/HistoryBranch :title "|表示论支线" :note "|Cartan研究正交群表示时发现旋量：它不是普通箭头，而是旋转群双重覆盖上的对象，720度才完全复原其相位。" :ids $ [] |cartan-spinors |spinor
              app.schema/HistoryStage :id |physics :era "|1920—今天" :title "|旋量、场与可计算几何" :question "|如果时空对称是基础，电子、自旋、场和工程中的姿态，分别应当用什么对象来表示？" :breakthrough "|Clifford关系线性化时空二次型，Dirac方程把旋量带入量子物质；旋转代数同时进入机器人、图形和航天。" :handoff "|从数系扩张到时空结构的主线仍未封闭：量子场与可弯曲时空如何统一，仍是开放问题。" :ids
                [] |dirac-square-root |dirac-equation |clifford-physics |quantum-spin |su2 |so3 |rotor |reflection |robotics |computer-graphics |conformal-geometric-algebra
                , :branches $ []
                  app.schema/HistoryBranch :title "|量子物质支线" :note "|Pauli矩阵、SU(2)与Diracγ矩阵说明自旋不是经典小球自转。把能量动量关系开平方，会强制出现反对易生成元与旋量态。" :ids $ [] |dirac-square-root |dirac-equation |clifford-physics |quantum-spin |su2
                  app.schema/HistoryBranch :title "|旋转群支线" :note "|SO(3)描述可见的三维旋转，SU(2)是其双重覆盖。rotor以共轭作用旋转向量，避免欧拉角奇异并保留组合次序。" :ids $ [] |so3 |rotor |reflection
                  app.schema/HistoryBranch :title "|工程与计算支线" :note "|四元数和几何代数不只是历史遗产：姿态估计、传感器融合、骨骼动画、相机控制与共形模型仍在直接使用它们。" :ids $ [] |robotics |computer-graphics |conformal-geometric-algebra
          :examples $ []
          :schema $ :: 'List 'app.schema/HistoryStage
        'history-milestone-era $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn history-milestone-era (id)
            match id (|complex-numbers "|1545—1831") (|quaternions |1843) (|grassmann |1844) (|clifford-algebra |1878) (|minkowski-spacetime |1908) (|spinor |1913) (|dirac-equation |1928) (_ "|跨时期")
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
        'history-timeline-ids $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def history-timeline-ids ([] |complex-numbers |quaternions |grassmann |clifford-algebra |minkowski-spacetime |spinor |dirac-equation)
          :examples $ []
          :schema $ :: 'List 'String
        'kind-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn kind-label (kind)
            match kind (:concept "|核心概念") (:theorem "|定理与公式") (:person "|历史人物") (:operation "|代数运算") (:principle "|基本原理") (:structure "|数学结构") (:representation "|几何表示") (:application "|现实应用") (_ "|知识节点")
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'Tag
        'knowledge-bundle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def knowledge-bundle (load-knowledge-docs)
          :examples $ []
          :schema $ :: 'app.schema/KnowledgeBundle
        'knowledge-dimensions $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn knowledge-dimensions (doc)
            []
              {} (:label "|历史时间")
                :value $
                  :era doc
                  , .unwrap-or "|跨时期"
              {} (:label "|数域／结构")
                :value $ number-domain-label doc
              {} (:label "|空间维度")
                :value $ space-dimension-label doc
              {} (:label "|知识角色")
                :value $ kind-label $
                  :kind doc
                  , .unwrap-or :concept
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/KnowledgeDoc
            :return $ :: 'List $ :: 'Map 'Tag 'String
        'knowledge-doc-reference-ids $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn knowledge-doc-reference-ids (doc)
            let
                links $ option:unwrap-or (:links doc) ([])
                queue $ option:unwrap-or (:queue doc) ([])
                parent $ :parent doc
                relations $ option:unwrap-or (:relations doc) ([])
              concat links $ concat queue $ concat
                if (option:some? parent)
                  [] $ option:unwrap parent
                  []
                map relations $ fn (relation)
                  if
                    = :outgoing $ option:unwrap-or (:direction relation) :outgoing
                    option:unwrap-or (:target relation) ||
                    option:unwrap-or (:source relation) ||
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/KnowledgeDoc
            :return $ :: 'List 'String
        'knowledge-docs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def knowledge-docs (:docs knowledge-bundle)
          :examples $ []
          :schema $ :: 'Map 'String 'app.schema/KnowledgeDoc
        'knowledge-edges $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def knowledge-edges
            mapcat
              .to-list $ distinct-values knowledge-docs
              fn (doc)
                map
                  filter
                      :relations doc
                      , .unwrap-or $ []
                    fn (relation)
                      = :outgoing $
                        :direction relation
                        , .unwrap-or :unknown
                  fn (relation)
                    app.schema/KnowledgeEdge :source (:id doc) :target
                      (:target relation) .unwrap
                      , :relation
                        (:label relation) .unwrap-or ||
                        , :kind $
                          :kind relation
                          , .unwrap-or :related
          :examples $ []
          :schema $ :: 'List 'app.schema/KnowledgeEdge
        'knowledge-network-elements $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn knowledge-network-elements ()
            concat
              map knowledge-nodes $ fn (doc)
                {} $ :data $ {}
                  :id $ :id doc
                  :label $ :label doc
                  :era $
                    :era doc
                    , .unwrap-or ||
                  :domain $ graph-domain-key doc
                  :kind $ kind-label $
                    :kind doc
                    , .unwrap-or :concept
              map knowledge-edges $ fn (edge)
                {} $ :data $ {}
                  :id $ str (:source edge) "|→" $ :target edge
                  :source $ :source edge
                  :target $ :target edge
                  :label $ :relation edge
                  :kind $ :kind edge
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ []
            :return $ :: 'List $ :: 'Map 'Tag 'Dynamic
        'knowledge-nodes $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def knowledge-nodes
            filter
              .to-list $ distinct-values knowledge-docs
              fn (doc)
                not= :section $
                  :kind doc
                  , .unwrap-or :concept
          :examples $ []
          :schema $ :: 'List 'app.schema/KnowledgeDoc
        'load-knowledge-docs $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defmacro load-knowledge-docs ()
            let
                paths $ [] |content/argand-plane.md |content/bombelli-algebra.md |content/cardano-casus.md |content/cartan-spinors.md |content/clifford-algebra.md |content/clifford-physics.md |content/clifford-synthesis.md |content/clifford.md |content/complex-equations.md |content/complex-multiplication.md |content/complex-numbers.md |content/complex-origin.md |content/complex-plane.md |content/complex-structure.md |content/computer-graphics.md |content/conformal-geometric-algebra.md |content/dirac-equation.md |content/dirac-square-root.md |content/euler-formula.md |content/exterior-algebra.md |content/frobenius-theorem.md |content/fundamental-theorem-algebra.md |content/geometric-product-card.md |content/geometric-product.md |content/grassmann.md |content/hamilton.md |content/hyperbolic-rotation.md |content/imaginary-unit.md |content/inner-product.md |content/lorentz-transform.md |content/maxwell-field.md |content/minkowski-spacetime.md |content/noncommutativity.md |content/quantum-spin.md |content/quaternion-problem.md |content/quaternion-product.md |content/quaternion-rotation.md |content/quaternion-use.md |content/quaternions.md |content/real-numbers.md |content/reflection.md |content/robotics.md |content/rotor.md |content/so3.md |content/spacetime-fields.md |content/spacetime-unification.md |content/spinor.md |content/su2.md |content/vector-analysis-debate.md |content/wedge-product.md |content/wessel-argand-gauss.md
                pairs $ map paths $ fn (path)
                  let
                      lines $ split-lines $ read-file path
                      closing-index $ inc $ option:unwrap
                        find-index (rest lines)
                          fn (line) (= line |---)
                      metadata $ parse-cirru-edn $ join-string (slice lines 1 closing-index) "|\n"
                      body $ join-string
                        slice lines (inc closing-index) (count lines)
                        , "|\n"
                      doc $ assoc
                        assoc (assoc metadata :content body) :source path
                        , :label $
                          get metadata :title
                          , .unwrap-or ||
                    []
                        get doc :id
                        , .unwrap
                      , doc
                diagnostics $ validate-knowledge-docs! $ map pairs
                  fn (pair)
                    decode-knowledge-doc $ option:unwrap $ last pair
                errors $
                  get diagnostics :errors
                  , .unwrap-or $ []
                warnings $
                  get diagnostics :warnings
                  , .unwrap-or $ []
                _warnings $ &doseq (warning warnings)
                  eprintln |[knowledge-warning] $
                    get warning :message
                    , .unwrap-or ||
                _errors $ when-not (empty? errors)
                  raise $ str "|Knowledge validation failed:\n" $ join-string
                    map errors $ fn (error)
                      str "|- " $
                        get error :message
                        , .unwrap-or ||
                    , "|\n"
                serialized $ format-cirru-edn $ {}
                  :docs $ pairs-map pairs
                  :diagnostics diagnostics
              quasiquote $ decode-map-as (parse-cirru-edn ~serialized) 'app.schema/KnowledgeBundle
          :examples $ []
          :schema $ :: 'Macro $ {}
            :capabilities $ #{} :fs-read :log
            :expansion $ :: 'Expr 'app.schema/KnowledgeBundle
            :required $ []
          :tests $ [] $ %{} 'TestEntry (:name |all-original-markdown-documents)
            :code $ quote $ let
                bundle knowledge-bundle
                docs $ :docs bundle
                diagnostics $ :diagnostics bundle
                node $ option:unwrap $ find-knowledge-node |complex-numbers
              assert= 51 $ count docs
              assert= 0 $ count $ option:unwrap (get diagnostics :errors)
              assert= "|复数" $ :label node
              assert= ([] |complex-equations |complex-plane-section |complex-multiplication)
                map (card-queue node node)
                  fn (card) (:id card)
        'markdown-body-without-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn markdown-body-without-title (content)
            let
                lines $ split-lines content
                first-line $
                  first lines
                  , .unwrap-or ||
              if (starts-with? first-line "|## ")
                join-string (rest lines) "|\n"
                , content
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'String
        'markdown-chapter-cards $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn markdown-chapter-cards (doc)
            let
                parts $ split (:content doc) "|\n## "
              map-indexed parts $ fn (idx part)
                let
                    lines $ split-lines part
                    first-line $
                      first lines
                      , .unwrap-or ||
                    heading-in-content? $ starts-with? first-line "|## "
                    chapter-title $ if heading-in-content? (slice first-line 3)
                      if (= idx 0)
                        str
                            :title doc
                            , .unwrap-or ||
                          , "|：概览"
                        , first-line
                    chapter-content $ if
                      or heading-in-content? $ > idx 0
                      join-string (rest lines) "|\n"
                      , part
                  app.schema/KnowledgeDoc :id
                    str (:id doc) |-chapter- idx
                    , :content chapter-content :source (:source doc) :label chapter-title :title (Option :some chapter-title) :summary (Option :none) :kind (Option :none) :era (Option :none) :formula (Option :none) :tags
                      Option :some $
                        :tags doc
                        , .unwrap-or $ #{}
                          kind-label $
                            :kind doc
                            , .unwrap-or :concept
                      , :links
                        Option :some $
                          :links doc
                          , .unwrap-or $ []
                        , :parent (Option :none) :queue (Option :none) :relations $ Option :none
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'app.schema/KnowledgeDoc
            :return $ :: 'List 'app.schema/KnowledgeDoc
        'number-domain-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn number-domain-label (doc)
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
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'app.schema/KnowledgeDoc
        'related-knowledge-nodes $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn related-knowledge-nodes (id)
            map
              filter knowledge-edges $ fn (edge)
                or
                  = id $ :source edge
                  = id $ :target edge
              fn (edge)
                let
                    outgoing? $ = id $ :source edge
                    other-id $ if outgoing? (:target edge) (:source edge)
                    other $ option:unwrap $ find-knowledge-node other-id
                  {} (:id other-id)
                    :label $ :label other
                    :summary $
                      :summary other
                      , .unwrap-or ||
                    :relation $ :relation edge
                    :direction $ if outgoing? "|→" "|←"
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'String
            :return $ :: 'List $ :: 'Map 'Tag 'String
        'section-links-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn section-links-text (section)
            let
                links $ option:unwrap-or (:links section) ([])
                labels $ map links $ fn (id)
                  let
                      doc $
                        get knowledge-docs id
                        , .unwrap
                      target $ option:unwrap $ find-knowledge-node id
                    (:title doc) .unwrap-or $ :label target
              join-string labels "| · "
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'app.schema/KnowledgeDoc
        'space-dimension-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn space-dimension-label (doc)
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
          :schema $ :: 'Fn $ {} (:return 'String)
            :args $ [] 'app.schema/KnowledgeDoc
        'style-heatmap-board $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-board
            {} $ |& $ {} (:max-width |1480px) (:margin "|24px auto") (:border "|1px solid #d6e5f4") (:border-radius |10px) (:background "|rgba(255,255,255,.72)") (:padding |16px) (:overflow-x |auto)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-caption $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-caption
            {} $ |& $ {} (:margin-top |5px) (:font-size |11px) (:color |#7891aa)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-cell $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-cell
            {}
              |& $ {} (:min-height |92px) (:border "|1px solid #bdd7ee") (:border-radius |8px) (:background |#edf7ff) (:color |#356284) (:cursor |pointer)
              |&:hover $ {} (:background |#dff1ff) (:border-color |#7eb5e6)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-cell-empty $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-cell-empty
            {} $ |& $ {} (:background |#fbfdff) (:border-color |#e1ebf5) (:color |#9aabbb)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-cell-light $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-cell-light
            {} $ |& $ {} (:background |#eff8ff) (:border-color |#c4def3)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-cell-medium $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-cell-medium
            {} $ |& $ {} (:background |#dcefff) (:border-color |#a5cee9)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-cell-strong $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-cell-strong
            {} $ |& $ {} (:background |#c1e1f8) (:border-color |#7db8df) (:color |#24567d)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-count $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-count
            {} $ |& $ {} (:font-size |28px) (:font-weight |700) (:line-height |1.1)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-head
            {} $ |& $ {} (:padding |10px) (:color |#637f9d) (:font-size |12px) (:font-weight |700) (:text-align |center)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-head-row $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-head-row
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|170px repeat(5, minmax(150px, 1fr))") (:gap |8px) (:min-width |950px)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-row $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-row
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|170px repeat(5, minmax(150px, 1fr))") (:gap |8px)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-row-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-row-label
            {} $ |& $ {} (:display |flex) (:align-items |center) (:padding |10px) (:color |#3d5d7d) (:font-size |13px) (:font-weight |700)
          :examples $ []
          :schema $ :: 'String
        'style-heatmap-rows $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-heatmap-rows
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |8px) (:margin-top |8px) (:min-width |950px)
          :examples $ []
          :schema $ :: 'String
        'style-history-caption $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-caption
            {} $ |& $ {} (:margin-top |1px) (:font-size |11px) (:font-weight |680) (:color |#50647f)
          :examples $ []
          :schema $ :: 'String
        'style-history-connector $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-connector
            {} $ |& $ {} (:display |flex) (:align-items |center) (:justify-content |center) (:flex "|0 0 10px") (:margin "|0 1px") (:font-size |10px) (:font-weight |700) (:color |#b4c3d4)
          :examples $ []
          :schema $ :: 'String
        'style-history-connector-group $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-connector-group
            {} $ |& $ {} (:display |flex) (:align-items |center) (:justify-content |center) (:flex "|0 0 42px") (:margin "|0 2px") (:font-size |9px) (:font-weight |720) (:letter-spacing |0.03em) (:color |#91a6c0) (:white-space |nowrap)
          :examples $ []
          :schema $ :: 'String
        'style-history-era $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-era
            {} $ |& $ {} (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |9px) (:font-weight |650) (:letter-spacing |0.06em) (:color |#9aacbf) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
          :examples $ []
          :schema $ :: 'String
        'style-history-item $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-item
            {} $ |& $ {} (:display |flex) (:align-items |center) (:flex "|0 0 auto") (:min-width |0px)
          :examples $ []
          :schema $ :: 'String
        'style-history-kicker $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-kicker
            {} $ |& $ {} (:font-size |9px) (:font-weight |760) (:letter-spacing |0.15em) (:color |#91a5bd)
          :examples $ []
          :schema $ :: 'String
        'style-history-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-label
            {} $ |& $ {} (:margin-top |0px) (:font-size |11px) (:font-weight |720) (:line-height |1.25) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
          :examples $ []
          :schema $ :: 'String
        'style-history-map-toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-map-toggle
            {} $ |& $ {} (:flex "|0 0 auto") (:padding "|5px 7px") (:border "|1px solid #cbdff4") (:border-radius |6px) (:background |#ffffff) (:color |#3b6895) (:font-size |10px) (:font-weight |700) (:letter-spacing |.06em) (:cursor |pointer)
          :examples $ []
          :schema $ :: 'String
        'style-history-node $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-node
            {}
              |& $ {} (:flex "|0 0 auto") (:min-width |0px) (:padding "|4px 6px") (:border "|1px solid #dfeaf6") (:border-radius |6px) (:background "|rgba(255,255,255,.72)") (:text-align |left) (:color |#64758d) (:cursor |pointer)
                :transition "|background-color 150ms ease, border-color 150ms ease, box-shadow 150ms ease, transform 150ms ease"
                :outline |none
                :display |flex
                :align-items |center
                :gap |4px
              |&:hover $ {} (:transform "|translateY(-1px)") (:border-color |#bfd5ef) (:background |#ffffff) (:box-shadow "|0 6px 16px rgba(89, 125, 170, .09)")
          :examples $ []
          :schema $ :: 'String
        'style-history-node-current $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-node-current
            {} $ |& $ {} (:border-color |#9fc3ef) (:background "|linear-gradient(145deg, #ffffff, #eef6ff)") (:color |#34587f)
              :box-shadow "|0 0 0 2px rgba(152, 194, 242, .16), 0 7px 18px rgba(83, 125, 176, .10)"
          :examples $ []
          :schema $ :: 'String
        'style-history-node-visited $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-node-visited
            {} $ |& $ {} (:background |#f7fbff) (:border-color |#d2e2f3) (:color |#71859e)
          :examples $ []
          :schema $ :: 'String
        'style-history-overview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-overview
            {} $ |& $ {} (:display |flex) (:align-items |center) (:gap |5px) (:flex "|0 0 116px") (:min-width |116px) (:padding-left |2px) (:white-space |nowrap)
          :examples $ []
          :schema $ :: 'String
        'style-history-timeline $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-timeline
            {} $ |& $ {} (:grid-column "|1 / -1") (:display |flex) (:align-items |center) (:gap |12px) (:min-height |52px) (:box-sizing |border-box) (:padding "|6px 14px") (:background "|rgba(250, 253, 255, .90)") (:border-bottom "|1px solid #dce9f6") (:box-shadow "|0 8px 28px rgba(82, 117, 166, .06)") (:backdrop-filter "|blur(18px)") (:z-index |10)
          :examples $ []
          :schema $ :: 'String
        'style-history-track $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-track
            {} $ |& $ {} (:display |flex) (:align-items |center) (:flex |1) (:min-width |0px) (:overflow-x |auto) (:padding "|2px 0 4px")
          :examples $ []
          :schema $ :: 'String
        'style-history-view-switcher $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-view-switcher
            {} $ |& $ {} (:display |flex) (:gap |6px) (:margin-left |12px)
          :examples $ []
          :schema $ :: 'String
        'style-history-view-toggle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-view-toggle
            {}
              |& $ {} (:border "|1px solid #c9dcee") (:border-radius |7px) (:background |#f8fbff) (:color |#547391) (:padding "|6px 9px") (:font-size |11px) (:font-weight |700) (:letter-spacing |0.4px) (:cursor |pointer)
              |&:hover $ {} (:background |#eef7ff) (:color |#2e67a1)
          :examples $ []
          :schema $ :: 'String
        'style-history-view-toggle-active $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-history-view-toggle-active
            {} $ |& $ {} (:border "|1px solid #83b5e8") (:background |#e1f0ff) (:color |#1f5e99) (:box-shadow "|0 2px 7px rgba(63, 125, 190, .16)")
          :examples $ []
          :schema $ :: 'String
        'style-overview-card $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card
            {}
              |& $ {} (:width |100%) (:padding |12px) (:border "|1px solid #dce8f4") (:border-radius |9px) (:background |#ffffff) (:color |#334b68) (:text-align |left) (:cursor |pointer)
                :transition "|transform 160ms ease, box-shadow 160ms ease, border-color 160ms ease"
              |&:hover $ {} (:transform "|translateY(-2px)") (:border-color |#afd2f5) (:box-shadow "|0 10px 22px rgba(74, 125, 181, .12)")
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-era $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-era
            {} $ |& $ {} (:font-size |10px) (:font-weight |720) (:letter-spacing |.08em) (:color |#7190b1)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-list
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |10px)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-meta $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-meta
            {} $ |& $ {} (:display |flex) (:align-items |center) (:justify-content |space-between) (:gap |6px) (:font-size |10px) (:font-weight |700) (:letter-spacing |.04em) (:color |#7190b1)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-metric $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-metric
            {} $ |& $ {} (:padding "|3px 5px") (:border-radius |4px) (:background |#eff5fb)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-metrics $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-metrics
            {} $ |& $ {} (:display |flex) (:flex-wrap |wrap) (:gap |4px) (:margin-top |9px) (:font-size |10px) (:color |#66809d)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-summary $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-summary
            {} $ |& $ {} (:font-size |12px) (:line-height |1.55) (:color |#62768e)
          :examples $ []
          :schema $ :: 'String
        'style-overview-card-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-card-title
            {} $ |& $ {} (:margin "|4px 0 6px") (:font-size |16px) (:font-weight |720) (:color |#2a4c70)
          :examples $ []
          :schema $ :: 'String
        'style-overview-lane $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-lane
            {} $ |& $ {} (:min-height |0px) (:padding |15px) (:border "|1px solid #d8e7f5") (:border-radius |12px) (:background "|rgba(255,255,255,.72)") (:box-shadow "|0 12px 32px rgba(83, 119, 165, .07)")
          :examples $ []
          :schema $ :: 'String
        'style-overview-lane-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-lane-note
            {} $ |& $ {} (:margin "|5px 0 15px") (:font-size |12px) (:line-height |1.45) (:color |#71839a)
          :examples $ []
          :schema $ :: 'String
        'style-overview-lane-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-lane-title
            {} $ |& $ {} (:font-size |17px) (:font-weight |720) (:color |#294b70)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map
            {} $ |& $ {} (:position |fixed) (:top |52px) (:right |0px) (:bottom |0px) (:left |0px) (:z-index |20) (:box-sizing |border-box) (:overflow-y |auto) (:padding "|26px 32px 36px")
              :background "|linear-gradient(135deg, #f6fbff 0%, #fbf9ff 52%, #f2fcfb 100%)"
              :color |#263650
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-close $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-close
            {} $ |& $ {} (:padding "|8px 11px") (:border "|1px solid #bdd8f4") (:border-radius |7px) (:background |#ffffff) (:color |#3d6a98) (:font-size |12px) (:font-weight |650) (:cursor |pointer)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-grid $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-grid
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|repeat(4, minmax(240px, 1fr))") (:gap |14px) (:margin "|0px auto") (:max-width |1740px)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-head
            {} $ |& $ {} (:display |flex) (:align-items |center) (:justify-content |space-between) (:gap |20px) (:margin "|0 auto 24px") (:max-width |1500px)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-kicker $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-kicker
            {} $ |& $ {} (:font-size |10px) (:font-weight |760) (:letter-spacing |.14em) (:color |#6080a2)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-note
            {} $ |& $ {} (:margin "|4px auto 18px") (:max-width |1740px) (:font-size |13px) (:line-height |1.45) (:color |#667d98)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-summary $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-summary
            {} $ |& $ {} (:display |flex) (:gap |10px) (:flex-wrap |wrap) (:max-width |1740px) (:margin "|0 auto 10px") (:color |#6e86a2) (:font-size |13px)
          :examples $ []
          :schema $ :: 'String
        'style-overview-map-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-map-title
            {} $ |& $ {} (:margin-top |5px) (:font-size |27px) (:font-weight |720) (:letter-spacing |-.035em) (:color |#1e3858)
          :examples $ []
          :schema $ :: 'String
        'style-overview-network $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-network
            {} $ |& $ {} (:height "|calc(100vh - 176px)") (:min-height |760px) (:margin "|0 auto 16px") (:max-width |1740px) (:border "|1px solid #d7e7f5") (:border-radius |12px) (:background "|rgba(255,255,255,.78)") (:box-shadow "|0 10px 30px rgba(83, 119, 165, .07)") (:overflow |hidden) (:position |relative)
          :examples $ []
          :schema $ :: 'String
        'style-overview-network-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-overview-network-note
            {} $ |& $ {} (:position |absolute) (:top |12px) (:left |14px) (:z-index |2) (:padding "|5px 7px") (:border "|1px solid rgba(193, 216, 238, .84)") (:border-radius |5px) (:background "|rgba(250,253,255,.90)") (:color |#607a98) (:font-size |11px) (:pointer-events |none)
          :examples $ []
          :schema $ :: 'String
        'style-reader-article-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-article-head
            {} $ |& $ {} (:max-width |1180px) (:margin |0) (:padding "|8px 0 24px") (:border-bottom "|1px solid #d6e6f7")
          :examples $ []
          :schema $ :: 'String
        'style-reader-article-summary $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-article-summary
            {} $ |& $ {} (:margin-top |18px) (:max-width |790px) (:font-size |19px) (:line-height |1.72) (:color |#536278)
          :examples $ []
          :schema $ :: 'String
        'style-reader-article-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-article-title
            {} $ |& $ {} (:margin-top |10px) (:font-size "|clamp(36px, 4vw, 58px)") (:font-weight |780) (:letter-spacing |-0.05em) (:line-height |1.05)
          :examples $ []
          :schema $ :: 'String
        'style-reader-brand $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-brand
            {} $ |& $ {} (:padding "|4px 4px 24px") (:border-bottom "|1px solid #d6dee9")
          :examples $ []
          :schema $ :: 'String
        'style-reader-brand-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-brand-note
            {} $ |& $ {} (:margin-top |8px) (:font-size |14px) (:line-height |1.55) (:color |#69788d)
          :examples $ []
          :schema $ :: 'String
        'style-reader-brand-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-brand-title
            {} $ |& $ {} (:margin-top |9px) (:font-size |25px) (:font-weight |760) (:letter-spacing |-0.025em)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-body $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-body
            {} $ |& $ {} (:margin-top |26px) (:font-size |18px) (:line-height |1.9) (:color |#435167)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-divider $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-divider
            {} $ |& $ {} (:height |1px) (:margin "|34px 0 26px") (:background |#e4e9f0)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-hint $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-hint
            {} $ |& $ {} (:margin-top |8px) (:font-size |14px) (:color |#8a96a7)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-kicker $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-kicker
            {} $ |& $ {} (:font-size |11px) (:font-weight |760) (:letter-spacing |0.15em) (:color |#7390b7)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-subtitle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-subtitle
            {} $ |& $ {} (:font-size |15px) (:font-weight |730) (:color |#243550)
          :examples $ []
          :schema $ :: 'String
        'style-reader-detail-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-detail-title
            {} $ |& $ {} (:margin-top |11px) (:font-size |31px) (:font-weight |770) (:letter-spacing |-0.035em)
          :examples $ []
          :schema $ :: 'String
        'style-reader-dimension-card $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-dimension-card
            {} $ |& $ {} (:min-width 0) (:padding "|10px 12px 12px") (:border "|1px solid #d8e6f5") (:border-radius |8px)
              :background "|linear-gradient(145deg, rgba(255,255,255,.92), rgba(242,247,255,.84))"
              :box-shadow "|0 5px 16px rgba(82,117,166,.06)"
          :examples $ []
          :schema $ :: 'String
        'style-reader-dimension-grid $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-dimension-grid
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|repeat(4, minmax(0, 1fr))") (:gap |8px) (:margin-top |20px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-dimension-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-dimension-label
            {} $ |& $ {} (:font-size |10px) (:font-weight |700) (:letter-spacing |0.08em) (:color |#8292aa)
          :examples $ []
          :schema $ :: 'String
        'style-reader-dimension-value $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-dimension-value
            {} $ |& $ {} (:margin-top |5px) (:font-size |14px) (:font-weight |680) (:color |#3c567a) (:white-space |nowrap) (:overflow |hidden) (:text-overflow |ellipsis)
          :examples $ []
          :schema $ :: 'String
        'style-reader-empty-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-empty-note
            {} $ |& $ {} (:padding "|10px 4px") (:font-size |13px) (:line-height |1.5) (:color |#73849e)
          :examples $ []
          :schema $ :: 'String
        'style-reader-eyebrow $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-eyebrow
            {} $ |& $ {} (:font-size |11px) (:font-weight |750) (:letter-spacing |0.16em) (:color |#5b77a1)
          :examples $ []
          :schema $ :: 'String
        'style-reader-formula $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-formula
            {} $ |& $ {} (:margin-top |22px) (:display |inline-block) (:padding "|13px 17px") (:border "|1px solid #cbd9ec") (:border-radius |10px) (:background |#eaf0f8) (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |18px) (:color |#234d88)
          :examples $ []
          :schema $ :: 'String
        'style-reader-history-button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-history-button
            {}
              |& $ {} (:width |100%) (:min-height |40px) (:padding "|8px 12px") (:border "|1px solid #dce7f3") (:border-radius |8px) (:background "|rgba(255,255,255,.72)") (:color |#53657f) (:font-size |14px) (:font-weight |600) (:text-align |left) (:cursor |pointer)
              |&:hover $ {} (:border-color |#b8d1f1) (:background |#f6faff)
          :examples $ []
          :schema $ :: 'String
        'style-reader-left $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-left
            {} $ |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|20px 16px 32px") (:background "|rgba(247, 251, 255, .82)") (:overflow-y |auto) (:border-right "|1px solid #d9e7f6") (:box-shadow "|8px 0 30px rgba(85, 119, 166, .07)") (:backdrop-filter "|blur(18px)") (:min-height |0px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-meta $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-meta
            {} $ |& $ {} (:font-size |13px) (:font-weight |720) (:letter-spacing |0.08em) (:color |#5b77a1)
          :examples $ []
          :schema $ :: 'String
        'style-reader-middle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-middle
            {} $ |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|24px clamp(24px, 2.5vw, 48px) 48px") (:background "|rgba(255, 255, 255, .76)") (:overflow-y |auto) (:backdrop-filter "|blur(12px)") (:min-height |0px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-nav-button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-nav-button
            {}
              |& $ {} (:width |100%) (:min-height |44px) (:padding "|12px 12px") (:border "|1px solid #d7e4f3") (:border-left "|3px solid #aac8ef") (:border-radius |8px) (:background "|rgba(255,255,255,.82)") (:box-shadow "|0 6px 18px rgba(82,117,166,.07)") (:color |#33445f) (:font-size |15px) (:font-weight |650) (:text-align |left) (:cursor |pointer)
                :transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease"
              |&:hover $ {} (:border-color |#b4cff1) (:box-shadow "|0 10px 22px rgba(82,117,166,.12)") (:transform "|translateY(-1px)")
          :examples $ []
          :schema $ :: 'String
        'style-reader-nav-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-nav-list
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |10px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-nav-section $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-nav-section
            {} $ |& $ {} (:margin-top |27px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-nav-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-nav-title
            {} $ |& $ {} (:margin "|0 4px 11px") (:font-size |12px) (:font-weight |720) (:letter-spacing |0.1em) (:color |#8091ab)
          :examples $ []
          :schema $ :: 'String
        'style-reader-outline-active $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-outline-active
            {} $ |& $ {} (:background |#f8fbff) (:border-color |#b9d7f6) (:color |#24598c) (:box-shadow "|0 4px 12px rgba(81, 135, 194, .08)")
          :examples $ []
          :schema $ :: 'String
        'style-reader-outline-index $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-outline-index
            {} $ |& $ {} (:flex "|0 0 19px") (:width |19px) (:height |19px) (:border-radius |50%) (:background |#eaf2fb) (:color |#7591af) (:font-size |9px) (:font-weight |700) (:line-height |19px) (:text-align |center)
          :examples $ []
          :schema $ :: 'String
        'style-reader-outline-item $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-outline-item
            {}
              |& $ {} (:display |flex) (:align-items |center) (:gap |7px) (:width |100%) (:padding "|7px 8px") (:border "|1px solid transparent") (:border-radius |7px) (:background |transparent) (:color |#73839a) (:font-size |12px) (:line-height |1.25) (:text-align |left) (:cursor |pointer)
                :transition "|background-color 150ms ease, border-color 150ms ease, color 150ms ease"
              |&:hover $ {} (:background |#ffffff) (:border-color |#d8e6f5) (:color |#435b78)
          :examples $ []
          :schema $ :: 'String
        'style-reader-outline-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-outline-label
            {} $ |& $ {} (:overflow |hidden) (:white-space |nowrap) (:text-overflow |ellipsis)
          :examples $ []
          :schema $ :: 'String
        'style-reader-outline-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-outline-list
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |4px) (:margin-top |8px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-page $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-page
            {} $ |& $ {} (:position |fixed) (:inset 0) (:display |grid) (:grid-template-columns "|272px minmax(680px, 1fr) minmax(340px, 410px)")
              :background "|linear-gradient(135deg, #edf5ff 0%, #f7f4ff 48%, #eef9fb 100%)"
              :font-family "|Inter, IBM Plex Sans, Segoe UI, -apple-system, sans-serif"
              :color |#263650
              :overflow |hidden
              :grid-template-rows "|auto minmax(0, 1fr)"
          :examples $ []
          :schema $ :: 'String
        'style-reader-related-card $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-related-card
            {}
              |& $ {} (:padding "|16px 16px 20px") (:border "|1px solid #d7e5f4") (:border-top "|2px solid #b8d1f2") (:border-radius |8px)
                :background "|linear-gradient(145deg, rgba(255,255,255,.94), rgba(245,249,255,.88))"
                :box-shadow "|0 8px 24px rgba(82,117,166,.08)"
                :text-align |left
                :cursor |pointer
                :transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease, background-color 160ms ease"
              |&:hover $ {} (:border-color |#afcbef) (:border-top-color |#82aef2) (:background |#f7fbff) (:box-shadow "|0 12px 30px rgba(82,117,166,.13)") (:transform "|translateY(-2px)")
          :examples $ []
          :schema $ :: 'String
        'style-reader-related-cards $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-related-cards
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |8px) (:margin-top |18px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-related-relation $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-related-relation
            {} $ |& $ {} (:font-size |11px) (:font-weight |720) (:color |#6f8caf)
          :examples $ []
          :schema $ :: 'String
        'style-reader-related-summary $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-related-summary
            {} $ |& $ {} (:margin-top |6px) (:font-size |13px) (:line-height |1.5) (:color |#788596)
          :examples $ []
          :schema $ :: 'String
        'style-reader-related-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-related-title
            {} $ |& $ {} (:margin-top |5px) (:font-size |16px) (:font-weight |710) (:color |#26364e)
          :examples $ []
          :schema $ :: 'String
        'style-reader-relation-button $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-relation-button
            {}
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |4px) (:width |100%) (:padding "|12px 12px") (:border "|1px solid #d7e5f4") (:border-left "|3px solid #a9c9f2") (:border-radius |8px) (:background "|rgba(255,255,255,.80)") (:box-shadow "|0 6px 18px rgba(82,117,166,.07)") (:text-align |left) (:cursor |pointer)
                :transition "|border-color 160ms ease, transform 160ms ease, box-shadow 160ms ease"
              |&:hover $ {} (:border-color |#b2cef1) (:transform "|translateY(-1px)") (:box-shadow "|0 10px 24px rgba(82,117,166,.11)")
          :examples $ []
          :schema $ :: 'String
        'style-reader-relation-name $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-relation-name
            {} $ |& $ {} (:font-size |14px) (:font-weight |650) (:color |#26364e)
          :examples $ []
          :schema $ :: 'String
        'style-reader-relation-tag $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-relation-tag
            {} $ |& $ {} (:font-size |11px) (:font-weight |700) (:color |#7fa6dd)
          :examples $ []
          :schema $ :: 'String
        'style-reader-right $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-right
            {} $ |& $ {} (:height |100%) (:box-sizing |border-box) (:padding "|24px 20px 40px") (:background "|rgba(248, 251, 255, .82)") (:border-left "|1px solid #d9e7f6") (:box-shadow "|-8px 0 30px rgba(85, 119, 166, .06)") (:overflow-y |auto) (:backdrop-filter "|blur(18px)") (:min-height |0px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-active $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-active
            {} $ |& $ {} (:border-color |#a9c9f4) (:border-left-color |#79a9ef)
              :background "|linear-gradient(135deg, #f7fbff 0%, #f5f3ff 100%)"
              :box-shadow "|0 16px 38px rgba(100, 126, 189, .16), 0 0 0 1px rgba(137,178,238,.12)"
              :transform "|translateY(-2px)"
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-card $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-card
            {}
              |& $ {} (:width |100%) (:box-sizing |border-box) (:padding "|24px 28px 28px") (:border "|1px solid #d8e6f5") (:border-left "|4px solid #b9d3f4") (:border-radius |8px)
                :background "|linear-gradient(145deg, rgba(255,255,255,.96), rgba(247,251,255,.90))"
                :box-shadow "|0 10px 28px rgba(82, 117, 166, .09), inset 0 1px 0 rgba(255,255,255,.95)"
                :text-align |left
                :color |#263650
                :cursor |pointer
                :transition "|border-color 160ms ease, box-shadow 160ms ease, transform 160ms ease, background-color 160ms ease"
              |&:hover $ {} (:border-color |#a9c9f4) (:border-left-color |#82aef2) (:transform "|translateY(-2px)")
                :box-shadow "|0 14px 34px rgba(82, 117, 166, .14), 0 0 0 1px rgba(166,203,247,.18)"
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-footer $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-footer
            {} $ |& $ {} (:display |flex) (:align-items |baseline) (:gap |10px) (:margin-top |18px) (:padding-top |11px) (:border-top "|1px solid #e8f0f8") (:font-size |12px) (:line-height |1.5) (:color |#8b9bb0)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-footer-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-footer-label
            {} $ |& $ {} (:flex-shrink |0) (:font-size |10px) (:font-weight |720) (:letter-spacing |0.11em) (:text-transform |uppercase) (:color |#a2b0c2)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-footer-links $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-footer-links
            {} $ |& $ {} (:overflow |hidden) (:text-overflow |ellipsis) (:white-space |nowrap) (:color |#7e90a8)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-grid $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-grid
            {} $ |& $ {} (:max-width |1180px) (:margin "|16px 0 0") (:display |flex) (:flex-direction |column) (:gap |12px) (:padding-bottom |24px)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-head
            {} $ |& $ {} (:display |flex) (:align-items |baseline) (:justify-content |space-between) (:gap |18px) (:width |100%)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-heading $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-heading
            {} $ |& $ {} (:display |flex) (:align-items |baseline) (:min-width |0px) (:flex |1)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-hint $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-hint
            {} $ |& $ {} (:margin-top |8px) (:font-size |13px) (:font-weight |620) (:color |#7890ae)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-number $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-number
            {} $ |& $ {} (:font-family "|ui-monospace, SFMono-Regular, Menlo, monospace") (:font-size |12px) (:font-weight |720) (:color |#86a0c3)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-preview $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-preview
            {} $ |& $ {} (:margin-top |20px) (:font-size |17px) (:line-height |1.92) (:letter-spacing |0.005em) (:color |#48576c) (:white-space |pre-wrap)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-tags $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-tags
            {} $ |& $ {} (:flex-shrink |0) (:max-width |48%) (:font-size |12px) (:font-weight |600) (:line-height |1.5) (:letter-spacing |0.01em) (:text-align |right) (:color |#8295ad)
          :examples $ []
          :schema $ :: 'String
        'style-reader-section-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-section-title
            {} $ |& $ {} (:margin-top |0px) (:font-size |25px) (:font-weight |750) (:letter-spacing |-0.02em) (:line-height |1.3)
          :examples $ []
          :schema $ :: 'String
        'style-reader-tag $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-tag
            {} $ |& $ {} (:padding "|4px 8px") (:border-radius |6px) (:background "|linear-gradient(135deg, #edf5ff, #f2efff)") (:border "|1px solid #d9e6f5") (:color |#53709a) (:font-size |12px) (:font-weight |620)
          :examples $ []
          :schema $ :: 'String
        'style-reader-tag-row $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-reader-tag-row
            {} $ |& $ {} (:display |flex) (:flex-wrap |wrap) (:gap |7px) (:margin-top |18px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-board $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-board
            {} $ |& $ {} (:max-width |1180px) (:margin "|0 auto") (:padding "|18px 10px 54px")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branch $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branch
            {} $ |& $ {} (:padding "|14px 15px 15px") (:border "|1px solid #d7e6f3") (:border-radius |10px) (:background "|rgba(255,255,255,.78)") (:box-shadow "|0 6px 20px rgba(79,120,163,.05)")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branch-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branch-head
            {} $ |& $ {} (:display |flex) (:align-items |center) (:gap |8px) (:margin-bottom |7px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branch-index $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branch-index
            {} $ |& $ {} (:display |inline-flex) (:align-items |center) (:justify-content |center) (:width |20px) (:height |20px) (:border-radius |5px) (:background |#e8f3fd) (:font-size |10px) (:font-weight |800) (:color |#5c8bb8)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branch-note $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branch-note
            {} $ |& $ {} (:margin "|0 0 11px") (:font-size |13px) (:line-height |1.62) (:color |#5d748c)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branch-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branch-title
            {} $ |& $ {} (:font-size |16px) (:font-weight |760) (:color |#315779)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-branches $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-branches
            {} $ |& $ {} (:display |flex) (:flex-direction |column) (:gap |12px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event
            {}
              |& $ {} (:display |grid) (:grid-template-columns "|30px minmax(0, 1fr)") (:column-gap |10px) (:width |100%) (:padding "|13px 14px") (:box-sizing |border-box) (:border "|1px solid #d7e6f4") (:border-radius |9px) (:background "|rgba(255, 255, 255, .84)") (:color |#334b68) (:text-align |left) (:cursor |pointer)
                :transition "|transform 160ms ease, box-shadow 160ms ease, border-color 160ms ease"
              |&:hover $ {} (:transform "|translateY(-2px)") (:border-color |#9dc8ee) (:box-shadow "|0 10px 22px rgba(74, 125, 181, .11)")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-body $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-body
            {} $ |& $ {} (:min-width |0)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-list $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-list
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|repeat(2, minmax(0, 1fr))") (:gap |10px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-meta $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-meta
            {} $ |& $ {} (:overflow |hidden) (:margin-bottom |3px) (:font-size |11px) (:font-weight |650) (:color |#7391ae) (:text-overflow |ellipsis) (:white-space |nowrap)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-order $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-order
            {} $ |& $ {} (:padding-top |2px) (:font-size |11px) (:font-weight |800) (:letter-spacing |0.3px) (:color |#82a6c8)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-summary $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-summary
            {} $ |& $ {} (:display |-webkit-box) (:overflow |hidden) (:font-size |12px) (:line-height |1.52) (:color |#637991) (:-webkit-line-clamp |2) (:-webkit-box-orient |vertical)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-event-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-event-title
            {} $ |& $ {} (:margin-bottom |5px) (:font-size |16px) (:font-weight |740) (:color |#2d5277)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-handoff $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-handoff
            {} $ |& $ {} (:margin-top |12px) (:padding "|11px 14px") (:border-radius |8px) (:background |#f1f8ff) (:font-size |13px) (:line-height |1.55) (:color |#51708d)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-handoff-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-handoff-label
            {} $ |& $ {} (:margin-right |10px) (:font-size |11px) (:font-weight |800) (:letter-spacing |0.35px) (:color |#3e78a9)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-narrative $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-narrative
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|96px minmax(0,1fr)") (:column-gap |12px) (:row-gap |7px) (:margin-bottom |16px) (:padding "|13px 15px") (:border-left "|3px solid #b8d8f3") (:border-radius |0px) (:background "|rgba(249,252,255,.72)")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-narrative-label $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-narrative-label
            {} $ |& $ {} (:padding-top |1px) (:font-size |11px) (:font-weight |800) (:letter-spacing |0.5px) (:color |#5d85ad)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-narrative-text $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-narrative-text
            {} $ |& $ {} (:font-size |13px) (:line-height |1.65) (:color |#48627d)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage
            {} $ |& $ {} (:position |relative) (:display |grid) (:grid-template-columns "|112px 52px minmax(0, 1fr)") (:column-gap |14px) (:padding-bottom |32px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-content $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-content
            {} $ |& $ {} (:min-width |0) (:padding-bottom |4px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-count $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-count
            {} $ |& $ {} (:flex "|0 0 auto") (:font-size |12px) (:font-weight |650) (:color |#7290ad)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-era $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-era
            {} $ |& $ {} (:padding-top |12px) (:font-size |13px) (:font-weight |740) (:letter-spacing |0.4px) (:color |#5880a8) (:text-align |right)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-head $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-head
            {} $ |& $ {} (:display |flex) (:align-items |baseline) (:justify-content |space-between) (:gap |16px) (:margin "|5px 0 12px")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-marker $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-marker
            {} $ |& $ {} (:position |relative) (:z-index |1) (:display |flex) (:align-items |center) (:justify-content |center) (:width |36px) (:height |36px) (:margin-top |2px) (:box-sizing |border-box) (:border "|2px solid #94c4ec") (:border-radius |50%) (:background |#f8fcff) (:font-size |11px) (:font-weight |800) (:color |#3474ac) (:box-shadow "|0 0 0 5px rgba(247, 251, 255, .8)")
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stage-title $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stage-title
            {} $ |& $ {} (:font-size |22px) (:font-weight |750) (:letter-spacing |-0.3px) (:color |#294c70)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-stages $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-stages
            {} $ |& $ {} (:display |grid) (:grid-template-columns "|repeat(5, minmax(245px, 1fr))") (:gap |14px) (:min-width |1320px)
          :examples $ []
          :schema $ :: 'String
        'style-timeline-vertical $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstyle style-timeline-vertical
            {}
              |& $ {} (:position |relative) (:display |flex) (:flex-direction |column) (:gap |0)
              |&:before $ {} (:position |absolute) (:top |28px) (:bottom |36px) (:left |138px) (:width |2px) (:background |#c7ddf3) (:content "|\"")
          :examples $ []
          :schema $ :: 'String
        'validate-knowledge-docs! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn validate-knowledge-docs! (documents)
            let
                ids $ map documents $ fn (doc) (:id doc)
                docs $ foldl documents ({})
                  fn (acc doc)
                    hint-fn $ {}
                      :args $ [] (:: 'Map 'String 'app.schema/KnowledgeDoc) 'app.schema/KnowledgeDoc
                      :return $ :: 'Map 'String 'app.schema/KnowledgeDoc
                    assoc acc (:id doc) doc
                duplicates $ distinct $ filter ids
                  fn (id)
                    >
                      count $ filter ids $ fn (candidate) (= id candidate)
                      , 1
                duplicate-errors $ map duplicates $ fn (id)
                  {} (:level :error) (:code :duplicate-id) (:source id)
                    :message $ str "|Duplicate knowledge id: " id
                broken-reference-errors $ mapcat documents $ fn (doc)
                  let
                      doc-id $ :id doc
                      missing $ filter (knowledge-doc-reference-ids doc)
                        fn (target-id)
                          not $ contains? docs target-id
                    map missing $ fn (target-id)
                      {} (:level :error) (:code :broken-reference) (:source doc-id) (:target target-id)
                        :message $ str "|Broken knowledge reference: " doc-id "|→" target-id
                queue-errors $ mapcat documents $ fn (doc)
                  let
                      doc-id $ :id doc
                      invalid $ filter
                          :queue doc
                          , .unwrap-or $ []
                        fn (target-id)
                          let
                              target $ get docs target-id
                            if (target .none?) true $ let
                                target-doc $ option:unwrap target
                              or
                                not= :section $
                                  :kind target-doc
                                  , .unwrap-or :unknown
                                not= doc-id $
                                  :parent target-doc
                                  , .unwrap-or ||
                    map invalid $ fn (target-id)
                      {} (:level :error) (:code :invalid-queue-entry) (:source doc-id) (:target target-id)
                        :message $ str "|Invalid knowledge queue: " doc-id "|→" target-id
                relation-errors $ mapcat documents $ fn (doc)
                  let
                      doc-id $ :id doc
                      invalid $ filter
                          :relations doc
                          , .unwrap-or $ []
                        fn (relation)
                          or
                            not $ or
                              = :outgoing $
                                :direction relation
                                , .unwrap-or :unknown
                              = :incoming $
                                :direction relation
                                , .unwrap-or :unknown
                            and
                              = :outgoing $
                                :direction relation
                                , .unwrap-or :unknown
                              (:target relation) .none?
                            and
                              = :incoming $
                                :direction relation
                                , .unwrap-or :unknown
                              (:source relation) .none?
                    map invalid $ fn (relation)
                      {} (:level :error) (:code :invalid-relation) (:source doc-id) (:relation relation)
                        :message $ str "|Invalid knowledge relation: " doc-id "|→" $ format-cirru-edn relation
                warnings $ mapcat documents $ fn (doc)
                  let
                      doc-id $ :id doc
                      missing-summary? $ empty? $
                        :summary doc
                        , .unwrap-or ||
                      missing-tags? $ and
                        not= :section $
                          :kind doc
                          , .unwrap-or :concept
                        empty? $
                          :tags doc
                          , .unwrap-or $ #{}
                      isolated? $ and
                        not= :section $
                          :kind doc
                          , .unwrap-or :concept
                        empty? $
                          :links doc
                          , .unwrap-or $ []
                        empty? $
                          :relations doc
                          , .unwrap-or $ []
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
                :errors $ concat duplicate-errors $ concat broken-reference-errors (concat queue-errors relation-errors)
                :warnings warnings
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] $ :: 'List 'app.schema/KnowledgeDoc
            :return $ :: 'Map 'Tag $ :: 'List (:: 'Map 'Tag 'Dynamic)
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require
            respo.css :refer $ defstyle
            respo.core :refer $ defcomp defeffect <> >> div button span list->
            reel.comp.reel :refer $ comp-typed-reel
            app.config :refer $ dev?
            respo-md.comp.md :refer $ comp-md-block
            |cytoscape :default cytoscape
            |cytoscape-fcose :default fcose
            app.schema :refer $ Op decode-knowledge-doc
            js-ffi.browser :as browser
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev?
            = |dev $
              get-env |mode
              , .unwrap-or |release
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*reel $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *reel
            typed/State :base schema/store :store schema/store :records ([]) :pointer (Option :none) :stopped? false :display? false :merged? false
          :examples $ []
          :schema $ :: 'Ref $ :: 'reel.typed/State 'app.schema/Op (:: 'Map 'Tag 'Dynamic)
        '*storage-ready? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *storage-ready? false
          :examples $ []
          :schema $ :: 'Ref 'Bool
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (raw-op)
            if (enum? raw-op)
              let
                  next $ match (typed/decode-control raw-op)
                    (:some control) (typed/apply-control updater @*reel control)
                    (:none)
                      typed/record-op updater @*reel (decode-map-as raw-op 'app.schema/Op)
                        decode-map-as (shortid/generate) 'String
                        decode-map-as (js/Date.now) 'Number
                reset! *reel next
              raise |Dispatch-expected-an-Enum
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
            :features $ #{} :js-ffi
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! ()
            println |Running-mode: $ if config/dev? |dev |release
            if config/dev? $ load-console-formatter!
            render-app!
            add-watch! *reel :changes $ fn (reel prev) (render-app!)
            listen-devtools! |k dispatch!
            try
              do
                match
                  browser/storage-get $ option:unwrap $ get config/site :storage-key
                  (:some raw)
                    dispatch! $ schema/Op :hydrate-storage $ schema/decode-store (parse-cirru-edn raw)
                  (:none) &unit
                reset! *storage-ready? true
                , &unit
              fn (error) (eprintln |Could-not-restore-saved-data error) (hud! |error "|存档恢复失败，已暂停自动保存。") &unit
            browser/add-event-listener! |beforeunload $ fn (event) (persist-storage!)
            browser/document-add-event-listener! |visibilitychange $ fn (event)
              match (browser/visibility-state)
                (:hidden) (persist-storage!)
                _ &unit
            browser/set-interval!
              fn () $ persist-storage!
              , 60000
            println |App-started.
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn mount-target ()
            option:unwrap $ dom/query-selector |.app
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.dom/DomElement)
            :args $ []
        'persist-storage! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn persist-storage! ()
            when @*storage-ready? $ browser/storage-set!
              option:unwrap $ get config/site :storage-key
              format-cirru-edn $ :store @*reel
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! ()
            if (js-nullish? build-errors)
              do (remove-watch! *reel :changes) (clear-cache!)
                add-watch! *reel :changes $ fn (reel prev) (render-app!)
                reset! *reel $ typed/refresh updater @*reel schema/store
                hud! |ok~ |Ok
              hud! |error build-errors
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! (mount-target)
              fn () $ comp-container @*reel
              , dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            reel.util :refer $ listen-devtools!
            reel.typed :as typed
            app.config :as config
            |./calcit.build-errors.mjs :default build-errors
            |bottom-tip :default hud!
            js-ffi.browser :as browser
            respo.ffi.browser :as dom
            |shortid :as shortid
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'HistoryBranch $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct HistoryBranch (:title 'String) (:note 'String)
            :ids $ :: 'List 'String
          :examples $ []
          :schema $ :: 'StructDef
        'HistoryStage $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct HistoryStage (:id 'String) (:era 'String) (:title 'String) (:question 'String) (:breakthrough 'String) (:handoff 'String)
            :ids $ :: 'List 'String
            :branches $ :: 'List 'app.schema/HistoryBranch
          :examples $ []
          :schema $ :: 'StructDef
        'KnowledgeBundle $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct KnowledgeBundle
            :docs $ :: 'Map 'String 'app.schema/KnowledgeDoc
            :diagnostics $ :: 'Map 'Tag $ :: 'List (:: 'Map 'Tag 'Dynamic)
          :examples $ []
          :schema $ :: 'StructDef
        'KnowledgeDoc $ %{} 'CodeEntry
          :doc "|Markdown 文档元数据。id/content/source/label 为加载器提供的必需字段；其余使用 Option 保留缺失与显式空值的区别，不把缺失 tags 偷换成空集合。"
          :code $ quote $ defstruct KnowledgeDoc (:id 'String) (:content 'String) (:source 'String) (:label 'String)
            :title $ :: 'Option 'String
            :summary $ :: 'Option 'String
            :kind $ :: 'Option 'Tag
            :era $ :: 'Option 'String
            :formula $ :: 'Option 'String
            :tags $ :: 'Option $ :: 'Set 'String
            :links $ :: 'Option $ :: 'List 'String
            :parent $ :: 'Option 'String
            :queue $ :: 'Option $ :: 'List 'String
            :relations $ :: 'Option $ :: 'List 'app.schema/KnowledgeRelation
          :examples $ []
          :schema $ :: 'StructDef
        'KnowledgeEdge $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct KnowledgeEdge (:source 'String) (:target 'String) (:relation 'String) (:kind 'Tag)
          :examples $ []
          :schema $ :: 'StructDef
        'KnowledgeRecommendation $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct KnowledgeRecommendation (:id 'String) (:label 'String) (:summary 'String) (:kind 'String) (:relation 'String) (:direction 'String)
            :tags $ :: 'Set 'String
          :examples $ []
          :schema $ :: 'StructDef
        'KnowledgeRelation $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct KnowledgeRelation
            :direction $ :: 'Option 'Tag
            :source $ :: 'Option 'String
            :target $ :: 'Option 'String
            :kind $ :: 'Option 'Tag
            :label $ :: 'Option 'String
          :examples $ []
          :schema $ :: 'StructDef
        'Op $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defenum Op
            :states (:: 'List 'Dynamic) 'Dynamic
            :hydrate-storage $ :: 'Map 'Tag 'Dynamic
          :examples $ []
          :schema $ :: 'EnumDef
        'ReaderState $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct ReaderState (:selected 'String) (:active-section 'String)
            :history $ :: 'List 'String
            :view 'Tag
          :examples $ []
          :schema $ :: 'StructDef
        'decode-knowledge-doc $ %{} 'CodeEntry
          :doc "|在 Markdown 加载/验证边界一次解码字段及嵌套关系，保留具体错误路径；不使用 Map 到 Struct 的断言。"
          :code $ quote $ defn decode-knowledge-doc (raw) (decode-map-as raw 'app.schema/KnowledgeDoc)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/KnowledgeDoc)
            :args $ [] 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |preserve-absent-versus-empty-tags)
            :code $ quote $ let
                missing $ decode-knowledge-doc $ {} (:id |probe) (:content |body) (:source |synthetic) (:label |Probe)
                explicit-tags $ decode-knowledge-doc $ {} (:id |probe) (:content |body) (:source |synthetic) (:label |Probe)
                  :tags $ #{}
              assert= (Option :none) (:tags missing)
              assert |explicit-empty-tags-remain-present $ option:some? $ :tags explicit-tags
              assert= 0 $ count $ option:unwrap (:tags explicit-tags)
        'decode-reader-state $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-reader-state (raw)
            let
                fields $ decode-map-as
                  if (struct? raw) (&struct:to-map raw) raw
                  :: 'Map 'Tag 'Dynamic
              decode-map-as
                merge
                  {} (:selected |complex-numbers) (:active-section |history)
                    :history $ []
                    :view :reader
                  , fields
                , 'app.schema/ReaderState
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/ReaderState)
            :args $ [] 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |legacy-map-and-archived-struct)
            :code $ quote $ let
                restored $ decode-reader-state $ {} (:selected |quaternions) (:active-section |history)
                  :history $ [] |complex-numbers
                saved $ struct-with restored $ :view :map
                again $ decode-reader-state $ parse-cirru-edn (format-cirru-edn saved)
                bad-message $ try
                  do
                    decode-store $ {} $ :states
                      {} $ :knowledge-graph $ {}
                        :data $ {} $ :selected 42
                    , |unexpected-success
                  fn (message)
                    hint-fn $ {}
                      :args $ [] 'String
                      :return 'String
                    , message
              assert= :reader $ :view restored
              assert= :map $ :view again
              assert= |quaternions $ :selected again
              assert= ([] |complex-numbers) (:history again)
              assert |invalid-selected-is-rejected-before-hydrate $ starts-with? bad-message "|decode-map-as failed at $.selected:"
        'decode-store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn decode-store (raw)
            let
                store $ decode-map-as raw $ :: 'Map 'Tag 'Dynamic
                states $ decode-map-as
                  option:unwrap-or (get store :states) ({})
                  :: 'Map 'Dynamic 'Dynamic
                cursor-states $ match (get states :cursor)
                  (:some raw-cursor)
                    if (nil? raw-cursor)
                      assoc states :cursor $ []
                      assoc states :cursor $ decode-map-as raw-cursor $ :: 'List 'Dynamic
                  (:none) states
                checked-states $ match (get cursor-states :knowledge-graph)
                  (:some raw-branch)
                    let
                        branch $ decode-map-as raw-branch $ :: 'Map 'Dynamic 'Dynamic
                        normalized $ match (get branch :data)
                          (:some data)
                            assoc branch :data $ decode-reader-state data
                          (:none) branch
                      assoc cursor-states :knowledge-graph normalized
                  (:none) cursor-states
              assoc store :states checked-states
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] 'Dynamic
            :return $ :: 'Map 'Tag 'Dynamic
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            {} $ :states $ {}
              :cursor $ []
          :examples $ []
          :schema $ :: 'Map 'Tag 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op op-id op-time)
            match op
              (:states cursor s)
                assoc store :states $ decode-map-as
                  update-state-tree
                    option:unwrap-or (get store :states) ({})
                    , cursor s
                  :: 'Map 'Dynamic 'Dynamic
              (:hydrate-storage data) data
              _ $ do (eprintln |Unknown-op: op) store
          :examples $ []
          :schema $ :: 'Fn $ {}
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'app.schema/Op 'String 'Number
            :return $ :: 'Map 'Tag 'Dynamic
          :tests $ [] $ %{} 'TestEntry (:name |state-path-and-open-store)
            :code $ quote $ let
                initial $ assoc app.schema/store :content |kept
                changed $ updater initial
                  app.schema/Op :states ([] :knowledge-graph)
                    {} $ :selected |quaternions
                  , |state 1
              assert= |kept $ option:unwrap $ get changed :content
              assert=
                {}
                  :cursor $ []
                  :knowledge-graph $ {} $ :data
                    {} $ :selected |quaternions
                option:unwrap $ get changed :states
              assert= initial $ updater changed (app.schema/Op :hydrate-storage initial) |restore 2
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
