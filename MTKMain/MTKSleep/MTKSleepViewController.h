//
//  MTKSleepViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKSleepViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *dateLab, *hourLab, *hourUnLab, *minLab, *minUnLab, *lastSlLab, *situationLab, *qualityLab, *deepLab, *deepTiLab, *lightLab, *lightTiLab, *soberLab, *soberTiLab;
@property (nonatomic, weak) IBOutlet UIButton *leftBut, *rightBut;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *hourLead;
@property (nonatomic,strong) NSDate *data;
@property(nonatomic,strong) MTKSqliteData *sqliData;

@end
