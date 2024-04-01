---
title:  无需tex, 将ipynb转换为pdf
date: 2024-04-01
---

```powershell
# 这是一个 PowerShell 脚本，用于将 ipynb 笔记本转换为 PDF，无需安装 TeX。
# 您需要先安装 nbconvert、pandoc 和 typst，才能运行此脚本。
# 我不想安装 TeX，它太大了，至少有1G。

pushd $PSScriptRoot

$filename = "YOUR_IPYNB_FILE_NAME_WITHOUT_EXTENSION"

# 将 .ipynb 文件转换为 .md
# 我删除了所有代码输入（--no-input）并通过添加标签 "remove_output" 删除了一些单元格的输出。
# 你可能需要根据你的需求来修改这个地方，我这样改是因为我想在一个ipynb文件中写完所有的东西，然后从中生成各种格式的交付文件（报告、海报、ppt、甚至视频。。）
jupyter nbconvert --output-dir="out" --to markdown "$filename.ipynb" --no-input --TagRemovePreprocessor.enabled=True --TagRemovePreprocessor.remove_all_outputs_tags remove_output

# 将 .md 文件转换为 .typ
pandoc --from markdown --to typst "out\$filename.md" -o "out\$filename.typ"

# 编译 .typ 文件，最终会得到 pdf 文件
# 点这里查看 typst 是什么 https://github.com/typst/typst
typst compile "out\$filename.typ"

popd
```
