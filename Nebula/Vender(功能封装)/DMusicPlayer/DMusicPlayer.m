//
//  DMusicPlayer.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/29.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DMusicPlayer.h"
@implementation DMusicModel  @end

@implementation DMusicPlayer

static DMusicPlayer *sharedObj = nil;
+ (DMusicPlayer*) sharedInstance
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
            
            NSArray*array=@[
                            Localized(@"music0"),
                            Localized(@"music1"),
                            Localized(@"music2"),
                            Localized(@"music3"),
                            Localized(@"music4"),
                            Localized(@"music5"),
                            Localized(@"music6"),
                            Localized(@"music7"),
                            Localized(@"music8"),
                            Localized(@"music9"),
                            Localized(@"music10"),
                            Localized(@"music11"),
                            Localized(@"music12"),
                            Localized(@"music13"),
                            Localized(@"music14"),
                            Localized(@"music15"),
                            Localized(@"music16"),
                            Localized(@"music17"),
                            Localized(@"music18"),
                            Localized(@"music19"),
                        ];
            for (int i=0; i<array.count; i++) {
                DMusicModel*model=[DMusicModel new];
                model.musicTitle=array[i];
                [sharedObj.listArray addObject:model];
            }
            
            
            
        }
    }
    return sharedObj;
}
/**
 *  播放
 */
-(void)playMusic:(NSString *)name{
   
    
    [self stopMusic];
    
    NSError *playerIninError;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"aac"];
    NSData *audioData = [NSData dataWithContentsOfFile:path];
     self.player = [[AVAudioPlayer alloc] initWithData:audioData fileTypeHint:AVFileTypeMPEGLayer3 error:&playerIninError];
    if (!playerIninError) {
        self.player.volume = 0.5;
        [self.player prepareToPlay];
         self.player.numberOfLoops = 500;
        [self.player play];
    }
    else
    {
        NSLog(@"error = %@",[playerIninError localizedDescription]);
    }
}
/**
 *  停止播放
 */
-(void)stopMusic{
    if (self.player) {
        [self.player stop];
        
        self.player = nil;
    }
}

- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}





@end
