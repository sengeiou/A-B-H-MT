//
//  MTKSportViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSportViewController.h"
#import "KAProgressLabel.h"
#import "UIScrollView+MJRefresh.h"
@interface MTKSportViewController ()<myProtocol>
{
    MTKUserInfo *userInfo;
    NSTimer *setTimer;
    MyController *mController;
    BOOL syncError;
}
@end

@implementation MTKSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeMethod];
//    [self createUI];
    mController = [MyController getMyControllerInstance];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
     [mController setDelegate: self];
    self.scrolllView.delegate = self;
    self.scrolllView.showsVerticalScrollIndicator = FALSE;
    [self initializeMethod];
    [self setupRefresh];
    [self createUI];
}

//加载dal对象
-(MTKSqliteData *)sqliData
{
    if(!_sqliData)
    {
        _sqliData=[[MTKSqliteData alloc]init];
    }
    return _sqliData;
}

-(NSDate *)data
{
    if(_data==nil)
    {
        _data=[NSDate date];
    }
    return _data;
}

- (void)initializeMethod{
    userInfo = [MTKArchiveTool getUserInfo];
}

#pragma mark*****创建UI
- (void)createUI{
    if (MainScreen.size.height > 568) {
        _progressH.constant = 270.0f;
         _progressW.constant = 270.0f;
        _indH.constant = 25.0f;
        _indW.constant = 20.0f;
        _butH.constant = 270.0f;
        _butW.constant = 270.0f;
        _scrollW.constant = [UIScreen mainScreen].bounds.size.width;
        _scrollH.constant = 420.0f;
        [self.progressLab setFont:[UIFont systemFontOfSize:44]];
        [self.progressLab setTrackWidth:9.0f];//轨迹粗细
        [self.progressLab setProgressWidth:9.0f];//进度条粗细
    }
    else{
        _progressH.constant = 220.0f;
         _progressW.constant = 220.0f;
        _indH.constant = 16.0f;
        _indW.constant = 14.0f;
        _butH.constant = 220.0f;
        _butW.constant = 220.0f;
        _scrollH.constant = 320.0f;
        _scrollW.constant = [UIScreen mainScreen].bounds.size.width;
        [self.progressLab setFont:[UIFont systemFontOfSize:34]];
        [self.progressLab setTrackWidth:7.0f];//轨迹粗细
        [self.progressLab setProgressWidth:7.0f];//进度条粗细
    }
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"刷新" highIcon:@"刷新" target:self action:@selector(syncSport)];
    _goalLab.text = MtkLocalizedString(@"sport_plaremark");
    _disLab.text = MtkLocalizedString(@"sport_distance");
    _stepLab.text = MtkLocalizedString(@"sport_steps");
    _calLab.text = MtkLocalizedString(@"sport_calor");
    _steUnitLab.text = MtkLocalizedString(@"sport_stepunit");
    self.dateLab.text=[self dateWithYMD];
    [self.progressLab setStartDegree:0.0f];
    [self.progressLab setEndDegree:0.0f];
    
    float delta =self.progressLab.endDegree-self.progressLab.startDegree;
    [self.progressLab setText:[NSString stringWithFormat:@"%.2f%%",(delta)/3.6]];
    
    [self.progressLab setRoundedCornersWidth:0.0f];//线条头大小

    [self.progressLab setTextColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
  
    
    self.progressLab.fillColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    self.progressLab.trackColor = [UIColor colorWithRed:0/255.0 green:200/255.0 blue:255/255.0 alpha:1];//[UIColor clearColor]; //
    self.progressLab.progressColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1];
    self.progressLab.isStartDegreeUserInteractive = NO;
    self.progressLab.isEndDegreeUserInteractive = NO;
    [self refreshData];
}

- (NSString *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"M月d日";
    NSString *selfStr;
    NSString *today = [fmt stringFromDate:[NSDate date]];
    if ([today isEqualToString:[fmt stringFromDate:self.data]]) {
        selfStr = MtkLocalizedString(@"sleep_today");
        self.rightBut.enabled = NO;
    }
    else {
        selfStr= [fmt stringFromDate:self.data];
    }
    return [self FormatStr:selfStr];
}

-(NSString *)FormatStr:(NSString *)str
{
    NSString *month=MtkLocalizedString(@"sleep_monthunit");
    
    if([month isEqualToString:@""])
    {
        if([str rangeOfString:@"1月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"1月" withString:@"January "];
        }else if([str rangeOfString:@"2月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"2月" withString:@"February "];
        }else if([str rangeOfString:@"3月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"3月" withString:@"March "];
        }else if([str rangeOfString:@"4月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"4月" withString:@"April "];
        }else if([str rangeOfString:@"5月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"5月" withString:@"May "];
        }else if([str rangeOfString:@"6月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"6月" withString:@"June "];
        }else if([str rangeOfString:@"7月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"7月" withString:@"July "];
        }else if([str rangeOfString:@"8月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"8月" withString:@"August "];
        } else if([str rangeOfString:@"9月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"9月" withString:@"September "];
        }
        else if([str rangeOfString:@"10月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"10月" withString:@"October "];
        }
        else if([str rangeOfString:@"11月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"11月" withString:@"November "];
        }
        else if([str rangeOfString:@"12月"].location !=NSNotFound){
            str=[str stringByReplacingOccurrencesOfString:@"12月" withString:@"December "];
        }
        str=[str stringByReplacingOccurrencesOfString:@"日" withString:MtkLocalizedString(@"sleep_dayunit")];
    }
    
    return str;
}

int  deffInt=30;
- (IBAction)dataAddClick:(id)sender {
    if(deffInt<30)
    {
        deffInt++;
        NSDate *nextDate = [NSDate dateWithTimeInterval:(24*60*60*(deffInt-30)) sinceDate:[NSDate date]];
        _data=nextDate;
        self.dateLab.text=[self dateWithYMD];
        if (deffInt == 30) {
            self.rightBut.enabled = NO;
        }
        self.leftBut.enabled = YES;
        [self refreshData];
    }
}


- (IBAction)dataCutClick:(id)sender {
    if(deffInt>1)
    {
        deffInt--;
        NSDate *nextDate = [NSDate dateWithTimeInterval:-(24*60*60*(30-deffInt)) sinceDate:[NSDate date]];
        _data=nextDate;
        self.dateLab.text=[self dateWithYMD];
        if (deffInt == 1) {
            self.leftBut.enabled = NO;
        }
        self.rightBut.enabled = YES;
        [self refreshData];
    }
}

- (void)syncSport{
    if ([MTKBleMgr checkBleStatus]) {
        syncError = NO;
       
        NSString *setUser = GETDESPORT;
        [mController sendDataWithCmd:setUser mode:GETSDETHEART];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
}

- (void)timeout{
    syncError = YES;
    self.scrolllView.scrollEnabled = YES;
    [self.view endEditing:YES];
    self.scrolllView.headerRefreshingText = MtkLocalizedString(@"alert_syncerror");
    [self.scrolllView headerEndRefreshing];

    if (setTimer) {
        [setTimer invalidate];
        setTimer = nil;
    }
}

- (void)refreshData{
   
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    NSMutableArray *spoArr = [self.sqliData scarchSportWitchDate:[formatter1 stringFromDate:self.data] toDate:[formatter1 stringFromDate:self.data] UserID:userInfo.userID index:0];
    if (spoArr.count > 0) {
        self.setDisLab.text = [NSString stringWithFormat:@"%@ %@",[[spoArr lastObject] objectForKey:@"DISTANCE"],MtkLocalizedString(@"sport_distanceunit")];
        self.setStepLab.text = [NSString stringWithFormat:@"%@ %@",[[spoArr lastObject] objectForKey:@"STEP"],MtkLocalizedString(@"sport_stepunit")];
        self.setCalLab.text = [NSString stringWithFormat:@"%@ %@",[[spoArr lastObject] objectForKey:@"CAL"],MtkLocalizedString(@"sport_hotunit")];
    }
    else{
        self.setDisLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_distanceunit")];
        self.setStepLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_stepunit")];
        self.setCalLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_hotunit")];
    }
    if (!userInfo.userGoal || userInfo.userGoal.intValue<0) {
        userInfo.userGoal = 0;
        [MTKArchiveTool saveUser:userInfo];
        [self.progressLab setText:@"0"];
    }
    else{
        [self.progressLab setStartDegree:0.0f];
        float valu=[_setStepLab.text floatValue]/(userInfo.userGoal.intValue*500+4000);
        [self.progressLab setText:[NSString stringWithFormat:@"%.2f%%",(valu*100)]];
        [self.progressLab setEndDegree:valu*360];
    }
     _goalStepLab.text = [NSString stringWithFormat:@"%d",userInfo.userGoal.intValue*500+4000];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.scrolllView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.scrolllView.headerPullToRefreshText = MtkLocalizedString(@"aler_downSync");
    self.scrolllView.headerReleaseToRefreshText = MtkLocalizedString(@"aler_Sync");
    self.scrolllView.headerRefreshingText = MtkLocalizedString(@"aler_syncing");
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSLog(@"进入刷新");
    self.scrolllView.scrollEnabled = NO;
    if ([MTKBleMgr checkBleStatus]) {
        self.scrolllView.headerRefreshingText = MtkLocalizedString(@"aler_syncing");
        syncError = NO;
        NSString *setUser = GETDESPORT;
        [mController sendDataWithCmd:setUser mode:GETSDETHEART];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
    else{
        // 刷新表格
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.scrolllView.scrollEnabled = YES;
            [self.view endEditing:YES];
            [self.scrolllView headerEndRefreshing];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        });
    }
}


#pragma mark *****myProtocol代理
- (void)onDataReceive:(NSString *)recvData mode:(MTKBLEMEDO)mode{
    userInfo = [MTKArchiveTool getUserInfo];
    if (mode == GETSDETSPORT) {
//        mController = [MyController getMyControllerInstance];
        NSString *setUser = GETDESELEEP;
        [mController sendDataWithCmd:setUser mode:GETSDETSPORT];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
    else if (mode == GETSDETSLEEP){
        NSString *setUser = GETDEDATA;
        [mController sendDataWithCmd:setUser mode:GETSDETSPORT];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
    else if (mode == GETUSERINFO){
         [self refreshData];
    }
    else if (mode == GETSDETDATA){
        NSLog(@"更新运动数据页面");
        [self refreshData];
        if (!syncError) {
            self.scrolllView.scrollEnabled = YES;
            [self.view endEditing:YES];
             self.scrolllView.headerRefreshingText = MtkLocalizedString(@"aler_syncsucc");
            [self.scrolllView headerEndRefreshing];
        }
       
           if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrolllView == scrollView) {
    if (scrollView.contentOffset.y >= 0) {
                scrollView.contentOffset = CGPointMake(0, 0);
                return;
        }
    }
    return;
}

- (IBAction)detailSelector:(id)sender{
    MTKSportDetailViewController *detailVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSportDetailViewController"];
    detailVC.date = self.data;
    [self.navigationController pushViewController:detailVC animated:YES];
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
