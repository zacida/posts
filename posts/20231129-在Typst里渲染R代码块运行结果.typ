#set page(width: 10cm, height: auto)
#set heading(numbering: "1.")

= Typst是什么
Typst是一个文档排版工具，包含一种标记语言，一个编译工具，还有正在快速发展的生态。Typst语言有一套有趣的语法，相对Tex语言来说可以更加简洁明了地表达大部分文档排版的需求。

= 为什么要在Typst里渲染R代码块的运行结果？
主要是期望在Typst中也能做到文学编程。而R语言又常常是文学编程中“编程"的那一部分。

= 现阶段的问题
通过使用knitr, 现在其实已经可以比较好地渲染文本类输出了。主要是图片信息显示格式错误。而这个错误又是因为knitr官方在当前时间点（2023年11月）并不支持typ文件的织入，只不过typ文件的代码块语法和md文件类似，而knitr在fallback情况下又是使用md语法去抓取代码块和织入结果，所以造成了”只有文本输出正常，图片输出有bug“的错觉——人家本就完全不支持。\
相关issue: \
https://github.com/typst/typst/issues/1978 \
https://github.com/yihui/knitr/issues/2283


= 如何做？
然而，knitr是一个相当自由的工具，在其工作流的前前后后，都有丰富的hook可供使用。对于我们的问题来说，我们只需要把图片输出修好，就可以完成临门一脚，使其凑凑活活达成我们的目标。
这里，我编写了一个plot函数的hook，只要把这段代码放在typ文档的最前面（当然，这段代码本身只需要被执行而不需要被渲染），就可以使后续文章中所有R代码输出的图片都会被knitr正确地以typst的格式织入。
```R
# this chunk should be at the beginning of your paper. chunk option should be {r, echo=FALSE}
local({
hook_old <- knitr::knit_hooks$get("plot")

knitr::knit_hooks$set(plot = function(x, options) {
  #print(options)
  image_path <- paste(options$fig.path, options$label, '-', options$fig.cur, '.', options$fig.ext, sep="")
  image_caption <- options$fig.cap
  result_string <- sprintf("#figure(\n  image(\"%s\", width:%s),\n  caption: [%s],\n)",image_path, options$out.width, image_caption)
})
})
```
我这里只是用来验证想法，写的很简陋，图像控制的参数我只传了caption 和 width。但是可能性是无限大的，你想要什么自己手动添加参数就好了。

实际的工作流稍显麻烦，但至少能用了：
1. 写typ文件（我们就叫这个文件feed-me-to-knitr.typ吧），记得把上述代码加到开头
2. R会话里运行命令 `knit("feed-me-to-knitr.typ", "feed-me-to-typst.typ")`
3. 命令行运行`typst compile "feed-me-to-typst.typ" final.pdf`，得到最终的pdf文件
上述提到的这些示例文件可以在这里下载到：
#link("https://github.com/yihui/knitr/files/13463399/typst-r.zip")

