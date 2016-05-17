//
//  MTKUnPairViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/24.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKUnPairViewController.h"
#import "MTKPairViewController.h"
#import "MTKProximiService.h"
@interface MTKUnPairViewController ()
{
    MTKProximiService *service ;
}
@end

@implementation MTKUnPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    // Do any additional setup after loading the view.
    
//  [MTKBleMgr forgetPeripheral];
  
//    service = [MTKProximiService defaultInstance];
//    [MTKBleMgr disConnectWithPeripheral];
//     MTKUserInfo *user = [MTKArchiveTool getUserInfo];
//     user.userUUID = @"";
//    [MTKArchiveTool saveUser:user];
    
    [[BackgroundManager sharedInstance] setDisconnectFromUx:YES];
    [[MTKBleManager sharedInstance] forgetPeripheral];
    [[BackgroundManager sharedInstance] disconnectDevice:[[CachedBLEDevice defaultInstance] getDevicePeripheral]];
//    [[MTKBleManager sharedInstance] forgetPeripheral];
    ////
    [MTKDeviceParameterRecorder deleteDevice:[CachedBLEDevice defaultInstance].mDeviceIdentifier];
    [[BackgroundManager sharedInstance] stopScan];
    //////
    [[SOSCallDataManager sosCallDataMgrInstance] clearAllData];
    CachedBLEDevice* device = [CachedBLEDevice defaultInstance] ;
    device.mDeviceIdentifier = nil;
    device.mConnectionState = CONNECTION_STATE_DISCONNECTED;
}

- (void)createUI{
    _connectBut.layer.borderWidth = 1.0f;
    _connectBut.layer.masksToBounds = YES;
    _connectBut.layer.cornerRadius = 10.0;
    _connectBut.layer.borderColor = [UIColor whiteColor].CGColor;
    [_connectBut setTitle:MtkLocalizedString(@"unpair_connect") forState:UIControlStateNormal];
    _upairBut.layer.borderWidth = 1.0f;
    _upairBut.layer.masksToBounds = YES;
    _upairBut.layer.cornerRadius = 10.0;
    _upairBut.layer.borderColor = [UIColor whiteColor].CGColor;
     [_upairBut setTitle:MtkLocalizedString(@"unpair_success") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)unPairSuccess:(UIButton *)but{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)connectSelect:(UIButton *)but{
    MTKPairViewController *pairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKPairViewController"];
    [self.navigationController pushViewController:pairVC animated:YES];
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
