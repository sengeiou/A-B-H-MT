//
//  MTKSettingViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTKPairViewController.h"
#import "MTKBleManager.h"
@interface MTKSettingViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView *headView;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet UITableView *setTab;
@end
