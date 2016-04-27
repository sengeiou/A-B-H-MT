//
//  MTKUserViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/25.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKUserViewController.h"

@interface MTKUserViewController ()

@end

@implementation MTKUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化数据
- (void)intializeMethod{
    MyController *mController = [MyController getMyControllerInstance];
//    [mController sendDataWithCmd:GETSYSTEM];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
