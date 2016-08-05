//
//  LGPBrowserImageView.m
//  三图复用
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "LGPBrowserImageView.h"
#import <UIImageView+WebCache.h>
#import "SDPhotoBrowserConfig.h"

@interface LGPBrowserImageView ()
@property (nonatomic,strong)UIRotationGestureRecognizer *rotateRecogniser;
@end
@implementation LGPBrowserImageView
{
    __weak SDWaitingView *_waitingView;
    BOOL _didCheckSize;
    UIScrollView *_scroll;
    UIImageView *_scrollImageView;
    UIScrollView *_zoomingScroolView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
        _totalScale = 1.0;
        
        // 捏合手势缩放图片
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomImage:)];
        pinch.delegate = self;
        [self addGestureRecognizer:pinch];
        
        //旋转
        _rotateRecogniser = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];

        [self addGestureRecognizer:_rotateRecogniser];
        _rotateRecogniser.delegate = self;
    
    }
    return self;
}

// 重绘图片到指定宽度 clip:是否切处过长的边界切成正方形
- (UIImage *)scaleImage:(UIImage *)image newWidth:(CGFloat)iWidth clip:(BOOL)isClip {
    if (image.size.width > iWidth) {
        CGFloat minValue = MIN(image.size.width, image.size.height);
        float scaleFloat = iWidth/minValue;
        CGSize size = CGSizeMake(isClip?iWidth:scaleFloat*image.size.width, isClip?iWidth:scaleFloat*image.size.height);
        
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGAffineTransform transform = CGAffineTransformIdentity;
        
        transform = CGAffineTransformScale(transform, scaleFloat, scaleFloat);
        CGContextConcatCTM(context, transform);
        
        // Draw the image into the transformed context and return the image
        [image drawAtPoint:CGPointMake(0.0f, 0.0f)];
        UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newimg;
    }else{
        
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

- (UIImage *)CircleImage{
    UIImage *image = self.image;
    CIImage *ciImage = [[CIImage alloc]initWithCGImage:image.CGImage];
    UIImage *newImage = nil;
    
    NSLog(@"%f,%f,%f,%f",_zoomingImageView.transform.a,_zoomingImageView.transform.b,_zoomingImageView.transform.c,_zoomingImageView.transform.d);
    
    if (_zoomingImageView.transform.a==0.0&&_zoomingImageView.transform.b>0.0&&_zoomingImageView.transform.c<0.0&&_zoomingImageView.transform.d==0.0) {
        newImage = [UIImage imageWithCIImage:ciImage scale:1 orientation:UIImageOrientationRight];
    }else if(_zoomingImageView.transform.a==0.0&&_zoomingImageView.transform.b<0.0&&_zoomingImageView.transform.c>0.0&&_zoomingImageView.transform.d==0.0){
        
        newImage = [UIImage imageWithCIImage:ciImage scale:1 orientation:UIImageOrientationLeft];
    
    }else if (_zoomingImageView.transform.a<0.0&&_zoomingImageView.transform.b==0.0&&_zoomingImageView.transform.c==0.0&&_zoomingImageView.transform.d<0.0){
        
        newImage = [UIImage imageWithCIImage:ciImage scale:1 orientation:UIImageOrientationDown];
        
    }else{
        return nil;
    }
    newImage = [self scaleImage:newImage newWidth:image.size.width clip:NO];

    return newImage;
    
}

- (BOOL)isScaled
{
    return  1.0 != _totalScale;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waitingView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    CGSize imageSize = self.image.size;
    
    if (self.bounds.size.width * (imageSize.height / imageSize.width) > self.bounds.size.height) {
        if (!_scroll) {
            UIScrollView *scroll = [[UIScrollView alloc] init];
            scroll.backgroundColor = [UIColor whiteColor];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = self.image;
            _scrollImageView = imageView;
            [scroll addSubview:imageView];
            scroll.backgroundColor = SDPhotoBrowserBackgrounColor;
            _scroll = scroll;
            [self addSubview:scroll];
            if (_waitingView) {
                [self bringSubviewToFront:_waitingView];
            }
        }
        _scroll.frame = self.bounds;

        CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);

        _scrollImageView.bounds = CGRectMake(0, 0, _scroll.frame.size.width, imageViewH);
        _scrollImageView.center = CGPointMake(_scroll.frame.size.width * 0.5, _scrollImageView.frame.size.height * 0.5);
        _scroll.contentSize = CGSizeMake(0, _scrollImageView.bounds.size.height);
        
    } else {
        if (_scroll) [_scroll removeFromSuperview]; // 防止旋转时适配的scrollView的影响
    }
    
}

#define mark 旋转效果
- (void)handleRotate:(UIRotationGestureRecognizer*)recogniser {
    
    if(_scrollView){
        _scrollView.scrollEnabled = NO;
    }
    [self prepareForImageViewScaling];
    _zoomingImageView.transform = CGAffineTransformRotate(_zoomingImageView.transform, recogniser.rotation);
    
    if (recogniser.state==UIGestureRecognizerStateEnded) {

        WeakObj(self);
        if (self.totalScale>1.0?(fabs(_zoomingImageView.transform.b))<=(0.5*self.totalScale):fabs(_zoomingImageView.transform.b)<=0.5) {

            [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
                if (_zoomingImageView.transform.a>0) {
                    _zoomingImageView.transform = CGAffineTransformMake(1, 0, 0, 1, 0, 0);
                }else
                    _zoomingImageView.transform = CGAffineTransformMake(-1, 0, 0, -1, 0, 0);
                [selfWeak eliminateScale];

            }];
        }
        else if (self.totalScale>1.0?(fabs(_zoomingImageView.transform.b))>(0.5*self.totalScale):fabs(_zoomingImageView.transform.b)>0.5){
            
            [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{

                if (_zoomingImageView.transform.b > 0) {
                    _zoomingImageView.transform = CGAffineTransformMake(0, 1, -1, 0, 0, 0);
                }else
                    _zoomingImageView.transform = CGAffineTransformMake(0, -1, 1, 0, 0, 0);
                
                [selfWeak eliminateScale];

            }];
        }

    
    }
    if(_scrollView){
        _scrollView.scrollEnabled = YES;
    }
    recogniser.rotation = 0;
}


- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    _waitingView.progress = progress;

}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWaitingView *waiting = [[SDWaitingView alloc] init];
    waiting.bounds = CGRectMake(0, 0, 100, 100);
    waiting.mode = SDWaitingViewProgressMode;
    _waitingView = waiting;
    [self addSubview:waiting];
    
    
    __weak LGPBrowserImageView *imageViewWeak = self;
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        imageViewWeak.progress = (CGFloat)receivedSize / expectedSize;
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [imageViewWeak removeWaitingView];
        
        
        if (error) {
            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, 160, 30);
            label.center = CGPointMake(imageViewWeak.bounds.size.width * 0.5, imageViewWeak.bounds.size.height * 0.5);
            label.text = @"图片加载失败";
            label.font = [UIFont systemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
            label.layer.cornerRadius = 5;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            [imageViewWeak addSubview:label];
        } else {
            _scrollImageView.image = image;
            [_scrollImageView setNeedsDisplay];
        }
   
    }];
}

- (void)zoomImage:(UIPinchGestureRecognizer *)recognizer
{
    if (_rotateRecogniser&&_rotateRecogniser.state) {
        return;
    }
    [self prepareForImageViewScaling];
    CGFloat scale = recognizer.scale;
    CGFloat temp = _totalScale + (scale - 1);
    [self setTotalScale:temp];
    recognizer.scale = 1.0;
    
}

- (void)setTotalScale:(CGFloat)totalScale
{
    if ((_totalScale < 0.5 && totalScale < _totalScale) || (_totalScale > 2.0 && totalScale > _totalScale)){
        return; // 最大缩放 2倍,最小0.5倍
    }
    
    [self zoomWithScale:totalScale];
}

- (void)zoomWithScale:(CGFloat)scale
{
//    NSLog(@"%f,%f:%f,%f:%f,%f",_zoomingImageView.transform.a,_zoomingImageView.transform.b,_zoomingImageView.transform.c,_zoomingImageView.transform.d,_zoomingImageView.transform.tx,_zoomingImageView.transform.ty);
    
    if (_scrollView) {
        _scrollView.scrollEnabled = NO;
    }
    if (scale==1) {
        [self eliminateScale];

    }else{
        _zoomingImageView.transform = CGAffineTransformScale(_zoomingImageView.transform, (scale-_totalScale)+1, (scale-_totalScale)+1);
    }
    
    _totalScale = scale;
    
    if (scale > 1) {

        CGFloat contentW = (_zoomingImageView.frame.size.width);
        CGFloat contentH = MAX(_zoomingImageView.frame.size.height, self.frame.size.height);
        
        _zoomingImageView.center = CGPointMake(contentW * 0.5, contentH * 0.5);
        _zoomingScroolView.contentSize = CGSizeMake(contentW, contentH);
        
        CGPoint offset = _zoomingScroolView.contentOffset;

        offset.x = (contentW - _zoomingScroolView.frame.size.width) * 0.5;
        
        offset.y = (contentH - _zoomingScroolView.frame.size.height) * 0.5;
        _zoomingScroolView.contentOffset = offset;
        
    } else {
        _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
        _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _zoomingImageView.center = _zoomingScroolView.center;
    }
}



- (void)doubleTapToZommWithScale:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    WeakObj(self);
    [UIView animateWithDuration:0.5 animations:^{
        [selfWeak zoomWithScale:scale];
    }];
}

- (void)prepareForImageViewScaling
{
    if (!_zoomingScroolView) {
        _zoomingScroolView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _zoomingScroolView.backgroundColor = SDPhotoBrowserBackgrounColor;
        _zoomingScroolView.contentSize = self.bounds.size;
        UIImageView *zoomingImageView = [[UIImageView alloc] initWithImage:self.image];
        CGSize imageSize = zoomingImageView.image.size;
        CGFloat imageViewH = self.bounds.size.height;
        if (imageSize.width > 0) {
            imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
        }
        zoomingImageView.bounds = CGRectMake(0, 0, self.bounds.size.width, imageViewH);
        zoomingImageView.center = _zoomingScroolView.center;
        zoomingImageView.contentMode = UIViewContentModeScaleToFill;
        _zoomingImageView = zoomingImageView;
        [_zoomingScroolView addSubview:zoomingImageView];
        [self addSubview:_zoomingScroolView];
    }
}

- (void)scaleImage:(CGFloat)scale
{
    [self prepareForImageViewScaling];
    [self setTotalScale:scale];
}

- (void)eliminateScale
 {
     
     CGFloat fd = 0.0;
     if (_zoomingImageView.frame.size.width>=self.frame.size.width) {
         fd = self.frame.size.width/_zoomingImageView.frame.size.width;
     }else if (_zoomingImageView.frame.size.width<self.frame.size.width){
         fd = self.frame.size.width/_zoomingImageView.frame.size.width;
     }else{
         if (_zoomingImageView.transform.a!=0.0) {
             
             fd = 1.0/fabs(_zoomingImageView.transform.a);
             
         }else{
             
             fd = 1.0/fabs(_zoomingImageView.transform.b);
         }
     }
     
     [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
        _zoomingImageView.transform = CGAffineTransformScale(_zoomingImageView.transform, fd, fd);
     }];

     if (_scrollView) {
         _scrollView.scrollEnabled = YES;
     }
     _totalScale = 1.0;
     _zoomingScroolView.contentSize = _zoomingScroolView.frame.size;
     _zoomingScroolView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
     _zoomingImageView.center = _zoomingScroolView.center;
 }

 - (void)clear
 {
     [self removeWaitingView];
     _zoomingScroolView.hidden = YES;
    [_zoomingScroolView removeFromSuperview];
     _totalScale = 1.0;
     _zoomingScroolView = nil;
     _zoomingImageView = nil;
 }



- (void)removeWaitingView
{
    [_waitingView removeFromSuperview];
}

//多个手势同时执行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
