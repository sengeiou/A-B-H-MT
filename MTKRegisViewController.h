//
//  MTKRegisViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTKRegisViewController : UIViewController
@property (nonatomic, weak) IBOutlet UIButton *areaBut, *codeBut, *regisBut;
@property (nonatomic, weak) IBOutlet UITextField *accountFi, *passFi, *agaPassFi, *verificFi;
@property (nonatomic, weak) IBOutlet UILabel *areaLab;
@end
