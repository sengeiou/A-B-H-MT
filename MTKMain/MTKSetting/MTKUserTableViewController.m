//
//  MTKUserTableViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/25.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKUserTableViewController.h"

@interface MTKUserTableViewController ()
{
    NSArray *titleArr, *imaArr;
    MTKUserInfo *user;
    NSMutableArray *detialArr;
    NSIndexPath *tabSelect;
    NSTimer *setTimer;
    MyController *mController;
}
@end

@implementation MTKUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [self intializeMethod];
    [self createUI];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化数据
- (void)intializeMethod{
    self.title = MtkLocalizedString(@"setting_myinfo");
    titleArr = @[/*MtkLocalizedString(@"myinfo_account"),MtkLocalizedString(@"myinfo_accountpwd"),*/MtkLocalizedString(@"myinfo_nickname"),MtkLocalizedString(@"myinfo_weight"),MtkLocalizedString(@"myinfo_height")];
    imaArr = @[/*@"account_ico",@"pwd_ico",*/@"nickname_ico",@"weight_ico",@"height_ico"];
    user = [MTKArchiveTool getUserInfo];
    NSArray *detArr = @[/*user.userID,@"******",*/user.userName,[NSString stringWithFormat:@"%@ %@",user.userWeigh,MtkLocalizedString(@"myinfo_uniwi1")],[NSString stringWithFormat:@"%@ %@",user.userHeight,MtkLocalizedString(@"myinfo_unithe1")]];
    detialArr = [NSMutableArray array];
    detialArr = [detArr mutableCopy];
    
}

#pragma mark *****创建UI
- (void)createUI{
    mController = [MyController getMyControllerInstance];
    [mController setDelegate: self];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"USERCELL"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayerCell"];
    if (indexPath.row<3) {
        cell.imageView.image = [UIImage imageNamed:imaArr[indexPath.row]];
        cell.textLabel.text = titleArr[indexPath.row];
        cell.detailTextLabel.text = detialArr[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.hidden = NO;
        cell.textLabel.hidden = NO;
        cell.detailTextLabel.hidden = NO;
    }
    else{
        UIButton *conformBut = [UIButton buttonWithType:UIButtonTypeCustom];
        conformBut.frame = CGRectMake(0, 0, 200, 30);
        conformBut.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, cell.frame.size.height/2);
        [conformBut addTarget:self action:@selector(setUserToMTK) forControlEvents:UIControlEventTouchUpInside];
        [conformBut setTitle:MtkLocalizedString(@"myinfo_New") forState:UIControlStateNormal];
        conformBut.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:255/255.0 alpha:1];
        conformBut.layer.masksToBounds = YES;
        conformBut.layer.borderWidth = 1.0f;
        conformBut.layer.cornerRadius = 15.0f;
        conformBut.layer.borderColor = [UIColor clearColor].CGColor;
        [cell addSubview:conformBut];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.hidden = YES;
        cell.textLabel.hidden = YES;
        cell.detailTextLabel.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 25, 20)];
    //        unitLab.backgroundColor = [UIColor greenColor];
    unitLab.font = [UIFont systemFontOfSize:10];
    tabSelect = indexPath;
    if (indexPath.row == 0) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"myinfo_nickname") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
        }];
        UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //            [detialArr replaceObjectAtIndex:2 withObject:user.userName];
            //            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = user.userName;
        }];
        
        [alerVC addAction:cancel];
        [alerVC addAction:confim];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
    }
    if (indexPath.row == 1) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"myinfo_weight") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            unitLab.text = MtkLocalizedString(@"myinfo_uniwi1");
            textField.keyboardType= UIKeyboardTypePhonePad;
            textField.rightView = unitLab;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.placeholder = @"30 ~~ 229";
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
        }];
        UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
            if (user.userWeigh.intValue <= 229 && user.userWeigh.intValue >29) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",user.userWeigh,MtkLocalizedString(@"myinfo_uniwi1")];
            }
            else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:MtkLocalizedString(@"myinfo_Wrange")];
                });
            }
        }];
        
        [alerVC addAction:cancel];
        [alerVC addAction:confim];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
    }
    if (indexPath.row == 2) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"myinfo_height") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alerVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:textField];
            unitLab.text = MtkLocalizedString(@"myinfo_unithe1");
            textField.keyboardType= UIKeyboardTypePhonePad;
            textField.rightView = unitLab;
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.placeholder = @"50 ~~ 229";
            user.userHeight = textField.text;
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
        }];
        UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (user.userHeight.intValue <= 229 && user.userHeight.intValue >49) {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",user.userHeight,MtkLocalizedString(@"myinfo_unithe1")];
            }
            else{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showError:MtkLocalizedString(@"myinfo_Hrange")];
                });
            }
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:alerVC.textFields.firstObject];
        }];
        
        [alerVC addAction:cancel];
        [alerVC addAction:confim];
        [self presentViewController:alerVC animated:YES completion:^{
            
        }];
    }
}


- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (tabSelect.row == 0) {
        user.userName = textField.text;
    }
    if (tabSelect.row == 1) {
        //        if (textField.text.intValue <= 229 && textField.text.intValue >29) {
        user.userWeigh = textField.text;
        //        }
    }
    if (tabSelect.row == 2) {
        //        if (textField.text.intValue <= 229 && textField.text.intValue >49) {
        user.userHeight = textField.text;
        //        }
    }
}

- (void)setUserToMTK{
    if ([MTKBleMgr checkBleStatus]) {
        
        
        NSString *setUser = [NSString stringWithFormat:@"PS,SET,%@|%@|%@",[NSString stringWithFormat:@"%d",user.userGoal.intValue*500+4000],user.userHeight,user.userWeigh];
        
        [mController sendDataWithCmd:setUser mode:SETUSERINFO];
        if (setTimer) {
            [setTimer invalidate];
            setTimer = nil;
        }
        setTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
        [MBProgressHUD showMessage:MtkLocalizedString(@"alert_seting")];
        
    }
}

- (void)onDataReceive:(NSString *)recvData mode:(MTKBLEMEDO)mode{
    if (mode == SETUSERINFO ) {
        if (setTimer) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:MtkLocalizedString(@"alert_setSuccess")];
        }
        [MTKArchiveTool saveUser:user];
        [self intializeMethod];
        [self.tableView reloadData];
    }
    if (mode == GETUSERINFO) {
        [self intializeMethod];
        [self.tableView reloadData];
    }
    if (setTimer) {
        [setTimer invalidate];
        setTimer = nil;
    }
}

- (void)timeout{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:MtkLocalizedString(@"alert_failed")];
    if (setTimer) {
        [setTimer invalidate];
        setTimer = nil;
    }
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
