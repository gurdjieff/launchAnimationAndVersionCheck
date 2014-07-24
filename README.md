

This project include two function.
1.Launch animation images
2.App version check and remind automatically

************************************
If you want to add a launch animation for your application, import folder launchAnimation to your project.
You can change images that in the folder.




  add images that you need
    imageNameAry = [[NSMutableArray alloc] init];
    if (heith == 480) {
//        3.5寸的启动图
        [imageNameAry addObject:@"launch1.jpg"];
        [imageNameAry addObject:@"launch2.jpg"];
        [imageNameAry addObject:@"launch3.jpg"];
        [imageNameAry addObject:@"launch4.jpg"];
//        [imageNameAry addObject:@"launch5.jpg"];
    } else {
        //        4.0寸的启动图
        [imageNameAry addObject:@"launch1-568h.jpg"];
        [imageNameAry addObject:@"launch2-568h.jpg"];
        [imageNameAry addObject:@"launch3-568h.jpg"];
        [imageNameAry addObject:@"launch4-568h.jpg"];
        [imageNameAry addObject:@"launch5-568h.jpg"];
    }


add code

Example
 #import "LaunchAnimationView.h"

after  
[self.window makeKeyAndVisible];
[LaunchAnimationView addLaunchAnimationViewImages];
    

************************************
If you want to use version check and update funchtion, import folder versionCheck to your project 
modify #define appNewestInfo and #define appDownLoadUrl to your appliction.

 add code
 Example
 
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [VersionUpdateAssistant updateAppVersionInfomation];
}

it will check version and remind automatically once a day

add code to anywhere you require
Example

-(void)checkBtnClick:(UIButton *)apBtn
{
    [VersionUpdateAssistant checkAppVersionInfomation];
}


