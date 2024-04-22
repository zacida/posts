---
title:  有没有必要手动安装CUDA
date: 2024-04-22
---

必须要有的东西是CUDA驱动和CUDA运行时。

CUDA驱动，一般你就正常安装显卡驱动就有，常打游戏的话电脑上应该有一个nVidia experience，这个软件就是更新驱动的。下载最新的就行。新电脑或新装系统会需要更新这个驱动。安装这个驱动会给你`nvidia-smi`这个命令。如果这个命令找不到，那就说明没装驱动。

CUDA运行时，就是下面主要讨论的东西了。

1. 手动安装CUDA和cuDNN（完整）
   
   比较传统的做法。去nVidia官网下载一个可执行安装文件，一路点下一步，等安装完后你就可以有nvcc这种东西了，一般你能找到的教程不是都让你用`nvcc -V`来验证安装是否成功嘛。

   安装的东西是最全的，什么visual studio integration啊、nVidia Experience啦、Nsight啦，一不注意就都装上了。

   切换版本比较麻烦，需要自己写脚本改环境变量（`CUDA_PATH`）
   cuDNN的话，去nVidia官网下载，就是一堆文件，不用“安装”。复制粘贴到CUDA目录里就可以了。

2. 使用PyTorch（不完整）
   
   `PyTorch`是自带CUDA和cuDNN的。只要你有nVidia的显卡以及安装了合适的驱动，直接按照PyTorch官网的命令安装PyTorch，然后你就可以写代码运行程序了。虽然nvcc没有，但是丝毫不影响你跑程序。下面这段测试程序是可以通过的。
   ```python 
    import torch
    print(torch.cuda.is_available()) 
    print(torch.version.cuda)  
    print(torch.__version__) 
    print(torch.cuda.device_count())  
    print(torch.cuda.get_device_name(0))
    print(torch.cuda.current_device()) 
    print(torch.backends.cudnn.version())
    from torch.backends import cudnn
    print(cudnn.is_available())
    a = torch.tensor(1.)
    a.cuda()
    print(cudnn.is_acceptable(a.cuda()))
   ```
   一般是和虚拟环境搭配使用，所以我觉得切换版本也方便。不过既然已经统一为torch实现了，个人认为其实也没什么切换CUDA版本的需求。。


3. 虚拟环境内安装CUDA和CUDNN（不完整）
   ```shell
   conda install cudatoolkit==11.8.0 cudnn==8.9.2.26 -c conda-forge
   # 或者使用nvidia的源。因为有一些版本在conda-forge上没有，需要两个源都搜一下
   conda install cudatoolkit cudnn -c nvidia

   # cudatoolkit还是cuda-toolkit？ 
   # cudatoolkit内容少，cuda-toolkit内容全，cuda内容最全
   # https://stackoverflow.com/questions/76875734/difference-between-nvidia-cuda-toolkit-and-nvidia-cudatoolkit-packages
   ```
   这样安装好后，你的程序使用这个虚拟环境，也能正常运行。一些非pytorch框架实现的模型就可以这么安装依赖。

   同样的，没有nvcc。原理和pytorch差不多，因为只安装了CUDA的最小部分。

4. 虚拟环境内安装CUDA和CUDNN（完整）
   ```shell
   # 这个cuda相当于是一本书的目录，会给你把一堆东西都装上，就像你直接从官网下载安装一样。
   conda install cuda -c conda-forge
   ```
    烦，我现在搞不清nvidia-container的存在意义了。我觉得这个虚拟环境还能装完整版CUDA运行时的做法已经满足需求了。。。


5. nvidia-container-toolkit（完整）
   
   从这里可以知道（https://www.cnblogs.com/renoyuan/p/17809212.html）, nvidia-docker + nvidia-container-runtime 已经过时。直接来看nvidia-container-toolkit。

   我觉得只有在你需要完整CUDA，也就是pytoch自带的CUDA和使用conda安装的CUDA提供不了你需要的东西，比如nvcc时，可以尝试这种。基于容器，可以实现完整CUDA runtime的分离。

先这么写着、、