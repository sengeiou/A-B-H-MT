//
//  MTKTabBar.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/22.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTKTabBar;
@protocol MTKTabBarDelegate <NSObject>

@optional
- (void)tabBar:(MTKTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
- (void)tabBarDidClickedPlusButton:(MTKTabBar *)tabBar;

@end

@interface MTKTabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<MTKTabBarDelegate> delegate;

@end
