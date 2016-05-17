//
//  MTKSleepDetailViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/5/17.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKSleepDetailViewController : UIViewController
@property (nonatomic, strong) NSDate *date;
@property(nonatomic,strong) MTKSqliteData *sqliData;
@property (nonatomic, weak) IBOutlet UIView *backView;
@property (nonatomic, weak) IBOutlet UILabel *slTime, *slDeTime, *wakeTime, *wakeDeTime, *awakeTime, *awakeDeTime, *slLenght, *slDeLenght, *deLenght, *deDeLenght, *liLenght, *liDeLenght;
@end
