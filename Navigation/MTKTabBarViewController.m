//
//  MTKTabBarViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKTabBarViewController.h"
#import "MtkAppDelegate.h"
#import "MTKTabBar.h"
@interface MTKTabBarViewController ()<MTKTabBarDelegate,StateChangeDelegate,myProtocol>
{
    MtkAppDelegate *appDele;
    NSMutableArray* array;
}
@property (nonatomic, strong) MTKSportViewController *sportVC;
@property (nonatomic, strong) MTKSleepViewController *sleepVC;
@property (nonatomic, strong) MTKNoticViewController *noticVC;
@property (nonatomic, strong) MTKHeartViewController *heartVC;
@property (nonatomic, strong) MTKSettingViewController *settingVC;
//5.自定义Tabbar
@property (nonatomic, weak) MTKTabBar *customTabBar;
@end

@implementation MTKTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
//    [MTKBleManager sharedInstance];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[ScanTableViewController], viewDidAppear Enter");
    if (array.count != 0)
    {
    [[BackgroundManager sharedInstance] registerStateChangeDelegate:self];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    if (array.count != 0)
    {
    NSLog(@"[ScanTableViewController], viewDidDisappear Enter");
    [[BackgroundManager sharedInstance] unRegisterStateChangeDelegate:self];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
//    [sel]
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化数据
- (void)initializeMethod{
//    MTKUserInfo *user = [MTKArchiveTool getUserInfo];
//    if (!user) {
//        user = [[MTKUserInfo alloc] init];
//        user.userName = @"welcome";
//        user.userID = @"1";
//        user.userPass = @"123456";
//        user.userWeigh = @"30";
//        user.userHeight = @"50";
//        user.userGoal = @"4000";
//    }
//    [MTKArchiveTool saveUser:user];
    
    array = [MTKDeviceParameterRecorder getDeviceParameters];
    if (array.count != 0)
    {
        CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
        DeviceInfo* para = [array objectAtIndex:0];
        device.mDeviceIdentifier = para.device_identifier;
        device.mDeviceName = para.device_name;
        device.mAlertEnabled = [para.alert_enabler intValue];
        device.mRangeAlertEnabled = [para.range_alert_enabler intValue];
        device.mRangeType = [para.range_type intValue];
        device.mRangeValue = [para.range_value intValue];
        device.mRingtoneEnabled = [para.ringtone_enabler intValue];
        device.mVibrationEnabled = [para.vibration_enabler intValue];
        device.mDisconnectEnabled = [para.disconnect_alert_enabler intValue];
        [device loadFinished];
    }
    else{
        [[BackgroundManager sharedInstance] stopScan];
    }
}

- (void)createUI{
    if (!appDele) {
        appDele = (MtkAppDelegate *)[UIApplication sharedApplication].delegate;
    }
    appDele.tabVC = self;
    [self setupTabbar];
    [self setupAllChildViewControllers];
    [self addOtherButton];
   
}

/**
 *  <#Description#> 初始化tabbar
 */
- (void)setupTabbar
{
    MTKTabBar *customTabBar = [[MTKTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  <#Description#> 初始化子控制器
 */
-(void)setupAllChildViewControllers
{
    MTKSportViewController *sport= [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSportViewController"];
    [self setupChildViewController:sport title:MtkLocalizedString(@"sport_navtilte") imageName:@"tabbar_sport_button" selectedImageName:@"tabbar_sport_button_highlighted"];
    self.sportVC=sport;
    
    //SmaSleepMainViewController *sleep=[[SmaSleepMainViewController alloc]init];
    
    MTKSleepViewController *sleep= [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSleepViewController"];
    [self setupChildViewController:sleep title:MtkLocalizedString(@"sleep_navtilte") imageName:@"tabbar_sleep_button" selectedImageName:@"tabbar_sleep_button_highlighted.png"];
    self.sleepVC=sleep;
    
    MTKHeartViewController *heartVC= [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKHeartViewController"];
    [self setupChildViewController:heartVC title:MtkLocalizedString(@"hearRate_title") imageName:@"hearNor" selectedImageName:@"hearSel"];
    self.heartVC=heartVC;
    
    
    MTKSettingViewController *me= [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSettingViewController"];
    [self setupChildViewController:me title:MtkLocalizedString(@"setting_navtitle")  imageName:@"tabbar_person_button" selectedImageName:@"tabbar_person_button_highlighted"];
    self.settingVC=me;
    
  self.selectedIndex = 0;
}

-(void)addOtherButton
{
//    _btnArrays=[NSMutableArray array];
//    for (int i=0; i<3; i++) {
//        UIButton *btn=[[UIButton alloc]init];
//        btn.tag=i;
//        NSString *imgName=[NSString stringWithFormat:@"other_button_%d",i];
//        [btn setBackgroundImage:[UIImage imageLocalWithName:imgName] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(openClick:) forControlEvents:UIControlEventTouchUpInside];
//        btn.frame = CGRectMake(self.view.frame.size.width/2 - CHPpopUpMenuItemSize/2, self.view.frame.size.height, CHPpopUpMenuItemSize, CHPpopUpMenuItemSize);
//        [self.btnArrays addObject:btn];
//        btn.alpha=0.0;
//        [self.view addSubview:btn];
//    }
}

/**
 *  初始化一个子控制器
 *
 *  @param childVc           需要初始化的子控制器
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    
    // UIImage *img=[UIImage imageNamed:imageName];
    
    //压缩图片大小
    //CGSize size={img.size.width *0.6,img.size.height*0.6};
    
    // childVc.tabBarItem.image = [UIImage imageByScalingAndCroppingForSize:size imageName:imageName];
    childVc.tabBarItem.image =[UIImage imageNamed:imageName];// [UIImage imageByScalingAndCroppingForSize:size imageName:imageName];
    // 设置选中的图标
    //UIImage *selectedImage = [UIImage imageByScalingAndCroppingForSize:size imageName:selectedImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];// [UIImage
    childVc.tabBarItem.selectedImage = selectedImage;
    
    // 2.包装一个导航控制器
    MTKNavViewController *nav = [[MTKNavViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    nav.isPushingOrPoping = NO;
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

/**
 *  监听tabbar按钮的改变
 *  @param from   原来选中的位置
 *  @param to     最新选中的位置
 */
- (void)tabBar:(MTKTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to
{
    self.selectedIndex = to;
    CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
    if (array.count > 0 && device.mConnectionState != CONNECTION_STATE_CONNECTED && [BackgroundManager sharedInstance].centralManagerState == CBCentralManagerStatePoweredOn) {
    [[BackgroundManager sharedInstance] connectDevice:[[CachedBLEDevice defaultInstance] getDevicePeripheral]];//当绑定的设备并未连接即主动连接设备
    }
    MyController *mController = [MyController getMyControllerInstance];
    [mController sendDataWithCmd:GETDEUSER mode:GETUSERINFO];
//    if (self.isOpen.boolValue==1) {
//        [self dismissSubMenu];
//    }
//    if(self.customview)
//    {
//        self.customview.frame=CGRectMake(0, 0, 0, 0);
//    }
//    [self pushHRView];
}

-(void)onAdapterStateChange:(int)state{
    
}
-(void)onConnectionStateChange:(CBPeripheral*)peripheral connectionState:(int)state{
//    if (state == CONNECTION_STATE_CONNECTED){
//    CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
//    
//    device.mDeviceName = [peripheral name];
//    device.mDeviceIdentifier = [[peripheral identifier] UUIDString];
//    device.mAlertEnabled = true;
//    device.mRangeAlertEnabled = true;
//    device.mRangeType = RANGE_ALERT_OUT;
//    device.mRangeValue = RANGE_ALERT_FAR;
//    device.mDisconnectEnabled = true;
//    device.mRingtoneEnabled = true;
//    device.mVibrationEnabled = true;
//    device.mConnectionState = CONNECTION_STATE_CONNECTED;
//    
//    [device setDevicePeripheral:peripheral];
//    
//    [device persistData:1];
//    
//    [[BackgroundManager sharedInstance] stopScan];
//    }
}
-(void)onScanningStateChange:(int)state{
    
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
