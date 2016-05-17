//
//  MTKSportDetailViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/16.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSportDetailViewController.h"

@interface MTKSportDetailViewController ()
{
    CGRect charRect;
    UILabel *stepUnit;
     int selectIndex;
    NSMutableArray *detailArr;
}
@end

@implementation MTKSportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self initializeMethod];
    selectIndex = 0;
    [self createUI];
    // Do any additional setup after loading the view.
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

#pragma mark *******初始化
- (void)initializeMethod{
    charRect = CGRectMake(0, CGRectGetMaxY(self.actualTypeValue.frame)+30, 320, 200);
}

#pragma mark ********创建UI
- (void)createUI{
    self.title = MtkLocalizedString(@"sport_navtilte");
    _goalLab.text = MtkLocalizedString(@"sport_plaremark");
    _disLab.text = MtkLocalizedString(@"sport_distance");
    _stepLab.text = MtkLocalizedString(@"sport_steps");
    _calLab.text = MtkLocalizedString(@"sport_calor");
    _steUnitLab.text = MtkLocalizedString(@"sport_stepunit");
    _goalStepLab.text = [NSString stringWithFormat:@"%d",[MTKArchiveTool getUserInfo].userGoal.intValue*500+4000];
    [self.actualTypeValue setTitle:MtkLocalizedString(@"sportdetail_day") forSegmentAtIndex:0];
    [self.actualTypeValue setTitle:MtkLocalizedString(@"portdetail_week") forSegmentAtIndex:1];
    [self.actualTypeValue setTitle:MtkLocalizedString(@"sportdetail_tendat") forSegmentAtIndex:2];
     self.actualTypeValue.selectedSegmentIndex=0;
    [self refreshData:0];
    

//    if (sortArray.count == 30) {
//        sortArray = [MutableArray copy];
//        self.chart.indexDraw = 3;
//    }

}
-(void)refreshData:(int)intType
{
    NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    int typeValue=0;
    NSDate *toDate;
    NSDate *Date;

    if(intType==0){
        typeValue=0;
        toDate = self.date;
        Date = [NSDate dateWithTimeInterval:(-(24*60*60)*(typeValue)) sinceDate:self.date];
    }
    else if(intType==1){
        typeValue=7;
        toDate = [NSDate date];
        Date = [NSDate dateWithTimeInterval:(-(24*60*60)*(typeValue)) sinceDate:[NSDate date]];
    }
    else if(intType==2){
        typeValue=30;
        toDate = [NSDate date];
        Date = [NSDate dateWithTimeInterval:(-(24*60*60)*(typeValue)) sinceDate:[NSDate date]];
    }
    detailArr = [self.sqliData scarchSportWitchDate:[formatter1 stringFromDate:Date] toDate:[formatter1 stringFromDate:toDate] UserID:[MTKArchiveTool getUserInfo].userID index:intType+1];
     NSMutableArray *sortArray =[[NSMutableArray alloc] init];
    for (int i = 0; i<25; i++) {
        [sortArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *MutableArray =[[NSMutableArray alloc] init];
    NSMutableArray *MutableArray1 =[[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    if (detailArr.count > 0) {
        dict =detailArr[0];
    }

    if(intType>0)
    {
        [sortArray removeAllObjects];
        int intCount=(intType==1)?7:30;
        NSDate *senddate=[NSDate date];
        NSString *month;
        for (int i=intCount; i>0; i--) {
            NSDate *nextDate = [NSDate dateWithTimeInterval:(-(24*60*60)*(i)) sinceDate:senddate];
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"MM-dd"];
            NSString *locationString=[dateformatter stringFromDate:nextDate];
            [MutableArray1 addObject:locationString];
            if (intCount == 30) {
                if (i%7==2) {
                    if (!month || ![month isEqualToString:[locationString substringToIndex:2]]) {
                        month = [locationString substringToIndex:2];
                    }
                    else{
                        locationString=[[dateformatter stringFromDate:nextDate] substringFromIndex:3];
                    }
                }
                else{
                    locationString=@"";
                }
            }
            [MutableArray addObject:locationString];
        }
        sortArray= MutableArray1;
    }
    
    NSMutableArray *arrayy=[NSMutableArray array];
    NSMutableArray *arrayx=[NSMutableArray array];
    NSMutableArray *arracal=[NSMutableArray array];
    NSMutableArray *arradis=[NSMutableArray array];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd"];
    if (intType == 0) {
        [dateformatter setDateFormat:@"HH"];
    }
    
    NSDateFormatter  *dateformatter1=[[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"yyyyMMddHHmmss"];
    for (int i = 0; i < detailArr.count; i++) {
        [arrayx addObject:[dateformatter stringFromDate:[dateformatter1 dateFromString:[detailArr[i] objectForKey:@"TIME"]]]];
        [arrayy addObject:[detailArr[i] objectForKey:@"STEP"]];
        [arradis addObject:[detailArr[i] objectForKey:@"DISTANCE"]];
        [arracal addObject:[detailArr[i] objectForKey:@"CAL"]];
    }
    NSMutableArray *mArray1 = [NSMutableArray arrayWithCapacity:sortArray.count];
    for (int i=0; i<sortArray.count; i++) {
        int s=(int)arrayy.count;
        if(s==0)
        {
            int sum=(10+i*4);
            NSString *stt=[NSString stringWithFormat:@"%d",sum];
            [mArray1 insertObject:stt atIndex:i];
            
        }else{
            if ([arrayx containsObject:sortArray[i]]) {
                int s= (int)[arrayx indexOfObject:sortArray[i]];
                [mArray1 insertObject:arrayy[s] atIndex:i];
            }else{
                int sum=1;
                NSString *stt=[NSString stringWithFormat:@"%d",sum];
                [mArray1 insertObject:stt atIndex:i];
            }
        }
    }
    
    if(self.charView)
    {
        [self.charView removeFromSuperview];
        [stepUnit removeFromSuperview];
    }
    _charView=[CBChartView charView];
    self.charView.frame=charRect;
    self.charView.chartColor = [UIColor whiteColor];
    self.charView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.charView.center.y);
    self.charView.chartWidth=0.8;
    self.charView.indexDraw = intType+1;
    [self.backView addSubview:self.charView];
    self.charView.xValues=sortArray;
    self.charView.yValues=mArray1;
    self.charView.yValueCount=(int)mArray1.count;
    stepUnit = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.charView.frame)-20, 20, 20)];
    stepUnit.font = [UIFont systemFontOfSize:13];
    stepUnit.textColor = [UIColor whiteColor];
    stepUnit.text = MtkLocalizedString(@"myinfo_step");
    [self.backView addSubview:stepUnit];
    NSString *step;
    NSString *dis;
    NSString *cal;
    if (intType == 0) {
        step = [arrayy valueForKeyPath:@"@max.intValue"];
        dis = [NSString stringWithFormat:@"%0.1f",[[arradis valueForKeyPath:@"@max.floatValue"] floatValue]];
        cal = [NSString stringWithFormat:@"%0.1f",[[arracal valueForKeyPath:@"@max.floatValue"] floatValue]];
    }
    else{
        step = [arrayy valueForKeyPath:@"@sum.intValue"];
        dis = [NSString stringWithFormat:@"%0.1f",[[arradis valueForKeyPath:@"@sum.floatValue"] floatValue]];
        cal = [NSString stringWithFormat:@"%0.1f",[[arracal valueForKeyPath:@"@sum.floatValue"] floatValue]];
    }
    if (arrayy.count > 0) {
    _setStepLab.text = [NSString stringWithFormat:@"%@ %@",step,MtkLocalizedString(@"sport_stepunit")];
        self.setDisLab.text = [NSString stringWithFormat:@"%@ %@",dis,MtkLocalizedString(@"sport_distanceunit")];
        self.setCalLab.text = [NSString stringWithFormat:@"%@ %@",cal,MtkLocalizedString(@"sport_hotunit")];
    }
    else{
        self.setDisLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_distanceunit")];
        self.setStepLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_stepunit")];
        self.setCalLab.text = [NSString stringWithFormat:@"0 %@",MtkLocalizedString(@"sport_hotunit")];
    }

}

- (IBAction)ValueChange:(UISegmentedControl *)sender {
    NSInteger index = sender.selectedSegmentIndex;
    selectIndex = (int)index;
    if (index == 0) {
        [self refreshData:0];//天
        
    }else if (index == 1) {
        [self refreshData:1];//周
        
    }else {
        [self refreshData:2];//月
        
        
    }
}

- (void)updateUI{
    [self refreshData:selectIndex];
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
