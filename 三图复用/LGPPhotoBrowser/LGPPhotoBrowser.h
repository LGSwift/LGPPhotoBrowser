//
//  LGPPhotoBrowser.h
//  三图复用
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使此库的过程中如果出现bug请及时以以下任意一种方式联系我，我会及时修复bug。欢迎联系我跟我一起学习  :-D*
 *                                                                     *
 * 持续更新地址: https://github.com/LiaoGuopeng/LGPPhotoBrowser                              *
 * QQ : 756581014
 *
 * Email : 756581014@qq.com                                                          *
 * GitHub: https://github.com/LiaoGuopeng                                              *                                                                *
 *                                                                                *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "LGPShowView.h"


typedef enum {
    LGPPhotosIsOneDimensionalArray, //默认
    LGPPhotosIsTwoDimensionalArray // 为二维数组
} LGPPhotosAttribute;

@class LGPPhotoBrowser;

@protocol LGPPhotoBrowserDelegate <NSObject>

- (UIImage *)photoBrowser:(LGPPhotoBrowser *)browser placeholderImageForIndexPath:(NSIndexPath *)indexPath;

@end


@interface LGPPhotoBrowser : UIView

@property (nonatomic,weak)UIImageView *tagViewImage;//点击的图片，如果你需要一个放大的过度动画则赋值

@property (nonatomic,weak)UIImage *placeholderImage;//占位图
@property (nonatomic,strong)NSArray *photos;//图片URL 可传二维数组，必须设置下面attribute属性
@property (nonatomic,strong)NSArray *titles;//图片标题，必须和图片数组对应 可以为空
@property (nonatomic,strong)NSArray *contents;//图片正文  可以为空

@property (nonatomic,strong)NSArray *showViewArr;//点击右上角弹出的界面选项
@property (nonatomic,weak)id<ButtonClickDelegate>delegate;//选项界面实在这个代码获取点击的选项

@property (nonatomic,weak)id<LGPPhotoBrowserDelegate>photoImageDelegate;//已经显示了缩略图的需要将缩略图作为占位图时添加这个代理，实现方法，根据下标反馈缩略图

@property (nonatomic,assign)LGPPhotosAttribute attribute;//当图片为二维数组时设置为：LGPPhotosIsTwoDimensionalArray

@property (nonatomic,strong)UIButton *headRightButton;//右上角
@property (nonatomic,strong)UIButton *backButtom;//返回的按钮，可以自定义  如果完全自定义请在点击方法里调用disMiss消失界面
@property (nonatomic)BOOL detectorTypeQRCode; //点击右上角是否检测图片有没有二维码
@property (nonatomic)BOOL ifShowPromptview;//是否显示回到第一张的提示  默认不显示

//一维数组：photos[line]   二维数组： photos[line][column]  就是第一个显示的图片
@property (nonatomic,assign)NSInteger line;
@property (nonatomic,assign)NSInteger column;


- (void)show;//显示

- (void)disMiss;//消失，如果需要手动消失请调用

@end
