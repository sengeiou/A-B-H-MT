//
//  SmaQuietViewController.h
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmaQuietTableCell.h"
#import "SmaQuietView.h"
@interface SmaQuietViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,smaHRcelllDelegate,smaQuietViewDelegate>
{
    IBOutlet UILabel *remindLab;
    IBOutlet UITableView *tableview;
    SmaQuietView *quietView;
    NSMutableArray *QuietDataArr;
    NSDateFormatter *fmt;
    int selectIdx;
}
@end
