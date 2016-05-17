//
//  MTKSettingViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKSettingViewController.h"
#import "MTKUnPairViewController.h"
@interface MTKSettingViewController ()<UITableViewDelegate,UITableViewDataSource,CachedBLEDeviceDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSArray *settingArr;
}
@property (weak, nonatomic) CachedBLEDevice *mDevice;
@end

@implementation MTKSettingViewController
@synthesize mDevice;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    mDevice = [CachedBLEDevice defaultInstance];
//    [mDevice registerAttributeChangedListener:self];
    [self initializeMethod];
    [self createUI];
     [self.setTab reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
   
//     [mDevice unregisterAttributeChangedListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****初始化
- (void)initializeMethod{
    
    settingArr = @[MtkLocalizedString(@"setting_myinfo"),MtkLocalizedString(@"setting_myplan"),MtkLocalizedString(@"setting_boundsmawatch"),MtkLocalizedString(@"setting_unbindbound"),MtkLocalizedString(@"setting_lost")];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(chectBLstate) userInfo:nil repeats:YES];
}

#pragma mark *****创建UI
- (void)createUI{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[MTKArchiveTool getUserInfo].userID]];
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    if(img)
       [self.imageBut setBackgroundImage:img forState:UIControlStateNormal];

    [self chectBLstate];
    self.setTab.tableFooterView = [[UIView alloc] init];
    self.setTab.delegate = self;
    self.setTab.dataSource = self;
    _nameLab.text = [MTKArchiveTool getUserInfo].userName;
}

- (void)chectBLstate{
     CachedBLEDevice* device = [CachedBLEDevice defaultInstance];
    if (device.mConnectionState == 2) {
        _BLIndexView.image = [UIImage imageNamed:@"bluetooth_link_img"];
    }
    else{
        _BLIndexView.image = [UIImage imageNamed:@"bluetooth_disconnect_img"];
    }
}

#pragma mark *****UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.accessoryView = nil;
    cell.textLabel.text = settingArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 4) {
        UISwitch *lostSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        cell.accessoryView = lostSwitch;
        [lostSwitch addTarget:self action:@selector(lostSet:) forControlEvents:UIControlEventValueChanged];
        lostSwitch.on = mDevice.mDisconnectEnabled;
        lostSwitch.onTintColor = [UIColor colorWithRed:55/255.0 green:139/255.0 blue:254/255.0 alpha:1];
    }
    return cell;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return settingArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKUserTableViewController"] animated:YES];
    }
    else if (indexPath.row == 1) {
        [self.navigationController pushViewController:[MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKSportPlanViewController"] animated:YES];
    }
    else if (indexPath.row == 2) {
        NSMutableArray* array = [MTKDeviceParameterRecorder getDeviceParameters];
        if (array.count ==0) {
            MTKPairViewController *pairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKPairViewController"];
            pairVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pairVC animated:YES];
        }
        else{
            [MBProgressHUD showError:MtkLocalizedString(@"alert_alreadyband")];
        }
    }
    else if (indexPath.row == 3) {

//        if ([MTKBleMgr checkBleStatus]) {
            UIAlertController *aler = [UIAlertController alertControllerWithTitle:MtkLocalizedString(@"alert_relieveband") message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAct = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_can") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *confim = [UIAlertAction actionWithTitle:MtkLocalizedString(@"aler_confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                MTKUnPairViewController *unPairVC = [MainStoryBoard instantiateViewControllerWithIdentifier:@"MTKUnPairViewController"];
                 unPairVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:unPairVC animated:YES];
            }];
            [aler addAction:cancelAct];
            [aler addAction:confim];
            [self presentViewController:aler animated:YES completion:^{
                
            }];
//        }
    }
}

- (void)lostSet:(UISwitch *)sender{
   
    if ([MTKBleMgr checkBleStatus]) {
//         [mDevice updateDeviceConfiguration:CONFIG_ALERT_SWITCH_STATE_CHANGE changedValue:YES];
         [mDevice updateDeviceConfiguration:CONFIG_DISCONNECT_ALERT_SWITCH_STATE_CHANGE changedValue:sender.isOn];
    }
   sender.on = mDevice.mDisconnectEnabled;
}

- (IBAction)imaSelector:(id)sender{
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
    BOOL result = [[self scaleToSize:image] writeToFile: filePath  atomically:YES];
    if(result){
        
    }
}

static float i = 0.1; float A = 0;
- (NSData *)scaleToSize:(UIImage *)imge{
    
    
    NSData *data;
    data= UIImageJPEGRepresentation(imge, 1);
    
    if (data.length > 70000) {
        [self zoomImaData:imge];
        data = UIImageJPEGRepresentation(imge,1-A);
        A = 0;
    }
    return data;
    
}

- (void)zoomImaData:(UIImage *)image{
    A = A + i;
    NSData *data = UIImageJPEGRepresentation(image,1-A);
    if (data.length > 70000) {
        [self zoomImaData:image];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)onDeviceAttributeChanged:(int)which{
    
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
