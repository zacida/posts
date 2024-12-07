---
title:  如何关闭SparkMail的更新提示
date: 2024-12-07
---

我常用 Spark Mail，它是一个支持多个邮箱的同步的客户端。但是它更新非常频繁，几乎每两天就会有一个更新，且会弹出一个窗口打断你现在的工作。客户端内并没有开关来控制这个通知的频率，也没有彻底关闭更新的选项。所以我想彻底关闭它。

Spark Mail 是一个Electron应用，找到应用位置后使用asar进行解包：
```shell
npm install -g asar

asar extract app.asar app_unpacked
```

经过在app_unpacked内的一番寻找，发现Spark Mail使用 Sprkle 更新框架。在其配置文件中，有一个appcast URL: https://downloads.sparkmailapp.com/Spark3/win/dist/appcast.xml Spark Mail会在服务端更新这个xml, 而我们本地的客户端会不定时地检查这个xml的内容。到这里就简单了，屏蔽这个地址就可以了。

在 C:\Windows\System32\drivers\etc\hosts 内添加 127.0.0.1 downloads.sparkmailapp.com 即可。