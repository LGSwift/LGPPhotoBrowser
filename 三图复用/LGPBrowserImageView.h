//
//  LGPBrowserImageView.h
//  三图复用
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 廖国朋. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SDWaitingView.h"
@class SDPhotoBrowser;

@interface LGPBrowserImageView : UIImageView <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, readonly) BOOL isScaled;
@property (nonatomic, assign) BOOL hasLoadedImage;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)CGFloat totalScale;
@property (nonatomic,weak)UIScrollView *scrollView;
@property (nonatomic, strong)UIImageView *zoomingImageView;



- (void)eliminateScale;//清除缩放

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;

- (void)doubleTapToZommWithScale:(CGFloat)scale;

- (void)clear;

//旋转后调用这个方法可以拿到旋转图片
- (UIImage *)CircleImage;

@end
