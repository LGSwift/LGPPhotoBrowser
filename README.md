# LGPPhotoBrowser
一个用SDPhotoBrowser改进图片浏览的框架，使用三图复用，适用于大量图片的查看使用。图片支持放大、旋转等。<br>

##Pod支持：

支持pod：  pod 'LGPPhotoBrowser', '~> 0.0.4'



##使用方法
1：download的话将将文件夹LGPPhotoBrowser拖进项目，导入头文件LGPPhotoBrowser.h<br>
2：代码演示
```objective-c
    LGPPhotoBrowser *phot = [[LGPPhotoBrowser alloc]init];
    phot.photos = arr3;
    phot.tagViewImage = (UIImageView *)tap.view;
    phot.titles = @[@"星期一"];
    phot.photoImageDelegate = self;
    phot.line = tap.view.tag-1000;
    [phot.headRightButton setImage:[UIImage imageNamed:@"dian2.png"] forState:UIControlStateNormal];;
    [phot.backButtom setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [phot show];
```
