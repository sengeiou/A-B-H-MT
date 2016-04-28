//
//  MTKNavViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKNavViewController.h"

@interface MTKNavViewController ()

@end

@implementation MTKNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:55/255.0 green:139/255.0 blue:254/255.0 alpha:1] size:MainScreen.size] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.delegate = self;
//   [[UINavigationBar appearance] setBarTintColor:[UIColor redColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //    viewController.navigationItem.leftBarButtonItem = nil;
    if (/*viewController.navigationItem.leftBarButtonItem == nil && */[navigationController viewControllers].count > 1) {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self Hidden:self.leftItemHidden action:@selector(_didClickBackBarButtonItem:)];
    }
}

- (void)_didClickBackBarButtonItem:(id)sender{
    [self popViewControllerAnimated:YES];
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
