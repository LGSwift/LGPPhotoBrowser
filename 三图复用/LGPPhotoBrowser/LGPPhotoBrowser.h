//
//  LGPPhotoBrowser.h
//  三图复用
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGPShowView.h"

typedef enum {
    LGPPhotosIsOneDimensionalArray, //默认
    LGPPhotosIsTwoDimensionalArray // 为二维数组
} LGPPhotosAttribute;

@class LGPPhotoBrowser;
@protocol LGPPhotoBrowserDelegate <NSObject>

@optional
- (UIImage *)photoBrowser:(LGPPhotoBrowser *)browser placeholderImageForIndex:(NSIndexPath *)indexPath;

@end


@interface LGPPhotoBrowser : UIView

@property (nonatomic,weak)UIImageView *tagViewImage;//点击的图片，如果你需要一个放大的过度动画则赋值

@property (nonatomic,weak)UIImage *placeholderImage;//占位图
@property (nonatomic,strong)NSArray *photos;//图片URL 可传二维数组，必须设置下面attribute属性
@property (nonatomic,strong)NSArray *titles;//图片标题，必须和图片数组对应 可以为空
@property (nonatomic,strong)NSArray *contents;//图片正文  可以为空

@property (nonatomic,strong)NSArray *showViewArr;//点击右上角弹出的界面选项
@property (nonatomic,weak)id<ButtonClickDelegate>delegate;
@property (nonatomic,weak)id<LGPPhotoBrowserDelegate>photoImageDelegate;//已经显示了缩略图的需要将缩略图作为占位图时添加这个代理，实现方法，根据下标反馈缩略图

@property (nonatomic,assign)LGPPhotosAttribute attribute;//当图片为二维数组时设置为：LGPPhotosIsTwoDimensionalArray

@property (nonatomic,strong)UIButton *headRightButton;//右上角的图片
@property (nonatomic,strong)UIButton *backButtom;//返回的按钮，可以自定义  但是不要重写点击方法

//一维数组：photos[line]   二维数组： photos[line][column]  就是第一个显示的图片
@property (nonatomic,assign)NSInteger line;
@property (nonatomic,assign)NSInteger column;

- (void)show;//显示
@end
