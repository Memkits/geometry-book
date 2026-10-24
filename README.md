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

Use paired formal Calcit CLI/procs 0.30.1, Caps 0.1.1 and Node.js 24. Canonical source/dependencies
are `calcit.cirru` and `deps.cirru`; compact/package snapshots are retired.
Edit source through the Calcit CLI. `yarn dev` compiles initially and starts Vite;
run `calcit calcit.cirru --watch` in another terminal for live Calcit edits.
`yarn build` compiles the default JS browser entry and builds once.

### 迁移候选状态

此分支尚未完成验收，不能按可部署版本使用。现已配对正式 CLI/procs 0.30.1，使用已发布的一致模块图；本地未运行 Caps 或旧 alpha 编译器，CI 独立解析依赖并以 immutable 安装验证锁文件。

原 51 篇 Markdown 不变。加载器一次解码为真实文档/关系记录，保留缺失标签与显式空集合的区别；页面、章节、推荐、时间线及阅读状态使用实际类型，不把 Map 强转成 Struct。章节队列已改为真正解包文档，时间线中的章节会打开其父主题并定位到章节。

存储 key 仍为 `workflow`，原前端 COS/rsync 路径不变。旧 Map 和序列化阅读状态会在恢复边界检查，类型错误会暂停自动保存，避免覆盖原存档；没有放宽原质量基线。

当前完整 strict workflow 在正式 0.30.1 中仍被旧迁移预处理阶段的错误拦截，见上游 calcit-lang/calcit#2199 与修复 #2200。该修复提交并非正式 0.30.1 tag 的祖先；本轮官方 Linux CI 全定义468项通过，但完整 strict 再次报告18条 Option-none `.filter` 错误。普通全定义、独立 proof、原生回归与浏览器验收不能替代该门禁。请勿删除 strict 或 baseline 步骤放行，也不为兼容预检添加假的 lambda hint。构建的大包体积警告保留，不提高阈值掩盖。

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
