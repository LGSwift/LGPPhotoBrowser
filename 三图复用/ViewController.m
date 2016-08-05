//
//  ViewController.m
//  三图复用
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 廖国朋. All rights reserved.
//

#import "ViewController.h"
#import <UIImageView+WebCache.h>
#import "LGPPhotoBrowser.h"


@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *ss = @"http://www.dqr2558.com:8080/uploadFiles/10731/ed273a2e8c974c2999dc6dbcc1466b8d.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/1a51e0f91c1a48c0af98c05c5bcf2cf7.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a9054d94fade48348cfb4eb8edae2a50.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/250c6e86df574a2db87e0657ea7b55bd.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/c6ea7338bb5740cfa325ef64f882a8de.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a1526c7cca70432c98627b7fc5b3ef12.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/cde2a17514c44c6482d2271050498a5c.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/99a121d5b1f146128e265f02111819bd.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/f55c0695340d485ba8420f6bcc70340b.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/6e654b2455b142c89e936043d004745a.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/99039fda5b7b45058f704057451155de.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/b3e00acbf2c44a599d5ca97bb997b34c.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a0f60ca49eaa48729eded40794345d10.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/9d65a4bb539f4c118f82c6d4d250dd5b.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/89ab1aee1690419b91ca9a70303478a4.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/aa34d5d46bb745e28b254ff4c554e9c7.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/740d2ab5e7b1433780bd40302c114cfe.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/6dc4726501b64ba4a49578f38c0ddcbb.JPG";
    NSArray *arr = [ss componentsSeparatedByString:@","];
    
    for (int i = 0; i<2; i++) {
        for (int y = 0; y<3; y++) {
            UIImageView *im = [[UIImageView alloc]initWithFrame:CGRectMake(130*y, i>0?160:50, 100, 100)];
            im.userInteractionEnabled = YES;
            im.backgroundColor = [UIColor redColor];
            [self.view addSubview:im];
            im.contentMode = UIViewContentModeScaleAspectFill;
            im.layer.masksToBounds = YES;
            [im sd_setImageWithURL:[NSURL URLWithString:arr[y+i*3]]];
            im.tag = 1000+y+i*3;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoClic:)];
            [im addGestureRecognizer:singleTap];
        }
        
    }
    
}

- (void)photoClic:(UITapGestureRecognizer *)tap{
    NSString *ss = @"http://www.dqr2558.com:8080/uploadFiles/10731/ed273a2e8c974c2999dc6dbcc1466b8d.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/1a51e0f91c1a48c0af98c05c5bcf2cf7.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a9054d94fade48348cfb4eb8edae2a50.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/250c6e86df574a2db87e0657ea7b55bd.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/c6ea7338bb5740cfa325ef64f882a8de.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a1526c7cca70432c98627b7fc5b3ef12.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/cde2a17514c44c6482d2271050498a5c.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/99a121d5b1f146128e265f02111819bd.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/f55c0695340d485ba8420f6bcc70340b.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/6e654b2455b142c89e936043d004745a.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/99039fda5b7b45058f704057451155de.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/b3e00acbf2c44a599d5ca97bb997b34c.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/a0f60ca49eaa48729eded40794345d10.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/9d65a4bb539f4c118f82c6d4d250dd5b.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/89ab1aee1690419b91ca9a70303478a4.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/aa34d5d46bb745e28b254ff4c554e9c7.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/740d2ab5e7b1433780bd40302c114cfe.JPG,http://www.dqr2558.com:8080/uploadFiles/10731/6dc4726501b64ba4a49578f38c0ddcbb.JPG";
    NSArray *arr3 = [ss componentsSeparatedByString:@","];

    LGPPhotoBrowser *phot = [[LGPPhotoBrowser alloc]init];
    phot.photos = arr3;
    phot.tagViewImage = (UIImageView *)tap.view;
    phot.titles = @[@"星期一"];
    phot.line = tap.view.tag-1000;
    [phot.headRightButton setImage:[UIImage imageNamed:@"dian2.png"] forState:UIControlStateNormal];;
    [phot show];

}
//
//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
