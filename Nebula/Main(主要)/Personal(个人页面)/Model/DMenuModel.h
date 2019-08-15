//
//  DMenuModel.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/28.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define modelAString Localized(@"Personal0")
#define modelBString Localized(@"Personal1")
#define modelCString Localized(@"Personal2")
#define modelDString Localized(@"Personal3") 
#define modelEString @""
#define modelFString @""

@interface DMenuModel : NSObject


@property(nonatomic,strong) NSString*title;
@property(nonatomic,strong) UIColor *color;
@property(nonatomic,strong) UIImage *ico;


@end
NS_ASSUME_NONNULL_END
