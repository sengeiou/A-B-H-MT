//
//  MyController.m
//  Mediatek SmartDevice
//
//  Created by kct on 15/6/8.
//  Copyright (c) 2015年 Mediatek. All rights reserved.
//

#import "MyController.h"
static NSString *const CONTROLLER_TAG = @"SOSCallControllerTag";

@implementation MyController
@synthesize delegate;

static  MyController *instance;
//加载dal对象
-(MTKSqliteData *)sqliData
{
    if(!_sqliData)
    {
        _sqliData=[[MTKSqliteData alloc]init];
    }
    return _sqliData;
}

+(id)getMyControllerInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MyController alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init: CONTROLLER_TAG cmdtype: 9];
    if (self) {
        NSArray *tagArr = @[@"kct_pedometer"];
        
        [self setReceiversTags:tagArr];
        
        [[ControllerManager getControllerManagerInstance] addController: self];
        
        //1.音频文件的url路径
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"Alarm.mp3" withExtension:Nil];
        
        //2.实例化播放器
        _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
        _player.volume = 1.0;
        //3.缓冲
        [_player prepareToPlay];
         [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
        [self getSystemVolumSlider];
    } return self;
}

- (UISlider*)getSystemVolumSlider{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                volumeViewSlider.value = 10.0;
                break;
            }
        }
    }
    
    return volumeViewSlider;
}

- (void)sendDataWithCmd:(NSString *)cmd mode:(MTKBLEMEDO)mode{
    self.mode = mode;
    NSData *data =[cmd dataUsingEncoding:NSUTF8StringEncoding];
    if ([BackgroundManager sharedInstance].canSendData) {
        NSLog(@"*******************************************允许进行数据传输");
        [self sendSOSCAllCMD:[NSString stringWithFormat:@"KCT_PEDOMETER kct_pedometer 0 0 %lu ",(unsigned long)data.length] sendData:data];
    }
}

- (void)sendSOSCAllCMD: (NSString *)cmdHeader sendData: (NSData *)data {
    NSLog(@"[SOSCallController]sendSOSCAllCMD ++, cmdHeader = %@", cmdHeader);
    Byte *byte = (Byte *)[data bytes];
    for (int i = 0; i < data.length; i ++) {
        NSLog(@"[SOSCallController]sendSOSCAllCMD::data[%d] = 0x%02x", i, byte[i]);
    }
    [super send: cmdHeader data: data response: YES progress: NO priority: 0];
}

- (void)onReceive: (NSData *)recvData {
    NSLog(@"[SOSCallController]onReceiver::onRecvData ++");
    if (recvData == nil || recvData.length == 0)
    { NSLog(@"[SOSCallController][onReceive] data is WRONG");
        return;
    }
    NSString* str = [[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
    if (str == nil || str.length == 0) {
        NSLog(@"[SOSCallController][onReceive] str is nil or length is 0");
        return;
    }
    NSArray* array = [str componentsSeparatedByString:@" "];
    if (array == nil || [array count] == 0) {
        NSLog(@"[SOSCallController][onReceive] array is WRONG");
        return;
    }
    [self parsingMTKData:str];
//    [self sendDataWithCmd:@"RET,0"];
   
    
}

- (void)onConnectStateChange: (int)state {
    NSLog(@"[SOSCallController]onConnectStateChange ++, state = %d", state);
     if (delegate && [delegate respondsToSelector:@selector(onConnectStateChange:)]) {
         [delegate onConnectStateChange: state];
     }
    return;
}

- (void)parsingMTKData:(NSString *)dataStr{
    NSLog(@"*****************************数据解析***************************\n%@",dataStr);
    MTKUserInfo *user = [MTKArchiveTool getUserInfo];
    NSArray *dataArr = [dataStr componentsSeparatedByString:@","];
    NSString *dataFir = dataArr[0];
    NSString *mode = [dataFir substringWithRange:NSMakeRange(dataFir.length-3, 3)];
    if ([dataArr[1] intValue] == 0 && [mode isEqualToString:@"GET"]) {
        NSLog(@"MTK设备信息反馈**%@",dataArr);
        user.userBLName = [NSString stringWithFormat:@"%@",dataArr[2]];
        user.userBLVersion = [NSString stringWithFormat:@"%@",dataArr[3]];
        [MTKArchiveTool saveUser:user];
    }
    else if ([dataArr[1] isEqualToString:@"RET"] && [mode isEqualToString:@" PS"]){
        NSLog(@"MTK个人信息设置反馈");
            if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
             
            [delegate onDataReceive:dataStr mode:SETUSERINFO];
        }
    }
    else if ([dataArr[1] isEqualToString:@"GET"] && [mode isEqualToString:@" PS"]){
        NSLog(@"MTK获取个人信息");
        NSArray *infoArr = [dataArr[2] componentsSeparatedByString:@"|"];
        user.userGoal = [NSString stringWithFormat:@"%d",([infoArr[0] intValue]-4000)/500];
        user.userHeight = infoArr[1];
        user.userWeigh = infoArr[2];
        [MTKArchiveTool saveUser:user];
        if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
            [delegate onDataReceive:dataStr mode:GETUSERINFO];
        }
    }
    else if ([dataArr[1] isEqualToString:@"2"] && [mode isEqualToString:@"GET"]){
        NSLog(@"MTK运动数据返回");
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
        for (int i = 2; i<dataArr.count; i ++) {
            NSArray *spDataArr = [dataArr[i] componentsSeparatedByString:@"|"];
            NSDate *sportDate = [formatter dateFromString:spDataArr[0]];
            NSString *userID = user.userID;
            NSString *webID = [formatter1 stringFromDate:sportDate];
            NSString *date = [[formatter1 stringFromDate:sportDate] substringToIndex:8];
            NSString *time = [[formatter1 stringFromDate:sportDate] substringWithRange:NSMakeRange(8, 2)];
            NSString *dis = [NSString stringWithFormat:@"%.1f",[spDataArr[2] floatValue]/10.0];
             NSString *cal = [NSString stringWithFormat:@"%.1f",[spDataArr[3] floatValue]/10.0];
            [self.sqliData inserSportDateWithUser:userID WebId:webID Date:date Time:time Step:spDataArr[1] Distance:dis Calory:cal Web:@"0" callBack:^(BOOL result) {
                if (i == dataArr.count-1) {
                    if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                        [delegate onDataReceive:dataStr mode:GETSDETSPORT];
                    }
                    [self sendDataWithCmd:@"RET,2" mode:RETSPORT];
                }
            }];
        }
        if (dataArr.count < 3) {
            if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                [delegate onDataReceive:dataStr mode:GETSDETSPORT];
            }
            [self sendDataWithCmd:@"RET,2" mode:RETSPORT];
        }
    }
    else if ([dataArr[1] isEqualToString:@"3"] && [mode isEqualToString:@"GET"]){
        NSLog(@"MTK睡眠数据返回");
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
        [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
        for (int i = 2; i<dataArr.count; i ++) {
            NSArray *spDataArr = [dataArr[i] componentsSeparatedByString:@"|"];
            NSDate *sportDate = [formatter dateFromString:spDataArr[0]];
            NSString *userID = user.userID;
            NSString *webID = [formatter1 stringFromDate:sportDate];
            NSString *date = [[formatter1 stringFromDate:sportDate] substringToIndex:8];
            NSString *time = [[formatter1 stringFromDate:sportDate] substringFromIndex:8];
            NSString *step = spDataArr[1];
            NSString *qual = spDataArr[2];
//            [self.sqliData inserSleepDataWithUser:userID WebId:webID Date:date Time:time Step:step Quality:qual Web:@"0"  callBack:^(BOOL result) {
//                if (i == dataArr.count-1) {
//                    if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
//                        [delegate onDataReceive:dataStr mode:GETSDETSLEEP];
//                    }
//                    [self sendDataWithCmd:@"RET,3" mode:RETSPORT];
//                }
//            }];
        }
        if (dataArr.count < 3) {
            if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                [delegate onDataReceive:dataStr mode:GETSDETSLEEP];
            }
            [self sendDataWithCmd:@"RET,3" mode:RETSLEEP];
        }
    }
    else if ([dataArr[1] isEqualToString:@"4"] && [mode isEqualToString:@"GET"]){
        NSLog(@"MTK心率数据返回");
        if (dataArr.count < 3) {
            if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                [delegate onDataReceive:dataStr mode:GETSDETHEART];
            }
//            [self sendDataWithCmd:@"RET,4" mode:RETHEART];
        }
    }

     else if ([dataArr[1] isEqualToString:@"1"] && [mode isEqualToString:@"GET"]){
         NSLog(@"MTK数据返回");
         NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
         [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
         NSDateFormatter * formatter1 = [[NSDateFormatter alloc]init];
         [formatter1 setDateFormat:@"yyyyMMddHHmmss"];
         NSDateFormatter * formatter2 = [[NSDateFormatter alloc]init];
         [formatter2 setDateFormat:@"yyyyMMdd"];
         int heartNum = 0;
         int nowNum = 0;
         for (int i = 2; i<dataArr.count; i ++) {
             NSArray *spDataArr = [dataArr[i] componentsSeparatedByString:@"|"];
            if ([spDataArr[0] intValue] == 3) {
                heartNum ++;
             }
         }
         for (int i = 2; i<dataArr.count; i ++) {
             NSArray *spDataArr = [dataArr[i] componentsSeparatedByString:@"|"];
             if ([spDataArr[0] intValue] == 1) {
                 nowNum ++;
                 NSDate *sportDate = [formatter dateFromString:spDataArr[1]];
                 NSString *userID = user.userID;
                 NSString *webID = [formatter1 stringFromDate:sportDate];
                 NSString *date = [[formatter1 stringFromDate:sportDate] substringToIndex:8];
                 NSString *time = [[formatter1 stringFromDate:sportDate] substringFromIndex:8];
                 NSInteger chcekTime = [self returnSeconds:time];
                 NSString *sleep_time = spDataArr[2];
                 NSString *step = spDataArr[3];
                 NSString *qual = spDataArr[4];
                 if (chcekTime + sleep_time.integerValue > 86400) {
                  NSString *lastSlTime = [NSString stringWithFormat:@"%d",86400 - chcekTime];
                [self.sqliData inserSleepDataWithUser:userID WebId:webID Date:date Time:time sleepTime:lastSlTime Step:step Quality:qual Web:@"0" callBack:^(BOOL result) {
                     }];
                  NSDate *nextDate = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[formatter2 dateFromString:date]];
                     webID = [formatter1 stringFromDate:nextDate];
                     date = [[formatter1 stringFromDate:nextDate] substringToIndex:8];
                     time = [[formatter1 stringFromDate:nextDate] substringFromIndex:8];
                     sleep_time = [NSString stringWithFormat:@"%d",sleep_time.integerValue - lastSlTime.integerValue];
//                  NSString *lastSlTime = [NSString stringWithFormat:@""];
                 }
                 [self.sqliData inserSleepDataWithUser:userID WebId:webID Date:date Time:time sleepTime:sleep_time Step:step Quality:qual Web:@"0" callBack:^(BOOL result) {
                     if (i == dataArr.count-1) {
                         if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                             [delegate onDataReceive:dataStr mode:GETSDETSPORT];
                         }
                          [self sendDataWithCmd:@"RET,1" mode:RETDATA];
                     }

                 }];
             }

             if ([spDataArr[0] intValue] == 3) {
                 nowNum ++;
                 NSDate *sportDate = [formatter dateFromString:spDataArr[1]];
                 NSString *userID = user.userID;
                 NSString *webID = [formatter1 stringFromDate:sportDate];
                 NSString *date = [[formatter1 stringFromDate:sportDate] substringToIndex:8];
                 NSString *time = [[formatter1 stringFromDate:sportDate] substringFromIndex:8];
                 NSString *hear = spDataArr[2];
               [self.sqliData inserHeartDataWithUser:userID webID:webID Date:date Time:time HeartRate:hear Continuous:@"2" Web:@"0" callBack:^(BOOL result) {
                   if (i == dataArr.count-1) {
                       if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                           [delegate onDataReceive:dataStr mode:GETSDETDATA];
                           [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"HKHealthNot" object:nil userInfo:nil]];
                       }
                        [self sendDataWithCmd:@"RET,1" mode:RETDATA];
                   }
               }];
             }
        }
         if (nowNum == 0) {
             if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
                 [delegate onDataReceive:dataStr mode:GETSDETDATA];
                 [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"HKHealthNot" object:nil userInfo:nil]];
             }
             [self sendDataWithCmd:@"RET,1" mode:RETDATA];
         }
     }
     else if ([dataArr[1] isEqualToString:@"SET"] && [mode isEqualToString:@" PS"]){
         NSLog(@"MTK个人信息自主返回");
         NSArray *infoArr = [dataArr[2] componentsSeparatedByString:@"|"];
         user.userGoal = [NSString stringWithFormat:@"%d",([infoArr[0] intValue]-4000)/500];
         user.userHeight = infoArr[1];
         user.userWeigh = infoArr[2];
         [MTKArchiveTool saveUser:user];
         if (delegate && [delegate respondsToSelector:@selector(onDataReceive:mode:)]) {
             [delegate onDataReceive:dataStr mode:GETUSERINFO];
         }

     }
    else if ([dataArr[1] isEqualToString:@"40"] && [mode isEqualToString:@"SET"]){
        if ([dataArr[2] isEqualToString:@"1"]) {
            [self getSystemVolumSlider].value = 1.0f;
            [_player play];
        }
        else{
            [_player stop];
        }
    }
}

- (NSInteger)returnSeconds:(NSString *)time{
    
    return [[time substringToIndex:2] intValue]*3600 + [time substringWithRange:NSMakeRange(2, 2)].intValue*60 + [time substringFromIndex:4].intValue;
}
@end
