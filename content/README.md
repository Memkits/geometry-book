# Knowledge content

每个 Markdown 文件对应一张知识卡片。文件开头使用 Cirru EDN frontmatter：

```cirru
---
{}
  :id |stable-id
  :title |标题
  :kind :topic
  :tags $ #{} |标签一 |标签二
  :links $ [] |related-id
  :queue $ [] |section-id-a |section-id-b
---
```

- `id` 是稳定身份，不使用文件路径代替。
- `tags` 是无序集合，用于检索和弱关联。
- `links` 是显式语义关系。
- `queue` 是有序的小章节序列，通常只用于主题卡片。
- Markdown 正文由 `respo-markdown` 渲染，可使用标题、列表、链接、代码块和数学公式。
