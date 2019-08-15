# iOS-DAudiobook

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![GitHub last commit](https://img.shields.io/github/last-commit/kevindcw/DNebula.svg)](https://github.com/kevindcw/DProgram_ios/commits/master)
[![GitHub repo size in bytes](https://img.shields.io/github/repo-size/kevindcw/DNebula.svg?colorB=fa5b19)](https://github.com/kevindcw/DNebula)



## 效果图：
目前主要功能就是时间计时或者倒计时，关联笔记加通知栏小组件：

<p align="center">
  <img width="200" src="Screenshots/1.png" hspace="30px" />
  <img width="200" src="Screenshots/2.png" hspace="30px" />
  <img width="200" src="Screenshots/3.png" hspace="30px" />
</p>

<p align="center">
  <img width="200" src="Screenshots/4.png" hspace="30px" />
  <img width="200" src="Screenshots/5.png" hspace="30px" />
  <img width="200" src="Screenshots/6.png" hspace="30px" />
</p>


## 实现视频(文件大，可能要等待5秒)：

[![视频](https://upload-images.jianshu.io/upload_images/3323633-0573f124bb4a5f2a.png)](https://player.youku.com/embed/XNDMxNDczNDAyMA==)





## 界面代码：
1.点击小球时，星云整体上移缩小，卡片视图弹出，要有个渐变的过程（在APP交互中，最好所有动画都是渐进的，因为人的大脑接收信息，会有个预设，如果一个东西凭空出现，或消息，大脑会检索一下，这会让大脑不太舒服）
![](https://upload-images.jianshu.io/upload_images/3323633-ab87c13d253c6294.png)




##关键代码
根本代码用到了变换矩阵的运算，参考了大神DBSphereTagCloud里面的算法

我们按照需要展示的子视图个数沿着z轴将球体等分成相应份数，然后按照一个常数angle角度来做旋转，构造一个沿着球面的螺旋,在空间中构建一个球形，并将子视图均匀的分布在球面上,球滚动时，球面坐标的计算。

1.首先定义行、列和二维数组,存储行列信息

![](https://upload-images.jianshu.io/upload_images/3323633-c71a0bb63929eb68.png)

2.根据方向和角度调整矩阵

![](https://upload-images.jianshu.io/upload_images/3323633-9b7ce70bafd70778.png)

3.根据传入的数组，随机抛洒

![](https://upload-images.jianshu.io/upload_images/3323633-263d17a39e6194cd.png)

##最后一张图就是通知栏-小组件

切换小组件运行，选第2个就行，至于小组件和APP之间传值直接看代码吧！

![](https://upload-images.jianshu.io/upload_images/3323633-3df2a4aee7318e3e.png)

更多代码大家可以直接下载看，这里就不多介绍了。。。

