//
//  MTKHeartViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/27.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKHeartViewController.h"

@interface MTKHeartViewController ()
{
     MTKUserInfo *userInfo;
}
@end

@implementation MTKHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     [self initializeMethod];
//     [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self initializeMethod];
    [self createUI];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (MainScreen.size.height > 568) {
        _backH.constant = 350.0f;
    }
    else{
        _backH.constant = 300.0f;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:241/255.0 green:19/255.0 blue:71/255.0 alpha:1] size:MainScreen.size] forBarMetrics:UIBarMetricsDefault];
    _lastTexLab.text = MtkLocalizedString(@"hearRate_monitor");
    _situationLab.text = MtkLocalizedString(@"hearRate_HRmonitor");
    _quietLab.text = MtkLocalizedString(@"hearRate_RestHR");
    _avgLab.text = MtkLocalizedString(@"hearRate_MeanHR");
    _maxLab.text = MtkLocalizedString(@"hearRate_MaxHR");
    [_detailBut setTitle:MtkLocalizedString(@"hearReat_detail") forState:UIControlStateNormal];
    CAGradientLayer * _gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
    _gradientLayer.bounds = CGRectMake(_gradientLayer.bounds.origin.x, _gradientLayer.bounds.origin.y, _gradientLayer.bounds.size.width, _backH.constant);
    _gradientLayer.borderWidth = 0;
    
    _gradientLayer.frame = _HRView.frame;
    _gradientLayer.colors = [NSArray arrayWithObjects:
                             (id)[[UIColor colorWithRed:241/255.0 green:19/255.0 blue:71/255.0 alpha:1] CGColor],
                             (id)[[UIColor colorWithRed:236/255.0 green:18/255.0 blue:105/255.0 alpha:1]  CGColor],  nil];
    _gradientLayer.startPoint = CGPointMake(0,0);
    _gradientLayer.endPoint = CGPointMake(0, 0.5);
    _HRView.backgroundColor = [UIColor colorWithRed:241/255.0 green:19/255.0 blue:71/255.0 alpha:1];
//    [_HRView.layer insertSublayer:_gradientLayer atIndex:0];
       self.dateLab.text=[self dateWithYMD];
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
    NSArray *quiteArr = [MTKDefaultinfos getValueforKey:QUIETHEART];
    if (quiteArr.count>1) {
        _quietSetLab.text = quiteArr[1][1];
        NSLog(@"fefw==%@ %@",quiteArr,quiteArr[1]);
    }
    else {
        _quietSetLab.text = @"0 bpm";
    }
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    NSMutableArray *heartArr = [self.sqliData scarchHeartWitchDate:[formatter1 stringFromDate:self.data] toDate:[formatter1 stringFromDate:self.data] Userid:userInfo.userID];
    if (heartArr.count>2) {
        _avgSetLab.text = [NSString stringWithFormat:@"%.0f bpm",[heartArr[0] floatValue]];
        _maxSetLab.text = [NSString stringWithFormat:@"%@ bpm",heartArr[1]];
        _heartLab.text = [NSString stringWithFormat:@"%@",heartArr[2]];
    }
    else{
        _avgSetLab.text = @"0 bpm";
        _maxSetLab.text = @"0 bpm";
        _heartLab.text = @"0";
    }
    if (_heartLab.text.intValue < 60) {
        _stateLab.text = MtkLocalizedString(@"hearReat_slow");
    }
    else if (_heartLab.text.intValue >= 60 && _heartLab.text.intValue <= 100){
        _stateLab.text = MtkLocalizedString(@"hearReat_normal");
    }
    else{
        _stateLab.text = MtkLocalizedString(@"hearReat_High");
    }
    if (_heartLab.text.length>=3) {
        _heartLead.constant = 15;
    }
    else if (_heartLab.text.length == 2){
        _heartLead.constant = 10;
    }
    else {
        _heartLead.constant = 0;
    }
}

- (IBAction)detailsBut:(id)sender{
    [self.navigationController pushViewController:[[SmaQuietViewController alloc] initWithNibName:@"SmaQuietViewController" bundle:nil] animated:YES];
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
