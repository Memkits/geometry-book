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

Use paired formal Calcit CLI/procs 0.32.1, Caps 0.1.1 and Node.js 24. Canonical source/dependencies
are `calcit.cirru` and `deps.cirru`; compact/package snapshots are retired.
Edit source through the Calcit CLI. `yarn dev` compiles initially and starts Vite;
run `calcit calcit.cirru --watch` in another terminal for live Calcit edits.
`yarn build` compiles the default JS browser entry and builds once.

### 迁移候选状态

此分支尚未完成验收，不能合并部署。已配对正式 CLI/procs 0.32.1、Caps 0.1.1 与 Node 24；Caps 已严格解析七个已发布模块并通过 toolchain 校验，npm 新解析要求至少发布60分钟，immutable 安装通过。

沿用此前已准备的类型迁移与已审阅的六个真实边界：原51篇 Markdown 不变，加载器按记录验证文档和关系；保留缺失 tags 与显式空集合的区别、章节队列与父主题定位。存储 key 仍为 `workflow`；存档类型错误仍暂停自动保存并通过原 `hud!` 展示，前端 COS/rsync 路径保持。

本轮用官方 formatter 迁移42处旧类型表示，两个 Markdown 切片改用明确 Option 终点，dispatch 参数由 Dynamic 收窄为 Enum，并绑定既有 app.schema/Op 类型槽。七个条件子节点改用已发布的 Respo `show`，保留原不显示子节点的语义。原四项业务测试通过；unsafe=0、typeNone=0，schemaDynamic/unresolved各17、typeNotFull15，未提高任何预算。

完整门禁仍有两处阻塞，必须解决后再提交可合并 PR：

- Respo 0.17.1 的 `show` 展开为 nil 分支，Calcit 0.32.1 在动态布尔条件的子节点位置报 `E_IMPLICIT_NIL_BRANCH`，已用公开 API 最小复现反馈至 [Respo #327](https://github.com/Respo/respo.calcit/issues/327)。全定义检查为464通过、1失败、4阻塞；完整 strict 同样失败，不以原测试通过代替。
- 先前候选的质量基线只收紧了全局总量，仍保留旧逐定义余量，0.32.1 明确拒绝总量与逐定义之和不一致。原文件及预算暂未修改；后续应按既有六处授权与实际逐定义证据修复并收紧，不能抬高全局总量放行。

先前 #2199 的 Option-none `.filter` 兼容预处理错误本轮未再出现；新条件渲染阻塞与其不同。浏览器阅读/存档验收尚未在本轮完成，不沿用旧记录声明新版通过。

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
