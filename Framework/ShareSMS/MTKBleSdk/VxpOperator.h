//
//  VxpOperator.h
//  MTKBleManager
//
//  Created by user on 14/10/29.
//  Copyright (c) 2014年 ___MTK___. All rights reserved.
//
//  VXP looks like an app which can run in the wearable device
//


#import <Foundation/Foundation.h>

const static int VXP_TYPE_NORMAL = 1;

const static int VXP_TYPE_TINY = 2;

@protocol VxpChangeListener <NSObject>

/**
 BLE connection state change
 */
-(void)notifyConnectionStateChange:(int)connectionState;

/**
 Uninstall the VXP from wearable device result callback
 result : 1 success, 0 failed
 name : Vxp name
 code : error code
 */
-(void)notifyUnistallResult:(BOOL)result vxpName:(NSString*)name errorCode:(int)code;

/**
 Uninstall all VXP from wearable device result callback
 result : 1 success, 0 failed
 */
-(void)notifyUnistallAllResult:(BOOL)result;

/**
 While the VXP has been transferd, wearable device should begin to install, while the
 installation finished, should notify the install result to user
 */
-(void)notifyInstallResult:(BOOL)result vxpName:(NSString*)name errorCode:(int)code;

/**
 While send the delete vxp command to wearable device, should return the delete result to user
 */
-(void)notifyDeleteResult:(BOOL)result vxpName:(NSString*)name;

/**
 While transfer the VXP file, should notify the VXP transfer progress which maybe need show it in the UX
 */
-(void)notifyProgressChange:(float)progress;

/**
 Get the VXP list install result
 */
-(void)notifyVxpList:(NSArray*)vxpList resultList:(NSArray*)results;

/**
 Get all VXP information
 */
-(void)notifyAllVxpInformation:(NSArray*)results;

@end


@interface VxpOperator : NSObject

+(id)getInstace;

/******************************************************************************
**
**  Register & unregister change listeners
**
******************************************************************************/
-(void)registerChangeListener:(id<VxpChangeListener>)listener;
-(void)unregisterChangeListener:(id<VxpChangeListener>)listener;

/**
 Install vxp : maybe contains 2 steps, transfer the VXP file to wearble device
 and trigger to install the VXP
 
 vxpName : the VXP name
 data    : The VXP file data which should be transfer to wearable device
 type    : The VXP type which should only be NORMAL & TINY
 
 */
-(void)installVxp:(NSString*)vxpName vxpFileData:(NSData*)data vxpType:(int)type;

/**
 Uninstall VXP : uninstall the VXP
 
 vxpName  : The VXP name
 
 */
-(void)uninstallVxp:(NSString*)vxpName;

/**
 Uninstall all VXP which has been installed in the wearable device
 */
-(void)uninstallAllVxp;

/**
 Get the VXP install status according to the VXP name list
 
 vxpNameList : The vxp name list which want to query
 
 */
-(void)getVxpInstallStatus:(NSArray*)vxpNameList;

/**
 Delete the VXP file while the installation failed
 
 vxpName : vxp name which want to delete
 
 */
-(void)deleteVxp:(NSString*)vxpName;

/**
 Get all VXP information which has been installed in the wearable device
 */
-(void)getAllVxpInformation;


@end
