//
//  AppDelegate.m
//  SIXRichEditor
//
//  Created by  on 2018/7/29.
//  Copyright © 2018年 liujiliu. All rights reserved.
//

#import "AppDelegate.h"
#import "DNavigationController.h"
#import "DHomeViewController.h"
#import "DWLaunchScreen.h"
#import "EasyLoadingGlobalConfig.h"

@interface AppDelegate ()<DWLaunchScreenDelegate>

@end

@implementation AppDelegate

//完成了启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = [[DNavigationController alloc] initWithRootViewController:[DHomeViewController new]];
    [self.window makeKeyAndVisible];
    
    if (![DataManager getDataKey:kHomeAnimation]) {
        [DataManager setDataKey:kHomeAnimation];
        [self judgePage];
    }
    
    NSArray *languages = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppleLanguages"];
    NSString *currentLanguage = languages.firstObject;
    NSLog(@"模拟器当前语言=======：%@",currentLanguage);
    
    /**显示加载框**/
    EasyLoadingGlobalConfig *LoadingConfig = [EasyLoadingGlobalConfig shared];
    LoadingConfig.LoadingType = LoadingAnimationTypeFade ;
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 9; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%d",i+1]];
        [tempArr addObject:img] ;
    }
    LoadingConfig.playImagesArray = tempArr ;
    
    return YES;
}
-(void)judgePage{
    DWLaunchScreen *launch = [[DWLaunchScreen alloc] init];
    
    //设置代理，只有图片格式需要点击时才需设置
    launch.delegate = self;
    launch.skipTimerHide = YES;
    //消失方式
    launch.disappearType = DWNarrow;
    //是否
    launch.skipHide = YES;
    
    //网络时的渲染图，建议与启动图相同
    launch.logoImage = [UIImage imageNamed:@"bg.jpg"];
    [launch dw_LaunchScreenContent:@"过场动画.gif" window:self.window withError:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    NSLog(@"=========%@",url);
    NSLog(@"==========%@",annotation);
    NSLog(@"========%@",[url absoluteString]);
    
    NSString* prefix = @"NebulaiOSWidgetApp://action=";
    if ([[url absoluteString] rangeOfString:prefix].location != NSNotFound) {
        NSString* action = [[url absoluteString] substringFromIndex:prefix.length];
        if ([action isEqualToString:@"openAPP"]) {
            //打开APP
        }
        else if([action containsString:@"openNewsID="]) {
            NSString *IDString = [action substringFromIndex:@"openNewsID=".length];
            NSMutableDictionary * pushObj = [NSMutableDictionary dictionary];
            pushObj[@"openNewsID"]   = IDString;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NebulaWidget" object:pushObj];
            
            
        }
    }
    
    return  YES;
    
}
@end
