//
//  MTKLocalized.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/18.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKLocalized.h"

@implementation MTKLocalized
+(NSString *)DPLocalizedString:(NSString *)translation_key{
    NSString *s = NSLocalizedString(translation_key, nil);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLan = [[allLanguages objectAtIndex:0] substringToIndex:2];
    if (![preferredLan isEqualToString:@"zh"] && ![preferredLan isEqualToString:@"es"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle *languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    return s;
}
@end
