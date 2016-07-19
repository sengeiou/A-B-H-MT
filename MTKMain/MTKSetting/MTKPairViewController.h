//
//  MTKPairViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKPairViewController : UIViewController
@property (nonatomic, weak) IBOutlet UILabel *headLab, *headLab1;
@property (nonatomic, weak) IBOutlet UIButton *searchBut, *unpairBut;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
