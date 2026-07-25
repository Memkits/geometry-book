
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `cr query` to inspect and `cr edit`/`cr tree` to modify. Run `cr docs agents --full` first. Manual edits must follow format and schema conventions, then run `cr edit format`.") (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!) (:version |0.0.1)
    :modules $ [] |respo.calcit/ |memof/ |respo-ui.calcit/ |reel.calcit/ |respo-markdown.calcit/
  :entries $ {}
  :files $ {}
    |app.comp.container $ %{} :FileEntry
      :defs $ {}
        |card-queue $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn card-queue (node blueprint)
              if (some? blueprint)
                let
                    queue $ or (:queue blueprint) ([])
                  if (empty? queue)
                    [] $ {}
                      :id $ str (:id blueprint) |-article
                      :title $ :title blueprint
                      :tags $ or (:tags blueprint) (#{})
                      :links $ or (:links blueprint) ([])
                      :content $ :content blueprint
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
                      :history $ take-last
                        conj
                          filter visit-history $ fn (id) (not= id selected-id)
                          , selected-id
                        , 12
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
                            comp-md-block (:content section) ({})
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
          :examples $ []
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
        |kind-label $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defn kind-label (kind)
              case-default kind "|知识节点" (:concept "|核心概念") (:theorem "|定理与公式") (:person "|历史人物") (:operation "|代数运算") (:principle "|基本原理") (:structure "|数学结构") (:representation "|几何表示") (:application "|现实应用")
          :examples $ []
        |knowledge-bundle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            def knowledge-bundle $ load-knowledge-docs
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
              |& $ {} (:max-width |1180px) (:margin |0) (:padding "|8px 0 22px") (:border-bottom "|2px solid #161616")
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
              |& $ {} (:width |100%) (:min-height |40px) (:padding "|9px 11px") (:border "|1px solid #c6c6c6") (:border-radius |2px) (:background |#ffffff) (:color |#393939) (:font-size |14px) (:font-weight |600) (:text-align |left) (:cursor |pointer)
              |&:hover $ {} (:border-color |#0f62fe) (:background |#f4f7ff)
          :examples $ []
        |style-reader-left $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-left $ {}
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|18px 14px 28px") (:background |#f2f4f6) (:overflow-y |auto) (:border-right "|1px solid #8d8d8d") (:box-shadow "|3px 0 0 rgba(22,22,22,.05)")
          :examples $ []
        |style-reader-meta $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-meta $ {}
              |& $ {} (:font-size |13px) (:font-weight |720) (:letter-spacing |0.08em) (:color |#5b77a1)
          :examples $ []
        |style-reader-middle $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-middle $ {}
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|24px clamp(22px, 2.5vw, 46px) 52px") (:background |#ffffff) (:overflow-y |auto)
          :examples $ []
        |style-reader-nav-button $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-nav-button $ {}
              |& $ {} (:width |100%) (:min-height |44px) (:padding "|10px 12px") (:border "|1px solid #a8a8a8") (:border-left "|4px solid #525252") (:border-radius |2px) (:background |#ffffff) (:box-shadow "|2px 2px 0 rgba(22,22,22,.08)") (:color |#262626) (:font-size |15px) (:font-weight |650) (:text-align |left) (:cursor |pointer) (:transition "|border-color 140ms ease, box-shadow 140ms ease, transform 140ms ease")
              |&:hover $ {} (:border-color |#0f62fe) (:box-shadow "|3px 3px 0 rgba(15,98,254,.14)") (:transform "|translateX(2px)")
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
        |style-reader-page $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-page $ {}
              |& $ {} (:position |fixed) (:inset 0) (:display |grid) (:grid-template-columns "|272px minmax(680px, 1fr) minmax(340px, 410px)") (:background |#dfe3e8) (:font-family "|Inter, IBM Plex Sans, Segoe UI, -apple-system, sans-serif") (:color |#161616) (:overflow |hidden)
          :examples $ []
        |style-reader-related-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-related-card $ {}
              |& $ {} (:padding "|16px 16px 18px") (:border "|1px solid #a8a8a8") (:border-top "|3px solid #525252") (:border-radius |2px) (:background |#ffffff) (:box-shadow "|2px 2px 0 rgba(22,22,22,.09)") (:text-align |left) (:cursor |pointer) (:transition "|border-color 140ms ease, box-shadow 140ms ease, transform 140ms ease, background-color 140ms ease")
              |&:hover $ {} (:border-color |#0f62fe) (:border-top-color |#0f62fe) (:background |#f4f7ff) (:box-shadow "|3px 3px 0 rgba(15,98,254,.18)") (:transform "|translateX(-2px)")
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
              |& $ {} (:display |flex) (:flex-direction |column) (:gap |4px) (:width |100%) (:padding "|11px 12px") (:border "|1px solid #a8a8a8") (:border-left "|4px solid #78a9ff") (:border-radius |2px) (:background |#ffffff) (:box-shadow "|2px 2px 0 rgba(22,22,22,.07)") (:text-align |left) (:cursor |pointer) (:transition "|border-color 140ms ease, transform 140ms ease, box-shadow 140ms ease")
              |&:hover $ {} (:border-color |#0f62fe) (:transform "|translateX(2px)") (:box-shadow "|3px 3px 0 rgba(15,98,254,.13)")
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
              |& $ {} (:height |100vh) (:box-sizing |border-box) (:padding "|24px 18px 42px") (:background |#f7f7f7) (:border-left "|1px solid #8d8d8d") (:box-shadow "|-3px 0 0 rgba(22,22,22,.04)") (:overflow-y |auto)
          :examples $ []
        |style-reader-section-active $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-active $ {}
              |& $ {} (:border-color |#0f62fe) (:border-left-color |#0f62fe) (:background |#f4f7ff) (:box-shadow "|4px 5px 0 rgba(15,98,254,.20), 0 12px 28px rgba(22,22,22,.08)") (:transform "|translateX(3px)")
          :examples $ []
        |style-reader-section-card $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-card $ {}
              |& $ {} (:width |100%) (:box-sizing |border-box) (:padding "|24px 28px 28px") (:border "|1px solid #a8a8a8") (:border-left "|5px solid #525252") (:border-radius |2px) (:background |#ffffff) (:box-shadow "|2px 3px 0 rgba(22,22,22,.10), 0 8px 22px rgba(22,22,22,.055)") (:text-align |left) (:color |#161616) (:cursor |pointer) (:transition "|border-color 140ms ease, box-shadow 140ms ease, transform 140ms ease, background-color 140ms ease")
              |&:hover $ {} (:border-color |#0f62fe) (:border-left-color |#0f62fe) (:transform "|translateX(2px)") (:box-shadow "|3px 4px 0 rgba(15,98,254,.15), 0 10px 24px rgba(22,22,22,.08)")
          :examples $ []
        |style-reader-section-grid $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-grid $ {}
              |& $ {} (:max-width |1180px) (:margin "|18px 0 0") (:display |flex) (:flex-direction |column) (:gap |12px) (:padding-bottom |24px)
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
        |style-reader-section-title $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-section-title $ {}
              |& $ {} (:margin-top |11px) (:font-size |25px) (:font-weight |750) (:letter-spacing |-0.02em) (:line-height |1.3)
          :examples $ []
        |style-reader-tag $ %{} :CodeEntry (:doc |) (:schema :dynamic)
          :code $ quote
            defstyle style-reader-tag $ {}
              |& $ {} (:padding "|4px 7px") (:border-radius |2px) (:background |#e8edf3) (:border "|1px solid #d1d9e2") (:color |#31547d) (:font-size |12px) (:font-weight |620)
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
            respo.core :refer $ defcomp <> >> div button span list->
            reel.comp.reel :refer $ comp-reel
            app.config :refer $ dev?
            respo-md.comp.md :refer $ comp-md-block
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
