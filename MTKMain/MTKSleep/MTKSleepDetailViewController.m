//
//  MTKSleepDetailViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/17.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSleepDetailViewController.h"
#import "MTKSleepView.h"

@interface MTKSleepDetailViewController ()
{
    UIScrollView *scrollView ;
    NSMutableArray *sleepArr;
    int prevTime;//上一时间点
    int prevType;//上一类型
    int soberAmount;//清醒时间
    int simpleSleepAmount;//浅睡眠时长
    int deepSleepAmount;//深睡时长
    int slBeTime; //睡眠时间
    int slEnTime; //醒来时间
    int atType;// 睡眠状态
    MTKSleepView *sleepView;
}
@end

@implementation MTKSleepDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
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

#pragma mark ********初始化
- (void)initializeMethod{
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    sleepArr = [self.sqliData scarchSleepWitchDate:[formatter1 stringFromDate:self.date] Userid:[MTKArchiveTool getUserInfo].userID];
//    if (sleepArr.count > 2) {
//        for (int i = 0; i< sleepArr.count - 1; i++) {
//            NSDictionary *dic1 = sleepArr[i];
//            NSDictionary *dic2 = sleepArr[i+1];
//            if (i == sleepArr.count - 2) {
//                if ([dic1[@"QUALITY"] isEqualToString:dic2[@"QUALITY"]]) {
//                    
//                }
//                
//            }
//            else  if ([dic1[@"QUALITY"] isEqualToString:dic2[@"QUALITY"]]) {
//                [sleepArr removeObject:dic2];
//                i--;
//            }
//        }
//    }
//    NSArray * arr = [sleepArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
//        
//        if ([obj1[@"TIME"] intValue]<[obj2[@"TIME"] intValue]) {
//            return NSOrderedAscending;
//        }
//        else if ([obj1[@"TIME"] intValue]==[obj2[@"TIME"] intValue])
//            return NSOrderedSame;
//        else
//            return NSOrderedDescending;
//    }];
//    sleepArr = [arr mutableCopy];
    prevTime=0;//上一时间点
    prevType=0;//上一类型
    soberAmount=0;//清醒时间
    simpleSleepAmount=0;//浅睡眠时长
    deepSleepAmount=0;//深睡时长
    for (int i = 0; i < sleepArr.count; i ++) {
//        if (i == 0) {
//            slBeTime = [sleepArr[i][@"TIME"] intValue];
//        }
//        else{
            atType = [sleepArr[i][@"QUALITY"] intValue];
            int atTime = [sleepArr[i][@"TIME"] intValue];
            int amount = [sleepArr[i][@"SLEEPTIME"] intValue];
            if (atType == 0 /*&& (atType == 1 || atType == 2 || atType == 0)*/) {
                soberAmount = soberAmount + amount;
            }
            else if (atType == 1 /*&& (atType == 0 || atType == 2 || atType == 1)*/){
                simpleSleepAmount = simpleSleepAmount + amount;
            }
            else if (atType == 2 /*&& (atType == 0 || atType == 1 || atType == 2)*/){
                deepSleepAmount = deepSleepAmount + amount;
            }
//        }
//        prevType = [sleepArr[i][@"QUALITY"] intValue];
//        prevTime = [sleepArr[i][@"TIME"] intValue];
    }
}

#pragma mark ********创建UI
- (void)createUI{
    self.title = MtkLocalizedString(@"sleepdetail_navtilte");
    self.slTime.text = MtkLocalizedString(@"sleepdetail_asleeptime");
     self.wakeTime.text = MtkLocalizedString(@"sleepdetail_waketime");
     self.awakeTime.text = MtkLocalizedString(@"sleepdetail_sobertime");
     self.slLenght.text = MtkLocalizedString(@"sleepdetail_sleeptimelen");
     self.deLenght.text = MtkLocalizedString(@"sleepdetail_hileleeptimelen");
     self.liLenght.text = MtkLocalizedString(@"sleepdetail_sobertimelen");
    CGSize slLenghtSize = [_slLenght.text sizeWithAttributes:@{NSFontAttributeName:_slLenght.font}];
    CGSize deLenghtSize = [_deLenght.text sizeWithAttributes:@{NSFontAttributeName:_deLenght.font}];
    CGSize liLenghtSize = [_liLenght.text sizeWithAttributes:@{NSFontAttributeName:_liLenght.font}];
    CGSize awakeTimeSize = [_awakeTime.text sizeWithAttributes:@{NSFontAttributeName:_awakeTime.font}];
    CGSize timeSize = [[NSString stringWithFormat:@"00 %@ 00 %@",MtkLocalizedString(@"sleep_hour"),MtkLocalizedString(@"sport_minute")] sizeWithAttributes:@{NSFontAttributeName:_awakeTime.font}];
    NSArray *maxArr = @[[NSString stringWithFormat:@"%.0f",slLenghtSize.width],[NSString stringWithFormat:@"%.0f",liLenghtSize.width],[NSString stringWithFormat:@"%.0f",deLenghtSize.width],[NSString stringWithFormat:@"%.0f",awakeTimeSize.width]];
    CGFloat maxWith = [[maxArr valueForKeyPath:@"@max.floatValue"] floatValue] + 8;
    _sleepViewW.constant = maxWith + timeSize.width;

    CGFloat scrHight;
    if (MainScreen.size.height > 568) {
        scrHight = 420.0f;
    }
    else{
        scrHight = 320.f;
    }

    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10,MainScreen.size.width, scrHight - 20)];
    scrollView.contentSize = CGSizeMake(740, scrHight - 40);
    scrollView.contentOffset = CGPointMake(220, 0);
    scrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:scrollView];
    [self updateSleepDetail];
}

- (void)updateUI{
    [self initializeMethod];
    [self createUI];
}

- (void)updateSleepDetail{
    CGFloat scrHight;
    if (MainScreen.size.height > 568) {
        scrHight = 420.0f;
    }
    else{
        scrHight = 320.f;
    }
    [sleepView removeFromSuperview];
    sleepView = [[MTKSleepView alloc] initWithFrame:CGRectMake(10, 10,730,scrHight - 50)];//画图两边各有5像素缩进，为了X轴坐标能显示，故需要在理想长度再增加10像素
    [scrollView addSubview:sleepView];
    sleepView.xTexts = @[@"0",@"6:00",@"12:00",@"18:00",@"24"];
    sleepView.xValues = [sleepArr copy];
    sleepView.backgroundColor = [UIColor clearColor];
    
    int deeHour = [self returnHour:deepSleepAmount].intValue;
    int deeMin = [self returnMin:deepSleepAmount].intValue;
    int ligHour = [self returnHour:simpleSleepAmount].intValue;
    int ligMin = [self returnMin:simpleSleepAmount].intValue;
    int sobHour = [self returnHour:soberAmount].intValue;
    int sobMin = [self returnMin:soberAmount].intValue;
    
    int sleepMin = deeMin + ligMin + sobMin;
    int sleepHour = deeHour + ligHour + sobHour + sleepMin/60;
    sleepMin = sleepMin%60;
    NSString *hour = [NSString stringWithFormat:@"%d",sleepHour];;
    NSString *min = [NSString stringWithFormat:@"%d",sleepMin];
    
    self.slDeTime.text = [NSString stringWithFormat:@"%@:%@",[[self returnHour:[[sleepArr firstObject][@"TIME"] intValue]] intValue]<10?[NSString stringWithFormat:@"0%@",[self returnHour:[[sleepArr firstObject][@"TIME"] intValue]]]:[self returnHour:[[sleepArr firstObject][@"TIME"] intValue]],[[self returnMin:[[sleepArr firstObject][@"TIME"] intValue]] intValue]<10?[NSString stringWithFormat:@"0%@",[self returnMin:[[sleepArr firstObject][@"TIME"] intValue]]]:[self returnMin:[[sleepArr firstObject][@"TIME"] intValue]]];
    self.wakeDeTime.text = [NSString stringWithFormat:@"%@:%@",[[self returnHour:[[sleepArr lastObject][@"TIME"] intValue]] intValue]<10?[NSString stringWithFormat:@"0%@",[self returnHour:[[sleepArr lastObject][@"TIME"] intValue]]]:[self returnHour:[[sleepArr lastObject][@"TIME"] intValue]],[[self returnMin:[[sleepArr lastObject][@"TIME"] intValue]] intValue]<10?[NSString stringWithFormat:@"0%@",[self returnMin:[[sleepArr lastObject][@"TIME"] intValue]]]:[self returnMin:[[sleepArr lastObject][@"TIME"] intValue]]];
    self.awakeDeTime.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[self returnHour:soberAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:soberAmount],MtkLocalizedString(@"sport_minute")];
    self.slDeLenght.text = [NSString stringWithFormat:@"%@ %@ %@ %@",hour,MtkLocalizedString(@"sleep_hour"),min.intValue<10?[NSString stringWithFormat:@"0%@",min]:min,MtkLocalizedString(@"sport_minute")];
    self.deDeLenght.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[self returnHour:deepSleepAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:deepSleepAmount],MtkLocalizedString(@"sport_minute")];
    self.liDeLenght.text = [NSString stringWithFormat:@"%@ %@ %@ %@",[self returnHour:simpleSleepAmount],MtkLocalizedString(@"sleep_hour"),[self returnMin:simpleSleepAmount],MtkLocalizedString(@"sport_minute")];
    
//    self.slDeTime.text = [NSString stringWithFormat:@"%@:%@",[self returnHour:[[sleepArr firstObject][@"TIME"] intValue]],[self returnMin:[[sleepArr firstObject][@"TIME"] intValue]]];
//    self.wakeDeTime.text = [NSString stringWithFormat:@"%@:%@",[self returnHour:[[sleepArr lastObject][@"TIME"] intValue]],[self returnMin:[[sleepArr lastObject][@"TIME"] intValue]]];
//    self.awakeDeTime.text = [NSString stringWithFormat:@"%@:%@",[self returnHour:soberAmount],[self returnMin:soberAmount]];
//    self.slDeLenght.text = [NSString stringWithFormat:@"%@:%@",hour,min];
//    self.deDeLenght.text = [NSString stringWithFormat:@"%@:%@",[self returnHour:deepSleepAmount],[self returnMin:deepSleepAmount]];
//    self.liDeLenght.text = [NSString stringWithFormat:@"%@:%@",[self returnHour:simpleSleepAmount],[self returnMin:simpleSleepAmount]];

}

- (NSString *)returnHour:(int)second{
    int hour = second/3600;
    if (hour < 10) {
        return [NSString stringWithFormat:@"%d",hour];
    }
    else{
        return [NSString stringWithFormat:@"%d",hour];
    }

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
