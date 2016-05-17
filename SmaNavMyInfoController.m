//
//  SmaNavMyInfoController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/5/15.
//  Copyright (c) 2015年 SmaLife. All rights reserved.
//

#import "SmaNavMyInfoController.h"
#import "MtkAppDelegate.h"
#import "MTKTabBarViewController.h"
//#import "SmaSelectViewController.h"
//#import "SmaAnalysisWebServiceTool.h"

@interface SmaNavMyInfoController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MTKUserInfo *userInfo;
}
@property (weak, nonatomic) IBOutlet UIButton *wsexbnt;
@property (weak, nonatomic) IBOutlet UIButton *mensexbnt;
@property(nonatomic,weak)UIDatePicker *datePicker;//日期选择

@end

@implementation SmaNavMyInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [[MTKUserInfo alloc] init];
    userInfo.userName = @"welcome";
    userInfo.userID = @"1";
    userInfo.userPass = @"123456";
    userInfo.userWeigh = @"30";
    userInfo.userHeight = @"50";
    userInfo.userGoal = @"0";
    [MTKArchiveTool saveUser:userInfo];
    self.title=MtkLocalizedString(@"myinfo_navtitle");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:55/255.0 green:139/255.0 blue:254/255.0 alpha:1] size:MainScreen.size] forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage *img=[UIImage imageNamed:@"nav_back_button"];
    CGSize size={img.size.width *0.5,img.size.height*0.5};
    UIImage *backButtonImage = [[UIImage imageByScalingAndCroppingForSize:size imageName:@"nav_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,30,0,5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //NSArray *idents = [NSLocale availableLocaleIdentifiers];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;//只显示日期，不显示时间
    //    self.birthday.inputView=datePicker;
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    
    toolbar.bounds = CGRectMake(0, 0, 320, 44);
    toolbar.backgroundColor = [UIColor grayColor];
    
    UIBarButtonItem *tanhuangBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //创建完成按钮
    UIBarButtonItem *finish = [[UIBarButtonItem alloc] initWithTitle:MtkLocalizedString(@"achieve_btn") style:UIBarButtonItemStylePlain target:self action:@selector(finishSelectedDate)];
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:MtkLocalizedString(@"close_btn") style:UIBarButtonItemStylePlain target:self action:@selector(closeSelectedDate)];
    
    toolbar.items = @[close,tanhuangBtn,finish];
    //    self.birthday.inputAccessoryView = toolbar;
    self.datePicker = datePicker;
    
    self.nickname.placeholder=MtkLocalizedString(@"myinfo_nickname");
    //    [self.headimgview setImage:[UIImage imageLocalWithName:@"default_head_img"]];
    //
    //    [self.birthdaybtn setTitle:MtkLocalizedString(@"myinfo_age") forState:UIControlStateNormal];
    //    self.birthdaybtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    self.birthdaybtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //
    //     [self.sexbtn setTitle:MtkLocalizedString(@"myinfo_sex") forState:UIControlStateNormal];
    //    self.sexbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    self.sexbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.higthbtn setTitle:MtkLocalizedString(@"myinfo_height") forState:UIControlStateNormal];
    self.higthbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.higthbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    
    [self.weithbtn setTitle:MtkLocalizedString(@"myinfo_weight") forState:UIControlStateNormal];
    self.weithbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.weithbtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [self.nexbtn setTitle:MtkLocalizedString(@"myinfo_next") forState:UIControlStateNormal];
    self.nexbtn.layer.borderWidth = 1.0f;
    self.nexbtn.layer.masksToBounds = YES;
    self.nexbtn.layer.cornerRadius = 10.0;
    self.nexbtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.imageBut.layer.borderWidth = 1.0f;
    self.imageBut.layer.masksToBounds = YES;
    self.imageBut.layer.cornerRadius = self.imageBut.frame.size.width/2;
    self.imageBut.layer.borderColor = [UIColor clearColor].CGColor;
    //    [self.nexbtn setImage:[UIImage imageLocalWithName:@"next_btn_bg"] forState:UIControlStateNormal];
    //    [self.nexbtn setImage:[UIImage imageLocalWithName:@"next_btn_bg_sel"] forState:UIControlStateHighlighted];
    //
    // 3.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.取出键盘的frame
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height+160);
        // self.btnImgView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
    }];
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformIdentity;
        //self.btnImgView.transform = CGAffineTransformIdentity;
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)closeSelectedDate{
    //    [self.birthday resignFirstResponder];
}
-(void)finishSelectedDate{
    //获取时间
    //    NSDate *selectedDate = self.datePicker.date;
    //    //格式化日期(2014-08-25)
    //    //格式化日期类
    //    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    //    //设置日期格式
    //    formater.dateFormat = @"yyyy-MM-dd";
    //    NSString *dateStr = [formater stringFromDate:selectedDate];
    //    self.birthday.text = dateStr;
    //隐藏键盘
    //    [self.birthday resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextbtnClick:(id)sender {
    
    
    if(![self.nickname.text isEqualToString:@""])
    {
        
        userInfo.userName=self.nickname.text;
    }
    NSLog(@"%@",self.heightFiele.text);
    if(![self.heightFiele.text isEqualToString:@""])
    {
        if (self.heightFiele.text.intValue <= 229 && self.heightFiele.text.intValue >49) {
            userInfo.userHeight=self.heightFiele.text;
        }
        else{
            [MBProgressHUD showError:MtkLocalizedString(@"myinfo_Hrange")];
             return;
        }
        
    }
    
    if(![self.weightfield.text isEqualToString:@""])
    {
        if (self.weightfield.text.intValue <= 229 && self.weightfield.text.intValue >29) {
            userInfo.userWeigh=self.weightfield.text;
            
        }
        else{
            [MBProgressHUD showError:MtkLocalizedString(@"myinfo_Wrange")];
            return;
        }
        
    }
    
    [MTKArchiveTool saveUser:userInfo];
    [MTKDefaultinfos putKey:FIRSTLUN andValue:@"firstLun"];
    MtkAppDelegate *appDele = (MtkAppDelegate *)[UIApplication sharedApplication].delegate;
    MTKTabBarViewController *tabVC = [[MTKTabBarViewController alloc] init];
    appDele.window.rootViewController = tabVC;
}

- (IBAction)headSelector:(id)sender{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing=YES;
    picker.sourceType=UIModalTransitionStyleCoverVertical;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(selectPic:) withObject:image afterDelay:0.1];
}

-(void)selectPic:(UIImage*)image{
    [self.imageBut setBackgroundImage:image forState:UIControlStateNormal];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[MTKArchiveTool getUserInfo].userID]];
    BOOL result = [[self scaleSize:image] writeToFile: filePath  atomically:YES];
    if(result){
        
    }
}

static float j = 0.1; float B = 0;

- (NSData *)scaleSize:(UIImage *)imge{
    
    
    NSData *data;
    data= UIImageJPEGRepresentation(imge, 1);
    
    if (data.length > 70000) {
        [self zoomData:imge];
        data = UIImageJPEGRepresentation(imge,1-B);
        B = 0;
    }
    return data;
    
}

- (void)zoomData:(UIImage *)image{
    B = B + j;
    NSData *data = UIImageJPEGRepresentation(image,1-B);
    if (data.length > 70000) {
        [self zoomData:image];
    }
}

- (IBAction)msexClick:(id)sender {
    self.mensexbnt.selected=true;
    self.wsexbnt.selected=!self.mensexbnt.selected;
}

- (IBAction)wsexBtnClick:(id)sender {
    self.wsexbnt.selected=true;
    self.mensexbnt.selected=!self.wsexbnt.selected;
}
@end
