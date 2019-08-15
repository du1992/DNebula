//
//  DMusicPlayer.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface DMusicModel : NSObject


/**标题**/
@property (nonatomic,strong) NSString *musicTitle;
/**描述**/
@property (nonatomic,strong) NSString *musicDescribe;
/**封面**/
@property (nonatomic,strong) NSString *musicCover;
/**类型**/
@property (nonatomic,strong) NSString *ofType;



@end



@interface DMusicPlayer : NSObject
/**
 *  初始化
 */
+ (DMusicPlayer*)sharedInstance;
/**
 *  停止播放
 */
-(void)stopMusic;
/**
 *  播放
 */
-(void)playMusic:(NSString *)name;


@property(nonatomic,strong)  AVAudioPlayer * _Nullable player;
@property(nonatomic,strong)  NSMutableArray * listArray;

@end
NS_ASSUME_NONNULL_END
