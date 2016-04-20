//
//  MTKWebService.m
//  MTK
//
//  Created by 有限公司 深圳市 on 16/4/20.
//  Copyright © 2016年 SmaLife. All rights reserved.
//

#import "MTKWebService.h"
#define servicename @"mywatch"
#define service @"watch"
@implementation MTKWebService
static  NSInteger versionInteger = 3;//1为正式环境，3测试环境
//发送验证码
- (void)acloudSendVerifyCodeWithAccount:(NSString *)account Template:(NSInteger )templat CallBack:(void (^)(NSError *error))callback{
    [ACAccountManager sendVerifyCodeWithAccount:account template:templat callback:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

//检测是否存在该用户
- (void)acloudCheckExist:(NSString *)account CallBack:(void (^)(BOOL exist, NSError *NSError))callback{
    [ACAccountManager checkExist:account callback:^(BOOL exist, NSError *error) {
        if (callback) {
            callback(exist,error);
        }
    }];
}

//注册账号
- (void)acloudRegisterWithPhone:(NSString *)phone Email:(NSString *)email Password:(NSString *)password VerifyCode:(NSString *) verify CallBack:(void (^)(NSString *uid, NSError *error))callback{
    [ACAccountManager registerWithPhone:phone email:email password:password verifyCode:verify callback:^(NSString *uid, NSError *error) {
        if (callback) {
            callback(uid,error);
        }
    }];
}

//登录
- (void)acloudLoginWithAccount:(NSString *)account Password:(NSString *)password CallBack:(void(^)(ACUserInfo *user,NSError *error))callback{
   [ACAccountManager loginWithUserInfo:account password:password callback:^(ACUserInfo *user, NSError *error) {
       if (callback) {
           callback(user,error);
       }
   }];
}

//修改密码
- (void)acloudResetPassowrdWithAccount:(NSString *)account VerifyCode:(NSString *)verifyCode Password:(NSString *)password CallBack:(void(^)(NSString *uid, NSError *error))callback{
    [ACAccountManager resetPasswordWithAccount:account verifyCode:verifyCode password:password callback:^(NSString *uid, NSError *error) {
        if (callback) {
            callback(uid, error);
        }
    }];
}


@end
