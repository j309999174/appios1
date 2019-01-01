//
//  appios1-Bridging-Header.h
//  appios1
//
//  Created by j309999174 on 2018/12/7.
//  Copyright © 2018 j309999174. All rights reserved.
//

#ifndef appios1_Bridging_Header_h
#define appios1_Bridging_Header_h


#endif /* appios1_Bridging_Header_h */

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
