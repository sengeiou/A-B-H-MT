//
//  MTKPairViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKPairViewController.h"
#import "MtkAppDelegate.h"
@interface MTKPairViewController ()<MTKCoreBlueToolDelegate,StateChangeDelegate,BleDiscoveryDelegate>
{
    MTKCoreBlueTool *MTKBL;
    NSTimer *scanTimer;
    MtkAppDelegate *appDele;
}
@end

@implementation MTKPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
//    MTKBL = [MTKCoreBlueTool sharedInstance];
//    MTKBL.delegate = self;
//    [MTKBL forgetPeripheral];
    if (!appDele) {
        appDele = (MtkAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    [[MTKBleManager sharedInstance] registerDiscoveryDelgegate:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MTKBL MTKStartScan:NO];
//        [[BackgroundManager sharedInstance] forge]
//         [[MTKBleManager sharedInstance] forgetPeripheral];
         [[BackgroundManager sharedInstance] startScan:YES];
        scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanTimeOut:) userInfo:nil repeats:YES];
    });

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[ScanTableViewController], viewDidAppear Enter");
    [[BackgroundManager sharedInstance] registerStateChangeDelegate:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"[ScanTableViewController], viewDidDisappear Enter");
    [[BackgroundManager sharedInstance] unRegisterStateChangeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****创建UI
- (void)createUI{
    [_stateBut setTitle:MtkLocalizedString(@"beginingseatch_title") forState:UIControlStateNormal];
    [_connectBut setTitle:MtkLocalizedString(@"seatch_bandtitle") forState:UIControlStateNormal];
//    [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateSelected];
    _connectBut.selected = NO;
//    _connectBut.layer.borderColor = [[UIColor whiteColor] CGColor];
    _connectBut.layer.borderWidth = 1.0f;
    _connectBut.layer.masksToBounds = YES;
    _connectBut.layer.cornerRadius = 10.0;
    _connectBut.layer.borderColor = [UIColor whiteColor].CGColor;

    _imageView.hidden = YES;
    _headLab.text = MtkLocalizedString(@"seatch_title");
    _footLab.text = MtkLocalizedString(@"seatch_remind");
}

- (IBAction)connectMTK:(UIButton *)but{
    if (but.selected) {
          [self.navigationController popToRootViewControllerAnimated:YES];
        // 删除系统自动生成的UITabBarButton
        for (UIView *child in appDele.tabVC.tabBar.subviews) {
            if ([child isKindOfClass:[UIControl class]]) {
                [child removeFromSuperview];
            }
        }
    }
    else{
        [MTKBL MTKStopScan];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scanTimeOut:(NSTimer *)timer{
    [[BackgroundManager sharedInstance] stopScan];
    [[BackgroundManager sharedInstance] startScan:YES];
//    [MTKBL MTKStopScan];
//    [MTKBL MTKStartScan:NO];
}

#pragma mark *****MTKCoreBlueToolDelegate
- (void)MTKBLConnecting{
    NSLog(@"*****MTKBLConnecting*****");
//    if (_connectBut.selected) {
        [_stateBut setTitle:MtkLocalizedString(@"binging_title") forState:UIControlStateNormal];
        _imageView.hidden = YES;
//    }
}

- (void)MTKBLConnectFinish:(int)state Peripheral:(CBPeripheral *)p{
    NSLog(@"*****MTKBLConnectFinish***** %d",state);
    if (state == 2) {
        [_stateBut setTitle:@"" forState:UIControlStateNormal];
        _imageView.hidden = NO;
        _connectBut.selected = YES;
        MTKUserInfo *user = [MTKArchiveTool getUserInfo];
        if (!user) {
            user = [[MTKUserInfo alloc] init];
            user.userName = @"welcome";
            user.userID = @"1";
            user.userWeigh = @"30";
            user.userHeight = @"50";
            user.userGoal = @"4000";
        }
        user.userUUID = p.identifier.UUIDString;
        [MTKArchiveTool saveUser:user];
      [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateNormal];
    }
}

-(void)onConnectionStateChange:(CBPeripheral*)peripheral connectionState:(int)state
{
//    tempPeripheral = nil;
    
    if (state == CONNECTION_STATE_CONNECTED)
    {
        //        [self hideConnectionIndicator];
        NSLog(@"[ScanTableViewController] [onConnectionStateChange] connection state : CONNECTION_STATE_CONNECTED");
        [_stateBut setTitle:@"" forState:UIControlStateNormal];
        _imageView.hidden = NO;
        _connectBut.selected = YES;
      [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateNormal];
//        mIsConnectingOneDevice = NO;
//        
        CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
        
        device.mDeviceName = [peripheral name];
        device.mDeviceIdentifier = [[peripheral identifier] UUIDString];
        device.mAlertEnabled = true;
        device.mRangeAlertEnabled = true;
        device.mRangeType = RANGE_ALERT_OUT;
        device.mRangeValue = RANGE_ALERT_FAR;
        device.mDisconnectEnabled = true;
        device.mRingtoneEnabled = true;
        device.mVibrationEnabled = true;
        device.mConnectionState = CONNECTION_STATE_CONNECTED;
        
        [device setDevicePeripheral:peripheral];
        
        [device persistData:1];
        
        [[BackgroundManager sharedInstance] stopScan];
        
        CachedBLEDevice* device1 = [CachedBLEDevice defaultInstance];
//        UINavigationController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//        [self presentViewController:controller animated:YES completion:nil];
        
        [[BackgroundManager sharedInstance] stopConnectTimer];
        //
        [[BackgroundManager sharedInstance] unRegisterStateChangeDelegate:self];
    }
    else if (state == CONNECTION_STATE_DISCONNECTED)
    {
        NSLog(@"[ScanTableViewController] [onConnectionStateChange] connection state : CONNECTION_STATE_DISCONNECTED");
//        [self hideConnectionIndicator];
//        mIsConnectingOneDevice = NO;
        [[BackgroundManager sharedInstance] stopConnectTimer];
        
    }
    
}

- (void) discoveryDidRefresh: (CBPeripheral *)peripheral
{
    NSLog(@"[MTKPairViewController] [discoveryDidRefresh] enter");
  if ([peripheral.name isEqualToString:@"K88H"] ) {
//      [[BackgroundManager sharedInstance] stopScan];
      [[BackgroundManager sharedInstance] connectDevice:peripheral];
  }
}

-(void)onAdapterStateChange:(int)state{
    NSLog(@"[MTKPairViewController] [onAdapterStateChange] %d",state);
}

-(void)onScanningStateChange:(int)state{
    NSLog(@"[MTKPairViewController] [onScanningStateChange] %d",state);
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
