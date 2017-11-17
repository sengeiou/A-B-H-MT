//
//  MTKPairViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKPairViewController.h"
#import "MtkAppDelegate.h"
@interface MTKPairViewController ()<MTKCoreBlueToolDelegate,StateChangeDelegate,BleDiscoveryDelegate,UITableViewDelegate,UITableViewDataSource>
{
    MTKCoreBlueTool *MTKBL;
    NSTimer *scanTimer;
    MtkAppDelegate *appDele;
    NSMutableArray* foundedDevices;
}
@end

@implementation MTKPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
    
    if (!appDele) {
        appDele = (MtkAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    [[MTKBleManager sharedInstance] forgetPeripheral];
    [BackgroundManager sharedInstance].tempPeripheral = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [foundedDevices removeAllObjects];
    [self.tableView reloadData];
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

- (void)viewWillDisappear:(BOOL)animated{
    [MTKBL MTKStopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeMethod{
    foundedDevices = [NSMutableArray array];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark *****创建UI
- (void)createUI{
//    [_searchBut setTitle:MtkLocalizedString(@"searct_click") forState:UIControlStateNormal];
     _searchLab.text = MtkLocalizedString(@"searct_click");
    _searchBut.layer.borderWidth = 1.0f;
    _searchBut.layer.masksToBounds = YES;
    _searchBut.layer.cornerRadius = _searchBut.frame.size.width/2;
    _searchBut.layer.borderColor = [UIColor whiteColor].CGColor;
    [_unpairBut setTitle:MtkLocalizedString(@"search_unpar") forState:UIControlStateNormal];
//    self.title = MtkLocalizedString(@"search_title");
    _headLab.text = MtkLocalizedString(@"search_nextit");
    _headLab1.text = MtkLocalizedString(@"search_title");
}

- (IBAction)connectMTK:(UIButton *)but{
    but.selected = !but.selected;
    if (but.selected) {
//        [_searchBut setTitle:MtkLocalizedString(@"search_stopS") forState:UIControlStateNormal];
         _searchLab.text = MtkLocalizedString(@"search_stopS");
         [foundedDevices removeAllObjects];
        [self.tableView reloadData];
        [[BackgroundManager sharedInstance] startScan:NO];
    }
    else{
//        [_searchBut setTitle:MtkLocalizedString(@"searct_click") forState:UIControlStateNormal];
          _searchLab.text = MtkLocalizedString(@"searct_click");
        [MTKBL MTKStopScan];
    }
}

- (IBAction)unpairSelector:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in appDele.tabVC.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }

}

- (void)scanTimeOut:(NSTimer *)timer{
    [[BackgroundManager sharedInstance] stopScan];
    [BackgroundManager sharedInstance].tempPeripheral = nil;
    [[BackgroundManager sharedInstance] startScan:YES];
//    [MTKBL MTKStopScan];
//    [MTKBL MTKStartScan:NO];
}

#pragma mark *****UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    cell.textLabel.text = [(CBPeripheral *)[foundedDevices objectAtIndex:indexPath.row] name];
    cell.detailTextLabel.text = [(CBPeripheral *)[foundedDevices objectAtIndex:indexPath.row] identifier].UUIDString;
    return cell;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  foundedDevices.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
//        if([[BackgroundManager sharedInstance] getScanningState] == SCANNING_STATE_OFF)
//        {
//            NSLog(@"[ScanTableViewController] [didSelectRowAtIndexPath] start scan action");
//            [foundedDevices removeAllObjects];
//            [[BackgroundManager sharedInstance] startScan:YES];
//        }
//        else
//        {
//            NSLog(@"[ScanTableViewController] [didSelectRowAtIndexPath] stop scan action");
//            [[BackgroundManager sharedInstance] stopScan];
//        }
//    }
//    else if (indexPath.section == 1)
//    {
//        if (mIsConnectingOneDevice == NO)
//        {
           [MBProgressHUD showMessage:MtkLocalizedString(@"binging_title")];
            NSLog(@"[ScanTableViewController] selected row is : %ld", (long)[indexPath row]);
            // should do connect action, after connect succeed, show main view controller
            
            NSLog(@"[ScanTableViewController] [didSelectRowAtIndexPath] call to connect action");
            
            CBPeripheral* pp = [foundedDevices objectAtIndex:indexPath.row];
//            tempPeripheral = pp;
            NSLog(@"[ScanTableViewController] [didSelectRowAtIndexPath] click devicename : %@ ", [pp name]);
            
//            connectingCell = (ScannedDeviceTableCell*)[tableView cellForRowAtIndexPath:indexPath];
//            [connectingCell showIndicator:true];
    
            [[BackgroundManager sharedInstance] connectDevice:pp];
//        }
//        else if (mIsConnectingOneDevice == YES)
//        {
//            NSLog(@"[ScanTableViewController] [didSelectRowAtIndexPath] current connecting devices");
//        }
//    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)onConnectionStateChange:(CBPeripheral*)peripheral connectionState:(int)state
{
//    tempPeripheral = nil;
       [MBProgressHUD hideHUD];
    if (state == CONNECTION_STATE_CONNECTED)
    {
        //        [self hideConnectionIndicator];
        NSLog(@"[ScanTableViewController] [onConnectionStateChange] connection state : CONNECTION_STATE_CONNECTED");
//        [_stateBut setTitle:@"" forState:UIControlStateNormal];
//        _imageView.hidden = NO;
//        _connectBut.selected = YES;
//        [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateNormal];
//        mIsConnectingOneDevice = NO;
//
        [MBProgressHUD showSuccess:MtkLocalizedString(@"search_consucc")];
        CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
        NSArray *array = [MTKDeviceParameterRecorder getDeviceParameters];
        if (array.count == 0)
        {
        device.mDeviceName = [peripheral name];
        device.mDeviceIdentifier = [[peripheral identifier] UUIDString];
        device.mAlertEnabled = true;
        device.mRangeAlertEnabled = true;
        device.mRangeType = RANGE_ALERT_OUT;
        device.mRangeValue = RANGE_ALERT_FAR;
        device.mDisconnectEnabled = YES;
        device.mRingtoneEnabled = NO;
        device.mVibrationEnabled = NO;
        device.mConnectionState = CONNECTION_STATE_CONNECTED;
        
        [device setDevicePeripheral:peripheral];
        
        [device persistData:1];
        }
        [[BackgroundManager sharedInstance] stopScan];
        
         CachedBLEDevice* device1 = [CachedBLEDevice defaultInstance];
//        UINavigationController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//        [self presentViewController:controller animated:YES completion:nil];
        
        [[BackgroundManager sharedInstance] stopConnectTimer];
        //
        [[BackgroundManager sharedInstance] unRegisterStateChangeDelegate:self];
        [self unpairSelector:nil];
    }
    else if (state == CONNECTION_STATE_DISCONNECTED)
    {
        NSLog(@"[ScanTableViewController] [onConnectionStateChange] connection state : CONNECTION_STATE_DISCONNECTED");
//        [self hideConnectionIndicator];
//        mIsConnectingOneDevice = NO;
        [[BackgroundManager sharedInstance] stopConnectTimer];
         [MBProgressHUD showError:MtkLocalizedString(@"search_confail")];
        
    }
    else{
        [MBProgressHUD showError:MtkLocalizedString(@"search_confail")];
    }
    
}

- (void) discoveryDidRefresh: (CBPeripheral *)peripheral
{
    NSLog(@"[MTKPairViewController] [discoveryDidRefresh] enter");
//  if ([peripheral.name isEqualToString:@"SMA-09"] ) {
      if (foundedDevices != nil /*&& [peripheral.name isEqualToString:@"SMA-09"]*/)
      {
          if (![foundedDevices containsObject:peripheral])
          {
              [foundedDevices addObject:peripheral];
          }
      }
      [self.tableView reloadData];
//      [[BackgroundManager sharedInstance] stopScan];
//      [[BackgroundManager sharedInstance] connectDevice:peripheral];
//  }
}
- (void)canConnect:(CBPeripheral *)peripheral{
//     [[BackgroundManager sharedInstance] connectDevice:peripheral];
//    if ([peripheral.name isEqualToString:@"SMA-09"] ) {
        if (foundedDevices != nil /*&& [peripheral.name isEqualToString:@"SMA-09"]*/)
        {
            if (![foundedDevices containsObject:peripheral])
            {
                [foundedDevices addObject:peripheral];
            }
        }
        [self.tableView reloadData];
//    }
}

-(void)onAdapterStateChange:(int)state{
    NSLog(@"[MTKPairViewController] [onAdapterStateChange] %d",state);
}

-(void)onScanningStateChange:(int)state{
    NSLog(@"[MTKPairViewController] [onScanningStateChange] %d",state);
}

- (void)dealloc{
    NSLog(@"dealloc");
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
