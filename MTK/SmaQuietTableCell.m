//
//  SmaQuietTableCell.m
//  SmaLife
//
//  Created by 有限公司 深圳市 on 15/12/7.
//  Copyright © 2015年 SmaLife. All rights reserved.
//

#import "SmaQuietTableCell.h"

@implementation SmaQuietTableCell

- (void)awakeFromNib {
    // Initialization code
//    self.contentView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)AddSelector:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addQuiet)]) {
        [self.delegate addQuiet];
    }
}
@end
