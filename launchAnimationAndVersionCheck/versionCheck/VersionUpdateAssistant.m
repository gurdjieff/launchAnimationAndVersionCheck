//
//  VersionUpdateAssistant.m
//  launchAnimationAndVersionCheck
//
//  Created by gurd102 on 14-7-24.
//  Copyright (c) 2014年 gurd102. All rights reserved.
//

#import "VersionUpdateAssistant.h"
#import "NSDate+Ext.h"
#import "NSString+Ext.h"
@interface VersionUpdateAssistant()
<NSURLConnectionDataDelegate>
{
    NSMutableDictionary * appVersionInfo;
    NSOperationQueue * operationQueue;
    int newestUpdateDay;
	NSMutableData * responseData;
    NSURLConnection * connection;
}
@end

@implementation VersionUpdateAssistant
+(id)sharedTaskAssistant
{
    static VersionUpdateAssistant * instance = nil;
    if (instance == nil) {
        instance = [[VersionUpdateAssistant alloc] init];
    }
    return instance;
}

-(id)init
{
    if ((self = [super init])) {
        responseData = [[NSMutableData alloc] init];
        operationQueue = [[NSOperationQueue alloc] init];
        [operationQueue setMaxConcurrentOperationCount:1];
        appVersionInfo = [[NSMutableDictionary alloc] init];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [defaults objectForKey:@"appVersionInfo"];
        if (dic) {
            [appVersionInfo setDictionary:dic];
        }
    }
    return self;
}

+(void)checkAppVersionInfomation
{
    [[VersionUpdateAssistant sharedTaskAssistant] checkAppVersionInfomation];
    
}

-(void)checkAppVersionInfomation
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleVersion"];
    //新版本号
    NSString * newVersion = [appVersionInfo objectForKey:@"version"];
    float newVersionValue = [newVersion floatValue];
    float currentVersionValue = [currentVersion floatValue];
    
    NSString * releaseNotes = [appVersionInfo objectForKey:@"releaseNotes"];
    
    if (newVersion && ![currentVersion isEqualToString:newVersion]
        && newVersionValue > currentVersionValue) {
        //有新版本。
        NSString * lpStr = [NSString stringWithFormat:@"版本:%@\n%@", newVersion, releaseNotes];
        UIAlertView* lpAlert=[[UIAlertView alloc] initWithTitle:@"发现新版本!"
                                                        message:lpStr
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"立即升级",@"稍后升级", nil];
        lpAlert.tag=200;
        [lpAlert show];
    } else {
        //没有新版本。
        UIAlertView* lpAlert=[[UIAlertView alloc] initWithTitle:nil
                                                        message:@"已经是最新版本"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [lpAlert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appDownLoadUrl]];
        } else if (buttonIndex == 1) {
            
        }
    }
}

+(void)updateAppVersionInfomation
{
    [[VersionUpdateAssistant sharedTaskAssistant] updateAppVersionInfomation];
}

-(void)updateAppVersionInfomation
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:@"updateVersionDate"] isEqualToString:[NSDate getCurrentDate]]) {
        return;
    }
    
    NSURL * url = [NSURL URLWithString:appNewestInfo];
	NSURLRequest * request = [NSURLRequest requestWithURL:url
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
    
	connection = [[NSURLConnection alloc]
     initWithRequest:request
     delegate:self];
    
	[responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection
	 didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSDate getCurrentDate] forKey:@"updateVersionDate"];
    [userDefault synchronize];
    
    NSError * error = nil;
    id date =  [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"%@", error);
    }
    
    
    if (![date isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    if (date[@"results"]) {
        NSString *version = @"";
        NSString *releaseNotes = @"";
        NSDictionary * lpDic = [NSDictionary dictionaryWithDictionary:date];
        NSArray *resultsData = [lpDic valueForKey:@"results"];
        for (id result in resultsData) {
            version = [result valueForKey:@"version"];
            releaseNotes = [result valueForKey:@"releaseNotes"];
            if (version) {
                break;
            }
        }
        if (version == nil || releaseNotes == nil) {
            return;
        }
        
        [appVersionInfo setValue:version forKey:@"version"];
        [appVersionInfo setValue:releaseNotes forKey:@"releaseNotes"];
        [self storeInfomation];
        
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//        float newVersionValue = [version floatValue];
//        float currentVersionValue = [appVersion floatValue];
        if (![version isEqualToString:appVersion]
//            && newVersionValue > currentVersionValue
            ) {
            NSString * lpStr = [NSString stringWithFormat:@"版本:%@\n%@", version, releaseNotes];
            UIAlertView *lpAlertView = [[UIAlertView alloc] initWithTitle:@"发现新版本" message: lpStr delegate:self cancelButtonTitle:nil otherButtonTitles: @"立即升级",@"稍后升级", nil];
            [lpAlertView show];
            lpAlertView.delegate = self;
            lpAlertView.tag = 200;
        }
    }
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

-(void)storeInfomation
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appVersionInfo forKey:@"appVersionInfo"];
    [defaults synchronize];
}


-(void)dealloc{
}

@end
