//
//  VersionUpdateAssistant.h
//  launchAnimationAndVersionCheck
//
//  Created by gurd102 on 14-7-24.
//  Copyright (c) 2014年 gurd102. All rights reserved.
//

#import <Foundation/Foundation.h>

#define appNewestInfo @"http://itunes.apple.com/lookup?id=880603232"
#define appDownLoadUrl @"https://itunes.apple.com/us/app/sui-xing-fu-shang-hu-ke-hu-duan/id880603232?ls=1&mt=8"
@interface VersionUpdateAssistant : NSObject
+(void)updateAppVersionInfomation;
+(void)checkAppVersionInfomation;
@end
