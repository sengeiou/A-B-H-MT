//
//  SmaQuietTableCell.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol smaHRcelllDelegate<NSObject>
@optional
- (void)addQuiet;
@end
@interface SmaQuietTableCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *textLab;
@property (nonatomic, strong) IBOutlet UILabel *subtiLab;
@property (nonatomic, strong) IBOutlet UIButton *addBut;
@property (nonatomic, weak) id<smaHRcelllDelegate> delegate;
- (IBAction)AddSelector:(id)sender;
@end
