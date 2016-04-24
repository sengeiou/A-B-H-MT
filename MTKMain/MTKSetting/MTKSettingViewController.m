//
//  MTKSettingViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSettingViewController.h"
#import "MTKUnPairViewController.h"
@interface MTKSettingViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *settingArr;
}
@end

@implementation MTKSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initializeMethod];
    [self createUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化
- (void)initializeMethod{
    settingArr = @[MtkLocalizedString(@"setting_myinfo"),MtkLocalizedString(@"setting_myplan"),MtkLocalizedString(@"setting_boundsmawatch"),MtkLocalizedString(@"setting_unbindbound")];
}

#pragma mark *****创建UI
- (void)createUI{
    self.setTab.tableFooterView = [[UIView alloc] init];
    self.setTab.delegate = self;
    self.setTab.dataSource = self;
}

#pragma mark *****UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = settingArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
    }
    else if (indexPath.row == 1) {
      
    }
    else if (indexPath.row == 2) {
        MTKPairViewController *pairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKPairViewController"];
        pairVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pairVC animated:YES];
    }
    else if (indexPath.row == 3) {
//        [MTKBleMgr forgetPeripheral];
//        NSLog(@"霍霍fiw%@",MTKBleMgr.peripheral);
        [MTKProximiService defaultInstance];
        [MTKBleMgr disConnectWithPeripheral];
        return;
        if ([MTKBleMgr checkBleStatus]) {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"alert_relieveband") message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MTKUnPairViewController *unPairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKUnPairViewController"];
                 unPairVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unPairVC animated:YES];
            }];
            [aler addAction:cancelAct];
            [aler addAction:confim];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
        }
    }
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
