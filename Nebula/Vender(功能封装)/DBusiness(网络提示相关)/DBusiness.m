//
//  DBusiness.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/25.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DBusiness.h"


@implementation DBusiness

static DBusiness *sharedObj = nil;
+ (DBusiness*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+(void)yp_checkoutUpdateAppVersion{
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appStoreAppID];
   
    [DBusiness networkRequestURL:url parameters:nil successful:^(NSDictionary * _Nonnull responseObject) {
        
        NSArray *resultsArr = responseObject[@"results"];
        NSDictionary *dict = [resultsArr lastObject];
        
        /**  得到AppStore的应用的版本信息*/
        NSString *appStoreCurrentVersion = dict[@"version"];
        /**  获取当前安装的应用的版本信息*/
        NSString *appCurrentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        if ([appCurrentVersion compare:appStoreCurrentVersion options:NSNumericSearch] == NSOrderedAscending){//有更新版本，需要提示前往更新
          
            NSString*description=dict[@"description"];;
            [DBusiness upgradePop:[NSString stringWithFormat:@"%@(%@)\n%@", Localized(@"Popout2"),appStoreCurrentVersion,description]];
            
         
        }else{//没有更新版本，不进行操作
            NSLog(@"当前为最新版本");
        }
        
        
        
        
    } failure:nil];
    
}
/**
 * 升级提示
 */
+(void)upgradePop:(NSString*)description{
    DPopModel*model=[DPopModel new];
    model.popContent=description;
    model.iconImage=ImageNamed(@"升级提示图");
    model.popImage =ImageNamed(@"新版本图");
    model.popStyle=DAnimationPopStyleCardDropFromLeft;
    model.dismissStyle=DAnimationDismissStyleCardDropToTop;
    model.buttonColor=RecommendedColor;
    model.buttonTitle=Localized(@"Popout1");
    
    DPopManager*alertView=[[DPopManager alloc] initWithPopModel:model];
    alertView.isClickBGDismiss = YES;
    alertView.insideBlock = ^{
        NSString *updateUrlString = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8",appStoreAppID];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrlString]];
        
    };
    
    // 4.显示弹框
    [alertView pop];
}

/**
 * 任务删除提示
 */
+(void)homeDeletePop:(NSString*)description successful:(NetWorkSuccBlock )successful{
    DPopModel*model=[DPopModel new];
    model.popContent=description;
    model.iconImage=ImageNamed(@"删除提示");
    model.popImage =ImageNamed(@"新版本图");
    model.popStyle=DAnimationPopStyleCardDropFromLeft;
    model.dismissStyle=DAnimationDismissStyleCardDropToTop;
    model.buttonColor=DangerousColor;
    model.buttonTitle=Localized(@"Home4");
    
    DPopManager*alertView=[[DPopManager alloc] initWithPopModel:model];
    alertView.isClickBGDismiss = YES;
    alertView.insideBlock = ^{
        successful(nil);
    };
    
    // 4.显示弹框
    [alertView pop];
    
}
/**
 * 评价提示
 */
+(void)evaluationPop:(NSString*)description failure:(NetWorkErrorBlock)failure{
    DPopModel*model=[DPopModel new];
    model.popContent=description;
    model.iconImage=ImageNamed(@"评价提示");
    model.popImage =ImageNamed(@"新版本图");
    model.popStyle=DAnimationPopStyleCardDropFromLeft;
    model.dismissStyle=DAnimationDismissStyleCardDropToTop;
    model.buttonColor=RecommendedColor;
    model.buttonTitle=Localized(@"Popout4");
    
    DPopManager*alertView=[[DPopManager alloc] initWithPopModel:model];
    alertView.isClickBGDismiss = YES;
    alertView.insideBlock = ^{
                [DataManager setDataKey:KAPPComments];
                NSString *itunesurl = @"itms-apps://itunes.apple.com/cn/app/id1185429183?mt=8&action=write-review";[[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
    };
    alertView.dismissComplete = ^{
         failure(nil);
    };
    // 4.显示弹框
    [alertView pop];
    
    
    
}


/**
 * 网络请求
 */
+(void)networkRequestURL:(NSString*)url parameters:(id)parameters successful:(NetWorkSuccBlock )successful failure:(NetWorkErrorBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successful) {
          successful(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
       
    }];
    
}





@end
