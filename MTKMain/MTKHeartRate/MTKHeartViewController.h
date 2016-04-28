//
//  MTKHeartViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/27.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKHeartViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *dateLab, *heartLab, *hearUnLab, *lastTexLab, *situationLab, *stateLab, *quietLab, *quietSetLab, *avgLab, *avgSetLab, *maxLab, *maxSetLab;
@property (nonatomic,weak) IBOutlet UIView *HRView;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *heartLead;
@property (nonatomic, weak) IBOutlet UIButton *leftBut, *rightBut, *detailBut;
@property (nonatomic,strong) NSDate *data;
@property(nonatomic,strong) MTKSqliteData *sqliData;
@end
