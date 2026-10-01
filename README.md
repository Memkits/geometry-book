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

calcit calcit.cirru js
yarn dev
```

Use Calcit/procs 0.27.0, Caps 0.1.1 and Node.js 24. Canonical source/dependencies
are `calcit.cirru` and `deps.cirru`; compact/package snapshots are retired.
Edit source through the Calcit CLI. Run `calcit calcit.cirru js --watch` for
ongoing Calcit development alongside Vite.

To build:

```bash
yarn build
http-server dist/
```

### Deployment

Frontend builds use `VITE_BASE_URL`: main assets at
`https://cos-sh.tiye.me/Memkits/geometry-book/`, PR previews at
`https://cos-sh.tiye.me/Memkits/geometry-book/pr/<number>/<run-id>/`.
COS action v1.1.1 uploads and verifies through `public-base-url`; no extra upload
validation script is used. Production uploads are serialized and the original
server deployment source/destination are unchanged.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

### License

MIT
