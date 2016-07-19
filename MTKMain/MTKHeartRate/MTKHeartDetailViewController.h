//
//  MTKHeartDetailViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/6/15.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTKHeartLab.h"
#import "MTKHRHisTableViewCell.h"
@interface MTKHeartDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) IBOutlet MTKHeartLab *hearLab;
@property (nonatomic, weak) IBOutlet UILabel *hrLab, *surveyLab, *normLab, *hisLab, *timeLab, *heTexLab, *typeLab;
@property (nonatomic, weak) IBOutlet UITableView *hisTabView;
@property (nonatomic, strong) NSDate *date;
@property(nonatomic,strong) MTKSqliteData *sqliData;
@end
