//
//  MTKLoginViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTKRegisViewController.h"
@interface MTKLoginViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *areaBut, *changPass, *loginBut, *registerBut, *trialBut;
@property (nonatomic, weak) IBOutlet UILabel *areaLab;
@property (nonatomic, weak) IBOutlet UITextField *accountFi, *passwordFi;
@end
