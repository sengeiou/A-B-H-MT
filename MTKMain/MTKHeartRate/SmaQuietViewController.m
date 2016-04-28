//
//  SmaQuietViewController.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "SmaQuietViewController.h"
//#import "SmaTabBarViewController.h"
//#import "AppDelegate.h"
@interface SmaQuietViewController ()/*<TabBarDelegate>*/
{
    NSMutableArray *quietDaArr;
//    AppDelegate *appDele;
}
@end

@implementation SmaQuietViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeMethod];
    [self createUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *******创建UI*******
- (void)createUI{
    self.title = MtkLocalizedString(@"hearReat_quietTitle");
    tableview.dataSource = self;
    tableview.delegate = self;
    remindLab.text = MtkLocalizedString(@"hearRate_Quiet_remind");
//    tableview.userInteractionEnabled = YES;
    tableview.tableFooterView = [[UIView alloc] init];
    quietView = [[SmaQuietView alloc] initWithFrame:self.view.frame];
    [quietView createUI];
    quietView.hidden = YES;
    quietView.delegate = self;
    [self.view addSubview:quietView];
}


#pragma mark ******初始化*******
- (void)initializeMethod{
//    if (!appDele) {
//        appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    }
//    appDele.tabVC.Tabdelegate = self;

    quietDaArr = [NSMutableArray array];
    NSMutableArray *quietHis = [MTKDefaultinfos getValueforKey:QUIETHEART];
//    [SmaUserDefaults removeObjectForKey:@"quietDaArr"];
    for (NSArray *arr in quietHis) {
        [quietDaArr addObject:arr];
    }
    if (!quietHis || quietHis.count == 0) {
         [quietDaArr addObject:@[@"hearRate_quiet_last",@"hearReat_quietTitle"]];
    }
    fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy/MM/dd";
//    NSString *str = [fmt stringFromDate:[NSDate date]];
}

#pragma mark UITableViewDelegate*******
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SmaQuietTableCell *cell = [tableview dequeueReusableCellWithIdentifier:@"QUIETCELL"];
    if (!cell) {
      cell = [[[NSBundle mainBundle] loadNibNamed:@"SmaQuietTableCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == quietDaArr.count) {
        cell.addBut.hidden = NO;
        cell.textLab.text = @"";
        cell.subtiLab.text = @"";
        cell.delegate = self;
    }
    else if (indexPath.row == 0){
        
        cell.textLab.text = MtkLocalizedString(quietDaArr[indexPath.row][0]);
        cell.subtiLab.text = MtkLocalizedString(quietDaArr[indexPath.row][1]);
        cell.addBut.hidden = YES;
        cell.delegate = nil;

    }
    else {
    cell.textLab.text = quietDaArr[indexPath.row][0];
    cell.subtiLab.text = quietDaArr[indexPath.row][1];
    cell.addBut.hidden = YES;
    cell.delegate = nil;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return quietDaArr.count+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        selectIdx = (int)indexPath.row;
        quietView.hidden = NO;
        quietView.confirmBut.selected = YES;
        quietView.quietField.text = [[quietDaArr objectAtIndex:indexPath.row][1] stringByReplacingOccurrencesOfString:@" bpm" withString:@""];
        quietView.unitLab.text = @"bpm";
    }
}

#pragma mark *******QuietCell*******
- (void)addQuiet{
    quietView.hidden = NO;
    quietView.confirmBut.selected = NO;
    quietView.dateLab.text = [fmt stringFromDate:[NSDate date]];
    quietView.quietField.text =@"";
//    quietView.unitLab.text =@"bpm";
}

#pragma mark *******QuietView*******
- (void)cancelWithBut:(UIButton *)sender{
    [quietView.quietField resignFirstResponder];
    quietView.hidden = YES;
}

#pragma mark *******TABVCdelegare******
//- (void)HRvcSelect{
//    CATransition* transition = [CATransition animation];
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; /* 动画的开始与结束的快慢*/
//    transition.duration = 1.0f;
//    transition.type = @"rippleEffect";//可更改为其他方式
//    transition.subtype = kCATransitionFromTop;//可更改为其他方式
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    appDele.tabVC.pushHR = NO;
//    for (UIView *child in appDele.tabVC.tabBar.subviews) {
//        if ([child isKindOfClass:[UIControl class]]) {
//            [child removeFromSuperview];
//        }
//    }
//}

- (void)confirmWithBut:(UIButton *)sender{
    if (!sender.selected) {
        if (quietView.quietField && ![quietView.quietField.text isEqualToString:@""]) {
            if (selectIdx>0) {
                [quietDaArr removeObjectAtIndex:selectIdx];
                
            }
            if (quietDaArr.count > 5) {
                [quietDaArr removeObjectAtIndex:5];
            }
            
//            else{
            [quietDaArr insertObject:@[[fmt stringFromDate:[NSDate date]],[NSString stringWithFormat:@"%@ bpm",quietView.quietField.text]] atIndex:1];
//            }
//            [MTKDefaultinfos setObject:quietDaArr forKey:@"quietDaArr"];
            [MTKDefaultinfos putKey:QUIETHEART andValue:quietDaArr];
            [quietView.quietField resignFirstResponder];
            quietView.hidden = YES;
            [tableview reloadData];
        }
        else{
            [MBProgressHUD showError:MtkLocalizedString(@"hearReat_notHR")];
        }
    }
    else{
        [quietDaArr removeObjectAtIndex:selectIdx];
//        [SmaUserDefaults putKey:quietDaArr forKey:@"quietDaArr"];
        [MTKDefaultinfos putKey:QUIETHEART andValue:quietDaArr];
        [quietView.quietField resignFirstResponder];
        quietView.hidden = YES;
        [tableview reloadData];
    }
    selectIdx = 0;
}

- (void)keyboardWillShow{
    quietView.confirmBut.selected = NO;
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
