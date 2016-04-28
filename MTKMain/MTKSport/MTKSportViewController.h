//
//  MTKSportViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KAProgressLabel;
@interface MTKSportViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *dateLab, *goalLab, *goalStepLab, *steUnitLab, *disLab, *setDisLab, *stepLab, *setStepLab, *calLab, *setCalLab;
@property (nonatomic, weak) IBOutlet KAProgressLabel *progressLab;
@property (nonatomic, weak) IBOutlet UIButton *leftBut, *rightBut;
@property (nonatomic,strong) NSDate *data;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backH;
@property(nonatomic,strong) MTKSqliteData *sqliData;
@end
