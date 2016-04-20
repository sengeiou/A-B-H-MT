//
//  FirstLunViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "FirstLunViewController.h"

@interface FirstLunViewController ()

@end

@implementation FirstLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化数据
- (void)initializeMehtod{
    }

#pragma mark *****创建UI
- (void)createUI{
   [self.navigationController setNavigationBarHidden:YES];

    self.automaticallyAdjustsScrollViewInsets = NO;
    for (int i = 0; i < 3; i++) {
        UIImageView *lunView  = [[UIImageView alloc] initWithFrame:CGRectMake(0+MainScreen.size.width*i, 0, MainScreen.size.width, MainScreen.size.height)];
        lunView.image = [UIImage imageNamed:[NSString stringWithFormat:@"new_feature_%d", i + 1]];
        [self.lunScroll addSubview:lunView];
        if (i == 2) {
            lunView.userInteractionEnabled = YES;
            UIButton *experBut = [UIButton buttonWithType:UIButtonTypeCustom];
            experBut.frame = CGRectMake(0, 0, 100, 30);
            [experBut setTitle:MtkLocalizedString(@"first_exper") forState:UIControlStateNormal];
            [experBut addTarget:self action:@selector(experienceClick) forControlEvents:UIControlEventTouchUpInside];
            experBut.layer.borderWidth = 1.0f;
            experBut.layer.masksToBounds = YES;
            experBut.layer.cornerRadius = 5.0;
            experBut.layer.borderColor = [UIColor whiteColor].CGColor;
            experBut.center = CGPointMake(MainScreen.size.width/2, MainScreen.size.height-100);
            [lunView addSubview:experBut];
        }
        NSLog(@"fame==%@ %@",lunView,self.lunScroll);
    }
    self.lunScroll.contentSize = CGSizeMake(MainScreen.size.width*3, MainScreen.size.height-20);
    self.lunScroll.pagingEnabled = YES;
    self.lunScroll.showsHorizontalScrollIndicator = NO;
    self.lunScroll.bounces = NO;
    UIView *v = [[UIView alloc ] initWithFrame:CGRectMake(4, 20, 320, 568)];
    v.backgroundColor = [UIColor grayColor];
//    [self.lunScroll addSubview:v];
}

- (void)experienceClick{
    NSLog(@"开始体验了");
     MTKLoginViewController *loginVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKLoginViewController"];
    [self.navigationController pushViewController:loginVC animated:NO];
//    [self presentViewController:loginVC animated:NO completion:^{
    
//    }];
}


//定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
