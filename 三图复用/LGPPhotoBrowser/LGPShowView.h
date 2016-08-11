//
//  LGPView.h
//  tableView
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LGPViewFormatIsBlackBar, //默认
    LGPViewFormatIsOptions // 为TableView在下方显示
} LGPViewFormat;

@protocol ButtonClickDelegate<NSObject>
//实现协议
@optional
- (void)buttonClick:(UIButton *)but;
@end


@interface LGPShowView : UIView

@property (nonatomic,weak)UIButton *but;
@property (nonatomic,strong)NSArray *buttonTitles;
@property (nonatomic,assign)LGPViewFormat format;

@property (nonatomic,weak)id<ButtonClickDelegate>delegate;

+ (LGPShowView *)SharedWindow;

- (void)show;
@end
