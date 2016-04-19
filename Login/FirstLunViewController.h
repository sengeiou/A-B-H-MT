//
//  FirstLunViewController.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLunViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    IBOutlet NSLayoutConstraint *lunCollW;
}
@property (nonatomic, weak) IBOutlet UIScrollView *lunScroll;
@property (nonatomic, weak) IBOutlet UICollectionView *lunColl;
@end
