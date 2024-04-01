---
title: 在2023年用Typst写博客
date: 2023-11-24
---

## Typst是什么
Typst是一个文档排版工具，包含一种标记语言，一个编译工具，还有正在快速发展的生态。Typst语言有一套有趣的语法，相对Tex语言来说可以更加简洁明了地表达大部分文档排版的需求。

## 用Typst写博客有哪些困难
Typst官方将取代Tex做为主要目标，所以将Typst文件渲染为pdf之外的格式对他们来说并不是非常重要。在2023年11月这个时间点上，Typst官方支持的输出格式仅有pdf。导出为HTML文件的功能正在开发，但具体几时完成仍未可知。

尽管如此，我们仍然可以尝试使用Typst做一些写论文以外的事情，比如用Typst写博客。感谢pandoc和Typst.ts，上述提到的输出格式的问题可以被绕过去了。总的来说，用Typst写博客现在并不会太麻烦，本文接下来就将展示使用Typst写博客的三种办法。

## 使用Pandoc将typ文件转换为html
核心命令如下，可以将typ文件转换为html文件。
```shell
pandoc -o "dist/$test.html" "test.typ" -s --mathml
```
这之后就容易了，只是要想办法把渲染好的html链接到你的主页里（index.html）。我这里写了一个最简单的github pages，#link("https://github.com/ziyuanding/ziyuanding.github.io/releases/tag/demo_write_blog_in_typst")[
  源码在这里
]。
没有用框架，主要的内容都在`.github\workflows\mybuild.yml`里。

如果你使用的是Hexo或Jekyll等流行的静态站点生成器，那可能就比较麻烦，我觉得你要么修改github action，想办法把typ转换得到的html塞到正常markdown渲染得到的html里；要么，就得去看一下这些站点生成器的插件系统，一般来说markdown到html这个流程也是通过markdown渲染插件实现的，我觉得应该也可以写一个typst渲染插件，然后这个插件里面调用pandoc之类的东西，这样会更有意思一点，推广起来很容易，大家接受度高。

## 使用Typst.ts将typ文件渲染为svg
#link("https://github.com/Myriad-Dreamin/typst.ts")[Typst.ts] 是可以在浏览器里运行的Typst实现，对我们来说，它的主要功能就是可以把typ文件渲染成svg。它提供了一个`all-in-one.bundle.js`，可以很方便地嵌入到你自己的网页里。

然后它是动态的，应该是每次打开一个博文页面的时候：
1. 从url里拿到typ文件地址
2. 读取这个文件到js对象
3. 交给typst.ts即时渲染成svg，展示到页面上。
我能想到的主要问题是。。这个可能不是很适合SEO，毕竟每个svg里每个文字都是一个需要查表的对象。。不过人家开发这个项目可能也没想着让我们写博客。用来做preview或者写电子书是挺好的（事实上也确实是这么做的）。

## 等Typst官方实现
啊，这也算吗？算吧，怎么不算呢，这有个#link("https://github.com/typst/typst/issues/721")[issue]慢慢等吧。