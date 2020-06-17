# LyTex-Portable

原作地址：[Google Code](https://code.google.com/archive/p/lytex/) 

原作发布在：[LyTeX绿色套装](http://bbs.ctex.org/forum.php?mod=viewthread&tid=46857)

原作者很久很久都没有更新了，我当年（2015）写研究生毕业论文就用的这个，相对于其他的LaTeX安装方法，这个够简单实用的，推荐入门的同学使用。

我做的改动：更新LyX至2.3.5，MikTex至2.9.7，TeXWorks至0.6.2

![](http://upload-images.jianshu.io/upload_images/3071283-d053fe6a79e55125.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

简单测试了一下，没发现什么问题，欢迎测试反馈！

[Release打包在度盘](https://pan.baidu.com/s/1c37Tgf2)

![LyX简介](http://upload-images.jianshu.io/upload_images/3071283-b99659b06ac683f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

分享记录一个LaTeX的学习网站：[LaTeX Studio](http://wenda.latexstudio.net/)

#####补充两条有参考价值的LyX中文笔记：

[在 LyX 中使用中文 - Yihui Xie | 谢益辉](https://yihui.name/cn/2011/05/write-chinese-in-lyx/)

[LaTeX中文排版（使用XeTeX）](http://linux-wiki.cn/wiki/zh-hans/LaTeX中文排版（使用XeTeX）)

#### 更新备忘

[MiKTeX](https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/win32/miktex/setup/windows-x86/)清华源，下载`miktex-portable.exe`

运行lytex.bat ... 
提示`Extract failed! Manually operate，then press any key to continue...`
7Zip无法解压`miktex-portable.exe`，需要手动操作，直接运行释放到`source\LyTeX\MiKTeX`下，将`texmfs`下除了`install`目录外其它的删掉，把`install`下的所有放上级目录`texmfs`中，删除`install`目录, `then press any key to continue...`
