//
//  MTKWebService.h
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACAccountManager.h"
@interface MTKWebService : NSObject
//发送验证码
- (void)acloudSendVerifyCodeWithAccount:(NSString *)account Template:(NSInteger )templat CallBack:(void (^)(NSError *error))callback;
//检测是否存在该用户
- (void)acloudCheckExist:(NSString *)account CallBack:(void (^)(BOOL exist, NSError *NSError))callback;
//注册账号
- (void)acloudRegisterWithPhone:(NSString *)phone Email:(NSString *)email Password:(NSString *)password VerifyCode:(NSString *) verify CallBack:(void (^)(NSString *uid, NSError *error))callback;
//登录
- (void)acloudLoginWithAccount:(NSString *)account Password:(NSString *)password CallBack:(void(^)(ACUserInfo *user,NSError *error))callback;
//修改密码
- (void)acloudResetPassowrdWithAccount:(NSString *)account VerifyCode:(NSString *)verifyCode Password:(NSString *)password CallBack:(void(^)(NSString *uid, NSError *error))callback;
@end
