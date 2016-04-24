//
//  MTKPairViewController.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKPairViewController.h"

@interface MTKPairViewController ()<MTKCoreBlueToolDelegate>
{
    MTKCoreBlueTool *MTKBL;
    NSTimer *scanTimer;
}
@end

@implementation MTKPairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    MTKBL = [MTKCoreBlueTool sharedInstance];
    MTKBL.delegate = self;
    [MTKBL forgetPeripheral];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MTKBL MTKStartScan:NO];
        scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanTimeOut:) userInfo:nil repeats:YES];
    });

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
//    [self createUI];
//    MTKBL = [MTKCoreBlueTool sharedInstance];
//    MTKBL.delegate = self;
//    [MTKBL forgetPeripheral];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MTKBL MTKStartScan:NO];
//        scanTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(scanTimeOut:) userInfo:nil repeats:YES];
//    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark *****创建UI
- (void)createUI{
    [_stateBut setTitle:MtkLocalizedString(@"beginingseatch_title") forState:UIControlStateNormal];
    [_connectBut setTitle:MtkLocalizedString(@"seatch_bandtitle") forState:UIControlStateNormal];
    [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateSelected];
    _connectBut.selected = NO;
//    _connectBut.layer.borderColor = [[UIColor whiteColor] CGColor];
    _connectBut.layer.borderWidth = 1.0f;
    _connectBut.layer.masksToBounds = YES;
    _connectBut.layer.cornerRadius = 10.0;
    _connectBut.layer.borderColor = [UIColor whiteColor].CGColor;

    _imageView.hidden = YES;
    _headLab.text = MtkLocalizedString(@"seatch_title");
    _footLab.text = MtkLocalizedString(@"seatch_remind");
}

- (IBAction)connectMTK:(UIButton *)but{
    if (but.selected) {
          [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [MTKBL MTKStopScan];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)scanTimeOut:(NSTimer *)timer{
    [MTKBL MTKStopScan];
    [MTKBL MTKStartScan:NO];
}

#pragma mark *****MTKCoreBlueToolDelegate
- (void)MTKBLConnecting{
    NSLog(@"*****MTKBLConnecting*****");
//    if (_connectBut.selected) {
        [_stateBut setTitle:MtkLocalizedString(@"binging_title") forState:UIControlStateNormal];
        _imageView.hidden = YES;
//    }
}

- (void)MTKBLConnectFinish:(int)state Peripheral:(CBPeripheral *)p{
    NSLog(@"*****MTKBLConnectFinish***** %d",state);
    if (state == 2) {
        [_stateBut setTitle:@"" forState:UIControlStateNormal];
        _imageView.hidden = NO;
        _connectBut.selected = YES;
        MTKUserInfo *user = [MTKArchiveTool getUserInfo];
        if (!user) {
            user = [[MTKUserInfo alloc] init];
            user.userName = @"welcome";
            user.userID = @"1";
            user.userWeigh = @"30";
            user.userHeight = @"50";
            user.userGoal = @"4000";
        }
        user.userUUID = p.identifier.UUIDString;
        [MTKArchiveTool saveUser:user];
//      [_connectBut setTitle:MtkLocalizedString(@"begin_experience") forState:UIControlStateNormal];
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
