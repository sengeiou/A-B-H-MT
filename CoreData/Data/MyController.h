//
//  MyController.h
//  Mediatek SmartDevice
//
//  Created by kct on 15/6/8.
//  Copyright (c) 2015年 Mediatek. All rights reserved.
//

#import "Controller.h"
#import "ControllerManager.h"
#import "MTKSqliteData.h"
#define GETSYSTEM @"GET,0" //获取系统资料（可做是否连接正常和心跳检测作用）
#define GETDESPORT @"GET,2" //获取运动详细数据（以半小时为节点）
//#define SETUSER   @"PS,SET,DATAS" //设置个人信息
//typedef enum {
//    AWAIT_RECEVER1=0,//等待接收
//    ALREADY_RECEVER1=1,
//    VERIFT_RECEVER1=2
//}RECEVER_STATUS_TYPE1;

typedef enum {
    GETMTKINFO = 0, //等待接收
    GETUSERINFO,    //获取个人信息
    GETSDETSPORT,   //获取详细运动数据
    SETUSERINFO,    //设置用户信息
    RETSPORT,       //运动数据响应
}MTKBLEMEDO;


@protocol myProtocol;

@interface MyController : Controller
{
    id<myProtocol> delegate;
}
@property(nonatomic,strong) id<myProtocol>delegate;
@property(nonatomic,assign) MTKBLEMEDO mode;
@property(nonatomic,strong) MTKSqliteData *sqliData;

+(id)getMyControllerInstance;
- (void)sendSOSCAllCMD: (NSString *)cmdHeader sendData: (NSData *)data;
- (void)onReceive: (NSData *)recvData;
- (void)onConnectStateChange: (int)state;

- (void)sendDataWithCmd:(NSString *)cmd mode:(MTKBLEMEDO)mode;
@end


@protocol myProtocol<NSObject>

- (void)onDataReceive:(NSString *)recvData mode:(MTKBLEMEDO)mode;

- (void)onConnectStateChange:(int)state;


@end
