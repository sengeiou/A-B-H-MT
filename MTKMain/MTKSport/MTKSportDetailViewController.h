//
//  MTKSportDetailViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/16.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBChartView.h"
@interface MTKSportDetailViewController : UIViewController
@property (nonatomic, strong) CBChartView *charView;
@property (nonatomic, strong) NSDate *date;
@property(nonatomic,strong) MTKSqliteData *sqliData;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UILabel *goalLab, *goalStepLab, *steUnitLab, *disLab, *setDisLab, *stepLab, *setStepLab, *calLab, *setCalLab;
@property (nonatomic, weak) IBOutlet UISegmentedControl *actualTypeValue;
@end
