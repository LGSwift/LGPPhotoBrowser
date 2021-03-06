//
//  SDPhotoBrowserConfig.h
//  SDPhotoBrowser
//
//  Created by aier on 15-2-9.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


typedef enum {
    SDWaitingViewModeLoopDiagram, // 环形
    SDWaitingViewModePieDiagram // 饼型
} SDWaitingViewMode;

#define WeakObj(o) __weak typeof(o) o##Weak = o;
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

// 图片保存成功提示文字
#define SDPhotoBrowserSaveImageSuccessText @" ^_^ 保存成功 ";

// 图片保存失败提示文字
#define SDPhotoBrowserSaveImageFailText @" >_< 保存失败 ";

// browser背景颜色
#define SDPhotoBrowserBackgrounColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95]

// browser中图片间的margin
#define SDPhotoBrowserImageViewMargin 10

// browser中显示图片动画时长
#define SDPhotoBrowserShowImageAnimationDuration 0.4f

// browser中显示图片动画时长
#define SDPhotoBrowserHideImageAnimationDuration 0.4f

// 图片下载进度指示进度显示样式（SDWaitingViewModeLoopDiagram 环形，SDWaitingViewModePieDiagram 饼型）
#define SDWaitingViewProgressMode SDWaitingViewModePieDiagram

// 图片下载进度指示器背景色
#define SDWaitingViewBackgroundColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
//头视图背景
#define LGPHeadViewBackgroundColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7]

//脚视图背景颜色
#define LGPFootViewBackgroundColor [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5]

#define LGPPromptString @"已回到第一张";


// 图片下载进度指示器内部控件间的间距
#define SDWaitingViewItemMargin 10


