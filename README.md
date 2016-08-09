# LGPPhotoBrowser
一个用SDPhotoBrowser改进图片浏览的框架，使用三图复用，适用于大量图片的查看使用。图片支持放大、旋转等。<br>

##使用方法
1：download之后将文件夹LGPPhotoBrowser拖进项目，导入头文件LGPPhotoBrowser.h<br>
2：代码演示
```objective-c
LGPPhotoBrowser *phot = [[LGPPhotoBrowser alloc]init];
phot.photos = arr3;//图片数组url
phot.tagViewImage = (UIImageView *)tap.view;
phot.titles = @[@"星期一"];//标题  可为空
phot.line = tap.view.tag-1000;//表示数组里的第几个
[phot.headRightButton setImage:[UIImage imageNamed:@"dian2.png"] forState:UIControlStateNormal];//设置右上角的图片
[phot show];//显示
```
