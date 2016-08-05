//
//  LGPView.m
//  tableView
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 廖国朋. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#import "LGPShowView.h"
#import <Masonry/Masonry.h>

@interface LGPShowView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIView *showView;
@end

@implementation LGPShowView

+ (LGPShowView *)SharedWindow{
    static LGPShowView *lgpWindow = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lgpWindow = [self new];
    });
    return lgpWindow;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (UIButton *)createButton:(NSString *)setTitle{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:setTitle forState:UIControlStateNormal];//button的按钮文字
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//文字颜色
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//点击时颜色
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];//点击时执行某个函数
    [_showView addSubview:button];
    return button;
}

- (void)buttonClicked:(UIButton *)sen{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(buttonClick:)]) {
        [self.delegate buttonClick:sen];
    }
}

- (void)show{
    if (_showView.alpha!=0) {
        [self dismiss];
        return;
    }
    UIWindow *v =  [UIApplication sharedApplication].windows.firstObject;
//    __weak UIView *selfWeak = self;
    
    [v addSubview:self];
    if (self.format==LGPViewFormatIsBlackBar) {
        [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_but.mas_left).offset(3);
            make.top.equalTo(_but.mas_top);
            make.width.equalTo(@1);
            make.height.equalTo(_but.mas_height);
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@((8.0/15)*SCREEN_WIDTH+30));
            }];
            
            [UIView animateWithDuration:0.3 animations:^{
                [self layoutIfNeeded];
                _showView.alpha = 0.6;
                _but.alpha = 0.7;
                
            } completion:^(BOOL finished) {
                
                [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@((8.0/15)*SCREEN_WIDTH-10));
                }];
                [UIView animateWithDuration:0.1 animations:^{
                    _showView.layer.cornerRadius = 10;
                    
                    [v layoutIfNeeded];
                    
                } completion:^(BOOL finished) {
                    
                    [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(@((8.0/15)*SCREEN_WIDTH));
                    }];
                    [UIView animateWithDuration:0.1 animations:^{
                        [v layoutIfNeeded];
                        _showView.layer.cornerRadius = 5;
                    } completion:^(BOOL finished) {
                    }];
                }];
            }];
            
        });

    }else{
        [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.left.bottom.equalTo(self);
            make.height.equalTo(@(1));
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@((self.buttonTitles.count+1)*44+5));
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                [v layoutIfNeeded];
                _showView.alpha = 1;
            }];
        });

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    UIView *hitView = [super hitTest:point withEvent:event];

    UIView *v =  [UIApplication sharedApplication].windows.firstObject;
    CGRect rect = [_but.superview convertRect:_but.frame toView:v];

    if (CGRectContainsPoint(rect, point)) {
        return _but;
    }
    if (hitView!=self) {
        return hitView;
    }else{
        [self dismiss];
        return nil;
    }
}

- (void)didMoveToWindow{

    if (!self.showView) {
        self.showView = [UIView new];
        _showView.backgroundColor = [UIColor blackColor];
        _showView.layer.masksToBounds = YES;
        _showView.alpha = 0;
        
        [self addSubview:_showView];
        if (self.format==LGPViewFormatIsBlackBar) {
            _showView.layer.cornerRadius = 5;

            UIButton *but;
            for (int i = 0; i<self.buttonTitles.count; i++) {
                UIButton *butO = [self createButton:self.buttonTitles[i]];
                
                [butO mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(_showView);
                    make.left.equalTo(but?but.mas_right:_showView);
                    make.width.equalTo(_showView).multipliedBy((1-0.01*(self.buttonTitles.count-1))/self.buttonTitles.count);
                }];
                
                if ((i<self.buttonTitles.count-1)) {
                    UILabel *imL = [[UILabel alloc]init];
                    imL.text = @"|";
//                    imL.font = [UIFont systemFontOfSize:20];
                    imL.contentMode = UIViewContentModeScaleToFill;
                    [_showView addSubview:imL];
                    [imL mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(_showView).offset(2);
                        make.bottom.equalTo(_showView).offset(-2);
                        make.width.equalTo(_showView).multipliedBy(0.01);
                        make.left.equalTo(butO.mas_right);
                    }];
                }
                
                but = butO;
            }
            
            [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_but.mas_left).offset(3);
                make.top.equalTo(_but.mas_top);
                make.width.equalTo(@1);
                make.height.equalTo(_but.mas_height);
            }];
        }else{
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
//            tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
            [self.showView addSubview:tableView];
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.top.bottom.equalTo(self.showView);
            }];
            
            [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.bottom.equalTo(self);
                make.height.equalTo(@(1));
            }];
        }

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return 5.0;
    }else
        return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = nil;
    if (section==1) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        view.backgroundColor = [UIColor grayColor];
    }
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.buttonTitles.count) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return self.buttonTitles.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = self.buttonTitles[indexPath.row];
    if (indexPath.section==1) {
        cell.textLabel.text = @"取消";
    }else
        cell.textLabel.text = self.buttonTitles[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
        [self dismiss];
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:cell.textLabel.text forState:UIControlStateNormal];
    [self buttonClicked:button];
    [self dismiss];
}

- (void)dismiss{
    __weak UIView *selfWeak = self;
    UIView *v =  [UIApplication sharedApplication].windows.firstObject;
    if (self.format==LGPViewFormatIsBlackBar) {
        [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@1);
        }];
        [UIView animateWithDuration:0.1 animations:^{
            [v layoutIfNeeded];
            _showView.alpha = 0;
            _but.alpha = 1;
            
        } completion:^(BOOL finished) {
            [selfWeak removeFromSuperview];
        }];
    }else{
        [_showView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
        }];
        [UIView animateWithDuration:0.1 animations:^{
            _showView.alpha = 0;
            [v layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [selfWeak removeFromSuperview];
        }];
    }

}

@end
