## Geometry Book

> Geometry knowledge pages and an interactive concept network built with Calcit and Respo.

Demo https://cos-sh.tiye.me/Memkits/geometry-book/ .

### Usages

To develop:

```bash
corepack enable && corepack prepare yarn@4.18.0 --activate
caps --ci
yarn install --immutable
caps verify --toolchain

yarn dev
```

Use paired formal Calcit CLI/procs 0.41.1, Caps 0.1.1 and Node.js 24. Canonical source/dependencies
are `calcit.cirru` and `deps.cirru`; compact/package snapshots are retired.
Edit source through the Calcit CLI. `yarn dev` compiles initially and starts Vite;
run `calcit calcit.cirru --watch` in another terminal for live Calcit edits.
`yarn build` compiles the default JS browser entry and builds once.

### 迁移状态

已配对正式 CLI/procs 0.41.1、Caps 0.1.1 与 Node 24，七个已发布模块通过 `caps --strict`。阅读器事件携带具名 `ReaderState`，状态路径使用 `CoordKey`，应用派发使用具名 `Op`，Reel 0.11.0 的面板和快捷键使用独立 `Control` 回调。知识网络以具名节点和边区分各自字段，在 Cytoscape 入口转成原有图数据。 Markdown 校验在编译阶段保留具名诊断，详情按引用目标字符串或关系对象区分。Markdown、存档格式和逐记录校验沿用。0.41.1 使用现行报告限制逐定义弱类型和覆盖率。

To build:

```bash
yarn build
http-server dist/
```

### Deployment

Frontend builds use `VITE_BASE_URL`: main assets at
`https://cos-sh.tiye.me/Memkits/geometry-book/`, PR previews at
`https://cos-sh.tiye.me/Memkits/geometry-book/pr/<number>/<run-id>/<attempt>/`.
Released COS action v1.2.0 validates HTML references and publicly verifies uploads
through `public-base-url`; no extra upload validation script is used. Runs queue
per PR and separately for production, without cancellation; the original
server deployment source/destination are unchanged.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
