//
//  LGPPhotoBrowser.m
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


#import "LGPPhotoBrowser.h"
#import "LGPBrowserImageView.h"
#import "SDPhotoBrowserConfig.h"


@interface LGPPhotoBrowser ()<UIScrollViewDelegate,ButtonClickDelegate>

@property (nonatomic,strong)LGPBrowserImageView *leftView;
@property (nonatomic,strong)LGPBrowserImageView *rightView;
@property (nonatomic,strong)LGPBrowserImageView *currentView;

@property (nonatomic,assign)NSInteger rightLine;
@property (nonatomic,assign)NSInteger leftLine;

@property (nonatomic,assign)NSInteger rightIndex;
@property (nonatomic,assign)NSInteger leftIndex;
@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UILabel *indexLabel;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong)UIView *headView;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UIView *footView;

@property (nonatomic,assign)BOOL pageWillDisappear;

@end
@implementation LGPPhotoBrowser

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,WIDTH, HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = SDPhotoBrowserBackgrounColor;
    _scrollView.backgroundColor = SDPhotoBrowserBackgrounColor;

    [self addSubview:_scrollView];
    
    _leftView = [[LGPBrowserImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _currentView = [[LGPBrowserImageView alloc]initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    _rightView = [[LGPBrowserImageView alloc]initWithFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT)];
    _leftView.tag = 2001;
    _currentView.tag = 2002;
    _rightView.tag = 2003;
    NSArray *arr = @[_leftView,_currentView,_rightView];
    _currentView.alpha = 0;
    for (LGPBrowserImageView *view in arr) {
        // 单击图片
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClick:)];
        // 双击放大图片
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDoubleTaped:)];
        doubleTap.numberOfTapsRequired = 2;
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [view addGestureRecognizer:singleTap];
        [view addGestureRecognizer:doubleTap];
        [_scrollView addSubview:view];
    }
    [self setHeadView];
    [self setFootView];
    
    _scrollView.pagingEnabled = YES;
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0)];
    _scrollView.delegate = self;
    
    return self;
}


- (void)setHeadView{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    self.headView.backgroundColor = LGPHeadViewBackgroundColor;
    _indexLabel = [[UILabel alloc]init];
    _indexLabel.bounds = CGRectMake(0, 0, 150, 40);
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    _indexLabel.numberOfLines = 0;
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.font = [UIFont boldSystemFontOfSize:15];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 20, 80, 44);
    self.backButtom = button;
    
    UIButton *three = [UIButton buttonWithType:UIButtonTypeCustom];

    [three setTitle:@"···" forState:UIControlStateNormal];
    three.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [three addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
    three.frame = CGRectMake(WIDTH-50, 27, 40, 30);
    three.tag = 1001;
    self.headRightButton = three;
    
    [self.headView addSubview:three];
    [self.headView addSubview:button];
    [self.headView addSubview:_indexLabel];

    [self addSubview:self.headView];

}

- (void)button:(UIButton *)button{
    LGPShowView *showView = [LGPShowView SharedWindow];
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:@[@"保存图片",@"保存旋转状态图片"]];
    if (self.showViewArr.count) {
        [arr addObjectsFromArray:self.showViewArr];
    }
    showView.buttonTitles = arr;
    showView.format=LGPViewFormatIsOptions;
    showView.but = button;
    showView.delegate = self;
    [showView show];
}

- (void)buttonClick:(UIButton *)but{
    NSLog(@"%@",but.titleLabel.text);
    if ([but.titleLabel.text isEqual:@"保存图片"]) {
        [self saveImage:_currentView.image];
    }else if ([but.titleLabel.text isEqual:@"保存旋转状态图片"]){
        [self saveImage:[_currentView CircleImage]];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:but];
    }
}

- (void)setFootView{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0,  HEIGHT, WIDTH, 0)];
    self.footView.backgroundColor = LGPFootViewBackgroundColor;
    
    self.contentLabel = [UILabel new];
    self.contentLabel.frame = CGRectMake(0, 0, WIDTH-10, 0);
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.numberOfLines = 0;
    
    [_footView addSubview:self.contentLabel];
    [self addSubview:_footView];
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    if (self.pageWillDisappear) {
        return;
    }
    
    _scrollView.contentSize = CGSizeMake((_attribute==LGPPhotosIsOneDimensionalArray)&&(_photos.count==1||_photos.count==0)?0:WIDTH*3, 0);
    [_scrollView setContentOffset:CGPointMake(WIDTH, 0)];
    
    if (_attribute==LGPPhotosIsOneDimensionalArray) {
        if (self.line >= _photos.count) {
            self.line = 0;
            NSLog(@"下标错误");
        }
        _currentIndex = self.line;
        if (self.photos.count==1) {
            _indexLabel.text = [NSString stringWithFormat:@"%@",self.titles[0]];
            
        }else{
            if (self.titles.count>0) {
                _indexLabel.text = [NSString stringWithFormat:@"%@\n%ld/%ld", self.titles[0], self.line + 1, self.photos.count];
            }else{
                _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.line + 1, self.photos.count];
            }
            
        }

    }else{
        
        if (self.line >= _photos.count) {
            self.line = 0;
            self.column = 0;
            NSLog(@"下标错误");
        }
        
        NSArray *arr = _photos[self.line];
        if (self.column >= arr.count) {
            self.column = 0;
            NSLog(@"下标错误");
        }
        self.leftLine = self.line;
        self.rightLine = self.line;
        
        _currentIndex = self.column;
        if (arr.count==1) {
            if (self.titles.count>0) {
                _indexLabel.text = [NSString stringWithFormat:@"%@",self.titles[0]];
            }else{
                _indexLabel.text = @"";
            }
        }else{
            if (self.titles.count>0) {
                _indexLabel.text = [NSString stringWithFormat:@"%@\n%ld/%ld", self.titles[(self.line<arr.count)?self.line:0],self.column + 1, arr.count];
            }else{
                _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.column + 1, arr.count];
            }
            
        }
    }

    if (!self.contents||[self.contents[self.line] isEqualToString:@""]) {
        [self.footView setFrame:CGRectMake(0, HEIGHT, WIDTH, 0)];
        _contentLabel.text = @"";
    }else{
        CGSize labelsize = [self labelString:self.contents[(self.line<self.photos.count)?self.line:0]];
        [_footView setFrame:CGRectMake(0, HEIGHT-labelsize.height-15, WIDTH, labelsize.height+20)];
        [_contentLabel setFrame:CGRectMake(5, 0, WIDTH-10, labelsize.height)];
        _contentLabel.text = self.contents[(self.line<self.photos.count)?self.line:0];
    }
    
    [self hanldeIndexWithCurrentIndex:_currentIndex];

    [_currentView setImageWithURL:(_attribute==LGPPhotosIsOneDimensionalArray)?_photos[_currentIndex]:_photos[_line][_currentIndex] placeholderImage:(_attribute==LGPPhotosIsOneDimensionalArray)?[self gitPlaceholderImage:_currentIndex and:0]:[self gitPlaceholderImage:_line and:_currentIndex]];

    [self setImage];
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 42);
    
    if (self.tagViewImage&&self.tagViewImage.image) {
        UIImageView *image = [[UIImageView alloc]init];
        image.image = self.tagViewImage.image;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        image.contentMode = self.tagViewImage.contentMode;
        [window addSubview:image];
        image.frame = [self.tagViewImage.superview convertRect:self.tagViewImage.frame toView:window];
        CGSize imageSize = self.tagViewImage.image.size;
        [UIView animateWithDuration:SDPhotoBrowserShowImageAnimationDuration animations:^{
            image.center = self.center;
            CGFloat imageViewH = self.bounds.size.width * (imageSize.height / imageSize.width);
            image.bounds = CGRectMake(0, 0, WIDTH, imageViewH);
        }completion:^(BOOL finished) {
            _currentView.alpha = 1;
            [image removeFromSuperview];
        }];
    }else{
        _currentView.alpha = 1;
    }
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView==nil) {
        return self;
    }

    return hitView;
}

- (CGSize)labelString:(NSString *)content{
    if (content==nil) {
        return CGSizeZero;
    }
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:content attributes:@ {NSFontAttributeName: _contentLabel.font}];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(_contentLabel.frame.size.width-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize labelsize = rect.size;
    return labelsize;
    
}

- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (self.headView.frame.origin.y == 0.0) {
            self.headView.frame = CGRectMake(0, -64, WIDTH, 64);
            self.footView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
        }else{
            
            self.headView.frame = CGRectMake(0, 0, WIDTH, 64);
            if (!self.contents || [self.contents[(self.line<self.photos.count)?self.line:0] isEqualToString:@""]) {
                [self.footView setFrame:CGRectMake(0, HEIGHT, WIDTH, 0)];
            }else{
                CGSize labelsize = [self labelString:self.contents[(self.line<self.photos.count)?self.line:0]];
                [_footView setFrame:CGRectMake(0, HEIGHT-labelsize.height-15, WIDTH, labelsize.height+20)];
                [_contentLabel setFrame:CGRectMake(5, 0, WIDTH-10, labelsize.height)];
                _contentLabel.text = self.contents[(self.line<self.photos.count)?self.line:0];
            }
        }
    }];

}


- (void)disMiss{
    WeakObj(self);
    [UIView animateWithDuration:SDPhotoBrowserHideImageAnimationDuration animations:^{

        selfWeak.alpha = 0;

    } completion:^(BOOL finished) {
        self.pageWillDisappear = YES;
        [selfWeak removeFromSuperview];
    }];
}

- (void)imageViewDoubleTaped:(UITapGestureRecognizer *)recognizer
{
    LGPBrowserImageView *imageView = (LGPBrowserImageView *)recognizer.view;
    CGFloat scale;
    if (imageView.isScaled) {
        scale = 1.0;
    } else {
        scale = 2.0;
    }
    
    [imageView doubleTapToZommWithScale:scale];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if(scrollView.contentOffset.x >= WIDTH*2){
        UIView *left = [self viewWithTag:2001];
        UIView *current = [self viewWithTag:2002];
        UIView *right = [self viewWithTag:2003];
        [left setFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT)];
        [current setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [right setFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
        left.tag = 2003;
        current.tag = 2001;
        right.tag = 2002;
        
        _currentIndex++;
        if (_attribute==LGPPhotosIsOneDimensionalArray) {

            if(_currentIndex > (_photos.count - 1)){
                if (self.ifShowPromptview) {
                    [self showPromptView];
                }
                _currentIndex = 0;
            }
            self.line = _currentIndex;
            
        }else{
            NSArray *arr = _photos[_line];
            if (_currentIndex > (arr.count - 1)) {
                
                self.line += 1;
                if (self.line > (_photos.count - 1)) {
                    self.line = 0;
                    if (self.ifShowPromptview) {
                        [self showPromptView];
                    }
                }
                _currentIndex = 0;
            }
            self.column = _currentIndex;
        }
        
    }else if (scrollView.contentOffset.x <= 0){
        
        UIView *left = [self viewWithTag:2001];
        UIView *current = [self viewWithTag:2002];
        UIView *right = [self viewWithTag:2003];
        [left setFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
        [current setFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT)];
        [right setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        left.tag = 2002;
        current.tag = 2003;
        right.tag = 2001;
        
        _currentIndex--;
        if (_attribute==LGPPhotosIsOneDimensionalArray) {

            if(_currentIndex < 0){
                
                _currentIndex = _photos.count - 1;
            }
            self.line = _currentIndex;
        }else{
            if (_currentIndex < 0) {
                self.line -= 1;
                if (self.line < 0) {
                    self.line = _photos.count - 1;
                }
                NSArray *arr = _photos[_line];
                _currentIndex = arr.count-1;
            }
            self.column = _currentIndex;
        }
        
    }
    if (_attribute==LGPPhotosIsOneDimensionalArray) {
        if (self.photos.count==1) {
            
            if (self.titles.count>0) {
                _indexLabel.text = [NSString stringWithFormat:@"%@",self.titles[0]];
            }else{
                _indexLabel.text = @"";
            }
        }else{
            if (self.titles.count>0) {
                _indexLabel.text = [NSString stringWithFormat:@"%@\n%ld/%ld", self.titles[0], self.line + 1, self.photos.count];
            }else{
                _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.line + 1, self.photos.count];
            }
            
        }
    }else{
        NSArray *arr = _photos[self.line];
         if (arr.count==1) {
             if (self.titles.count>0) {
                 _indexLabel.text = [NSString stringWithFormat:@"%@",self.titles[self.line]];
             }else{
                 _indexLabel.text = @"";
             }
         }else
         {
             if (self.titles.count>0) {
                 _indexLabel.text = [NSString stringWithFormat:@"%@\n%ld/%ld",self.titles[self.line], self.column + 1, arr.count];
             }else
                 _indexLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.column + 1, arr.count];
         }
    }
    
    [self hanldeIndexWithCurrentIndex:_currentIndex];
    
    if (self.headView.frame.origin.y == 0.0) {
        if (!self.contents||[self.contents[self.line] isEqualToString:@""]) {
            [self.footView setFrame:CGRectMake(0, HEIGHT, WIDTH, 0)];
            _contentLabel.text = @"";
        }else{
            CGSize labelsize = [self labelString:self.contents[(self.line<self.photos.count)?self.line:0]];
            [_footView setFrame:CGRectMake(0, HEIGHT-labelsize.height-15, WIDTH, labelsize.height+20)];
            [_contentLabel setFrame:CGRectMake(5, 0, WIDTH-10, labelsize.height)];
            _contentLabel.text = self.contents[(self.line<self.photos.count)?self.line:0];
        }
    }

    
    [self setImage];
    
    [scrollView setContentOffset:CGPointMake(WIDTH, 0) animated:NO];
}

- (void)setImage{
    _currentView = [self viewWithTag:2002];
    _leftView    = [self viewWithTag:2001];
    _rightView   = [self viewWithTag:2003];
    
    [_rightView clear];
    [_leftView clear];
    
    UIView *view = [_currentView viewWithTag:1008];
    [view removeFromSuperview];
    
    [_leftView setImageWithURL:(_attribute==LGPPhotosIsOneDimensionalArray)?_photos[_leftIndex]:_photos[_leftLine][_leftIndex] placeholderImage:(_attribute==LGPPhotosIsOneDimensionalArray)?[self gitPlaceholderImage:_leftIndex and:0]:[self gitPlaceholderImage:_leftLine and:_leftIndex]];
    
    [_rightView setImageWithURL:(_attribute==LGPPhotosIsOneDimensionalArray)?_photos[_rightIndex]:_photos[_rightLine][_rightIndex] placeholderImage:(_attribute==LGPPhotosIsOneDimensionalArray)?[self gitPlaceholderImage:_rightIndex and:0]:[self gitPlaceholderImage:_rightLine and:_rightIndex]];

}

- (UIImage *)gitPlaceholderImage:(NSInteger)line and:(NSInteger)index{
    if (self.photoImageDelegate&&[self.photoImageDelegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:line inSection:index];
        UIImage *image = [self.photoImageDelegate photoBrowser:self placeholderImageForIndexPath:indexPath];
        return image;
    }
    return _placeholderImage;
}

- (void)hanldeIndexWithCurrentIndex:(NSInteger)curIndex{
    
    _leftIndex = curIndex - 1;
    _rightIndex = curIndex + 1;
    
    if (_attribute==LGPPhotosIsOneDimensionalArray) {
        self.line = curIndex;
        if(_leftIndex < 0){
            _leftIndex = _photos.count - 1;
        }
        
        if(_rightIndex > _photos.count - 1){
            _rightIndex = 0;
        }
        
    }else{
        self.column = curIndex;
        if(_leftIndex < 0){
            
            self.leftLine = self.line - 1;
            if (self.leftLine < 0) {
                self.leftLine = _photos.count - 1;
            }
            
            NSArray *arr = _photos[self.leftLine];
            _leftIndex = arr.count - 1;
        }else{
            self.leftLine = self.line;
        }
        
        NSArray *arr = _photos[self.line];
        if(_rightIndex > (arr.count - 1)){
            self.rightLine = self.line + 1;
            if (self.rightLine > (_photos.count - 1)) {
                self.rightLine = 0;
            }
            _rightIndex = 0;
        }else{
            self.rightLine = self.line;
        }

    }
    
}
//保存图片操作  调用即可
- (void)saveImage:(UIImage *)saveImage
{
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.center;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    if (_indicatorView&&_indicatorView.isAnimating) {
        return;
    }
    _indicatorView = indicator;
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.90f];
    label.layer.cornerRadius = 5;
    label.clipsToBounds = YES;
    label.bounds = CGRectMake(0, 0, 150, 30);
    label.center = self.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:17];
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:label];
    if (error) {
        label.text = SDPhotoBrowserSaveImageFailText;
    }   else {
        label.text = SDPhotoBrowserSaveImageSuccessText;
    }
    [label performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:1.0];
}

- (void)showPromptView{
    UILabel *prom = [UILabel new];
    prom.text = LGPPromptString;
    prom.textColor = [UIColor whiteColor];
    prom.textAlignment = NSTextAlignmentCenter;
    prom.layer.cornerRadius = 5;//裁成圆角
    prom.layer.masksToBounds = YES;
    prom.bounds = CGRectMake(0, 0, WIDTH-140, 30);
    prom.center = self.center;
    [self addSubview:prom];
    prom.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    //延时执行
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            prom.alpha = 0;
        }completion:^(BOOL finished) {
            [prom removeFromSuperview];
        }];
    });
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

@end
