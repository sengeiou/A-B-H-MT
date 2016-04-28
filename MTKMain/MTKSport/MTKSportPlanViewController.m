//
//  MTKSportPlanViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/25.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSportPlanViewController.h"

@interface MTKSportPlanViewController ()<myProtocol>
{
    int newVal;
    NSTimer *setTimer;
    MTKUserInfo *userinfo;
    MyController *mController;
    BOOL syncError;
    UILabel *statelab;
}
@property (nonatomic,strong) UILabel *statelab;
@property (nonatomic,strong) UILabel *unitlab;
@end

@implementation MTKSportPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
  
//    [mController sendDataWithCmd:@"GET,0" mode:GETUSERINFO];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addClick
{
    if ([MTKBleMgr checkBleStatus]) {
         syncError = NO;
       [MBProgressHUD showMessage:MtkLocalizedString(@"alert_seting")];
              NSString *setUser = [NSString stringWithFormat:@"PS,SET,%d|%@|%@",newVal*500+4000,userinfo.userHeight,userinfo.userWeigh];
        [mController sendDataWithCmd:setUser mode:SETUSERINFO];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
}

- (void)timeout{
    syncError = YES;
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:MtkLocalizedString(@"alert_failed")];
    if (setTimer) {
        [setTimer invalidate];
        setTimer = nil;
    }
}

#pragma mark *****初始化
- (void)initializeMethod{
    mController = [MyController getMyControllerInstance];
    [mController setDelegate: self];
}

#pragma mark *****创建UI
- (void)createUI{
    if (MainScreen.size.height > 568) {
        _backH.constant = 25.0f;
    }
    else{
        _backH.constant = 20.0f;
    }

    userinfo = [MTKArchiveTool getUserInfo];
    self.setLab.text = MtkLocalizedString(@"setplan_remark");
    self.title = MtkLocalizedString(@"setplan_navtitle");
    self.disLab.text = MtkLocalizedString(@"sport_distance");
    self.stepLab.text = MtkLocalizedString(@"sport_steps");
    self.kcaLab.text = MtkLocalizedString(@"sport_calor");
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"alarm_submit_bg" highIcon:@"alarm_submit_bg" target:self action:@selector(addClick)];
    newVal = [MTKArchiveTool getUserInfo].userGoal.intValue;
    UIImage *bodyImg=[UIImage imageLocalWithName:@"plan_slidebar_bg"];
    CGFloat imgViewh=bodyImg.size.height;
    CGFloat frameW=bodyImg.size.width;
    CGFloat marginY=53;
    CGRect minuteSliderFrame = CGRectMake((self.view.frame.size.width-bodyImg.size.width-14)/2,marginY-7,frameW+14, imgViewh+14);
    if (_minuteSlider) {
        [_minuteSlider removeFromSuperview];
        _minuteSlider = nil;
    }
    _minuteSlider = [[EFCircularSlider alloc] initWithFrame:minuteSliderFrame];
    _minuteSlider.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, _minuteSlider.center.y-32);
    _minuteSlider.unfilledColor =[UIColor clearColor];//SmaColor(220, 220, 220);//
    
    _minuteSlider.filledColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255.0/255.0 alpha:1];
    _minuteSlider.labelFont = [UIFont systemFontOfSize:12.0f];
    _minuteSlider.lineWidth = 10;
    _minuteSlider.minimumValue = 0;
    _minuteSlider.maximumValue = 32;
    _minuteSlider.labelColor = [UIColor colorWithRed:76/255.0f green:111/255.0f blue:137/255.0f alpha:1.0f];
    _minuteSlider.handleType = doubleCircleWithOpenCenter;
    _minuteSlider.handleColor = _minuteSlider.filledColor;
    [self.view  addSubview:self.minuteSlider];
    [self.minuteSlider addTarget:self action:@selector(minuteDidChange:) forControlEvents:UIControlEventValueChanged];
    self.minuteSlider.currentValue=newVal/32.0*100;
    if (statelab) {
        [statelab removeFromSuperview];
        statelab = nil;
    }
    statelab=[[UILabel alloc]init];
    statelab.font=[UIFont systemFontOfSize:38];
    statelab.textColor=[UIColor colorWithRed:0/255.0f green:160/255.0f blue:225/255.0f alpha:1.0f];
    statelab.text=@"0";
    _statelab=statelab;
    statelab.text=[NSString stringWithFormat:@"%d",newVal*500+4000];
    CGSize fontsize = [statelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:38]}];
    
    UILabel *unitlab=[[UILabel alloc]init];
    unitlab.font=[UIFont systemFontOfSize:14];
    unitlab.textColor=[UIColor colorWithRed:0/255.0f green:160/255.0f blue:225/255.0f alpha:1.0f];
    unitlab.text=MtkLocalizedString(@"sport_stepunit");
    CGSize unitsize = [unitlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    _unitlab=unitlab;
    
    CGFloat x=(bodyImg.size.width-fontsize.width-unitsize.width)/2;
    CGFloat y=(bodyImg.size.height-fontsize.height-unitsize.height)/2;
    
    statelab.frame=CGRectMake(x,y, fontsize.width, fontsize.height);
    unitlab.frame=CGRectMake(x+fontsize.width,y+unitsize.height,unitsize.width,unitsize.height);
    [self.sliderView addSubview:statelab];
    [self.sliderView addSubview:unitlab];
    [self setPlanView:newVal];
    
 
}

-(void)minuteDidChange:(EFCircularSlider*)slider {
    newVal = (int)slider.currentValue <= 100 ? (int)slider.currentValue : 0;
    
    NSLog(@"%d intval == %d",newVal,newVal*500+4000);
    self.statelab.text=[NSString stringWithFormat:@"%d",newVal*500+4000];
   
    CGSize fontsize = [self.statelab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:38]}];
    CGSize unitsize = [self.unitlab.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    UIImage *bodyImg=[UIImage imageNamed:@"plan_slidebar_bg"];
    
    CGFloat x=(bodyImg.size.width-fontsize.width-unitsize.width)/2;
    CGFloat y=(bodyImg.size.height-fontsize.height-unitsize.height)/2;
    
    self.statelab.frame=CGRectMake(x,y, fontsize.width, fontsize.height);
    self.unitlab.frame=CGRectMake(x+fontsize.width,y+unitsize.height,unitsize.width,unitsize.height);

    [self setPlanView:newVal];
}

- (void)setPlanView:(int)intAmount{
    
    self.setStepLab.text = [NSString stringWithFormat:@"%d %@",intAmount*500+4000,MtkLocalizedString(@"sport_stepunit")];
    self.setDisLab.text = [NSString stringWithFormat:@"%@ %@",[self notRounding:[self countDistWithStep:intAmount*500+4000 Height:userinfo.userHeight] afterPoint:1],MtkLocalizedString(@"sport_distancekmunit")];
    self.setCalLab.text = [NSString stringWithFormat:@"%@ %@",[self notRounding:[self countCalWithSex:@"1" userWeight:userinfo.userWeigh step:intAmount*500+4000] afterPoint:1],MtkLocalizedString(@"sport_hotunit")];
}

-(NSString *)newFloat:(float)value withNumber:(int)numberOfPlace
{
    NSString *formatStr = @"%0.";
    formatStr = [formatStr stringByAppendingFormat:@"%df", numberOfPlace];
    formatStr = [NSString stringWithFormat:formatStr, value];
    printf("22formatStr %s\n", [formatStr UTF8String]);
    return formatStr;
}

- (float)countCalWithSex:(NSString *)sex userWeight:(NSString *)weight step:(int )step{
    if ([sex isEqualToString:@"1"]) {
        return (55*[weight floatValue]*step)/100000;
    }
    else{
        return (46*[weight floatValue]*step)/100000;
    }
}

- (float)countDistWithStep:(int)setp Height:(NSString *)height{
   
    return [height floatValue]*45*setp/10000000;
}

//保证四舍不入
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness: NO  raiseOnOverflow: NO  raiseOnUnderflow: NO  raiseOnDivideByZero: NO ];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return  [NSString stringWithFormat: @"%@" ,roundedOunces];
    
}

#pragma mark *****myProtocol代理
- (void)onDataReceive:(NSString *)recvData mode:(MTKBLEMEDO)mode{
    if (mode == SETUSERINFO && setTimer) {
        NSLog(@"********************************************设置完成********");
        if (!syncError) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:MtkLocalizedString(@"alert_setSuccess")];
        }
        userinfo.userGoal = [NSString stringWithFormat:@"%d",newVal];
        [MTKDefaultinfos putInt:SPORTGOAL andValue:newVal];
        [MTKArchiveTool saveUser:userinfo];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
    }
    else if (mode == GETUSERINFO || mode == SETUSERINFO){
        [self createUI];
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
