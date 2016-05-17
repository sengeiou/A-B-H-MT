//
//  MTKSleepViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSleepViewController.h"

@interface MTKSleepViewController ()
{
    MTKUserInfo *userInfo;
    int prevTime;//上一时间点
    int prevType;//上一类型
    int soberAmount;//清醒时间
    int simpleSleepAmount;//浅睡眠时长
    int deepSleepAmount;//深睡时长
    int slBeTime; //睡眠时间
    int slEnTime; //醒来时间
    int atType;// 睡眠状态
}
@end

@implementation MTKSleepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initializeMethod];
//    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeMethod];
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

#pragma mark *****初始化
- (void)initializeMethod{
    userInfo = [MTKArchiveTool getUserInfo];
}

#pragma matk *****创建UI
- (void)createUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:32/255.0 green:40/255.0 blue:102/255.0 alpha:1] size:MainScreen.size] forBarMetrics:UIBarMetricsDefault];
    if (MainScreen.size.height > 568) {
        _backH.constant = 350.0f;
    }
    else{
        _backH.constant = 300.0f;
    }
    
    self.dateLab.text=[self dateWithYMD];
    self.hourUnLab.text = MtkLocalizedString(@"sleep_hour");
    self.minUnLab.text = MtkLocalizedString(@"sport_minute");
    self.lastSlLab.text = MtkLocalizedString(@"sleep_remark");
    self.situationLab.text = MtkLocalizedString(@"sleep_status");
    self.deepLab.text = MtkLocalizedString(@"sleep_deep");
    self.lightLab.text = MtkLocalizedString(@"sleep_light");
    self.soberLab.text = MtkLocalizedString(@"sleep_awake");
    [self refreshData];
}

static int  deffInt=30;
- (IBAction)dataRightClick:(id)sender {
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


- (IBAction)dataLeftClick:(id)sender {
    if(deffInt>1)
    {
        deffInt--;
        NSDate *nextDate = [NSDate dateWithTimeInterval:-(24*60*60*(30-deffInt)) sinceDate:[NSDate date]];
        _data=nextDate;
        self.dateLab.text=[self dateWithYMD];
        if (deffInt == 0) {
            self.leftBut.enabled = NO;
        }
        self.rightBut.enabled = YES;
        [self refreshData];
    }
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

- (void)refreshData{
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    NSMutableArray *sleepArr = [self.sqliData scarchSleepWitchDate:[formatter1 stringFromDate:self.data] Userid:userInfo.userID];
    if (sleepArr.count > 2) {
        for (int i = 0; i< sleepArr.count - 1; i++) {
            NSDictionary *dic1 = sleepArr[i];
            NSDictionary *dic2 = sleepArr[i+1];
            if (i == sleepArr.count - 2) {
                if ([dic1[@"QUALITY"] isEqualToString:dic2[@"QUALITY"]]) {

                }

            }
           else  if ([dic1[@"QUALITY"] isEqualToString:dic2[@"QUALITY"]]) {
                [sleepArr removeObject:dic2];
                i--;
            }
        }
    }
    NSArray * arr = [sleepArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        
        if ([obj1[@"TIME"] intValue]<[obj2[@"TIME"] intValue]) {
            return NSOrderedAscending;
        }
        else if ([obj1[@"TIME"] intValue]==[obj2[@"TIME"] intValue])
            return NSOrderedSame;
        else
            return NSOrderedDescending;
    }];
    sleepArr = [arr mutableCopy];
    prevTime=0;//上一时间点
    prevType=0;//上一类型
    soberAmount=0;//清醒时间
    simpleSleepAmount=0;//浅睡眠时长
    deepSleepAmount=0;//深睡时长
    for (int i = 0; i < sleepArr.count; i ++) {
        if (i == 0) {
            slBeTime = [sleepArr[i][@"TIME"] intValue];
        }
        else{
            atType = [sleepArr[i][@"QUALITY"] intValue];
            int atTime = [sleepArr[i][@"TIME"] intValue];
            int amount = atTime - prevTime;
            if (prevType == 0 /*&& (atType == 1 || atType == 2 || atType == 0)*/) {
                soberAmount = soberAmount + amount;
            }
            else if (prevType == 1 /*&& (atType == 0 || atType == 2 || atType == 1)*/){
                simpleSleepAmount = simpleSleepAmount + amount;
            }
            else if (prevType == 2 /*&& (atType == 0 || atType == 1 || atType == 2)*/){
                deepSleepAmount = deepSleepAmount + amount;
            }
        }
        prevType = [sleepArr[i][@"QUALITY"] intValue];
        prevTime = [sleepArr[i][@"TIME"] intValue];
    }
    [self cleanUI];
}

- (void)cleanUI{
    
    int deeHour = [self returnHour:deepSleepAmount];
    int deeMin = [self returnMin:deepSleepAmount].intValue;
    int ligHour = [self returnHour:simpleSleepAmount];
    int ligMin = [self returnMin:simpleSleepAmount].intValue;
    int sobHour = [self returnHour:soberAmount];
    int sobMin = [self returnMin:soberAmount].intValue;
    
    int sleepMin = deeMin + ligMin + sobMin;
    int sleepHour = deeHour + ligHour + sobHour + sleepMin/60;
    sleepMin = sleepMin%60;
    
    self.deepTiLab.text = [NSString stringWithFormat:@"%d%@%@%@",[self returnHour:deepSleepAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:deepSleepAmount],MtkLocalizedString(@"sport_minute")];
    self.lightTiLab.text = [NSString stringWithFormat:@"%d%@%@%@",[self returnHour:simpleSleepAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:simpleSleepAmount],MtkLocalizedString(@"sport_minute")];
    self.soberTiLab.text = [NSString stringWithFormat:@"%d%@%@%@",[self returnHour:soberAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:soberAmount],MtkLocalizedString(@"sport_minute")];
    
    
    self.hourLab.text = [NSString stringWithFormat:@"%d",sleepHour];
    if (sleepMin<10) {
        
        self.minLab.text = [NSString stringWithFormat:@"0%d",sleepMin];
        
    }
    else{
        
    self.minLab.text = [NSString stringWithFormat:@"%d",sleepMin];
        
    }
    if (_hourLab.text.intValue < 10) {
        self.hourLead.constant = -5;
    }
    else{
        self.hourLead.constant = 8;
    }
    
    float quality = (simpleSleepAmount + soberAmount)/(float)deepSleepAmount;
    if (quality>=0.5) {
        _qualityLab.text = MtkLocalizedString(@"sleep_state_enough");
    }
    else if (quality>0.25 && quality < 0.5){
         _qualityLab.text = MtkLocalizedString(@"sleep_state_comfortable");
    }
    else{
         _qualityLab.text = MtkLocalizedString(@"sleep_state_average");
    }
}

- (int)returnHour:(int)second{
    return second/3600;
}

- (NSString *)returnMin:(int)second{
    int min = second%3600/60;

    if (min < 10) {
        return [NSString stringWithFormat:@"0%d",min];
    }
    else{
        return [NSString stringWithFormat:@"%d",min];
    }
}

- (IBAction)detailSelector:(id)sender{
    MTKSleepDetailViewController *detailVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSleepDetailViewController"];
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
