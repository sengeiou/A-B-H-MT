//
//  MTKSportPlanViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/25.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFCircularSlider.h"
@interface MTKSportPlanViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIImageView *sliderView;
@property (nonatomic, weak) IBOutlet UILabel *setLab, *disLab, *setDisLab, *stepLab, *setStepLab, *kcaLab, *setCalLab;
@property (nonatomic, strong) IBOutlet NSLayoutConstraint *backH;
@property (nonatomic,strong) EFCircularSlider* minuteSlider;
@end
