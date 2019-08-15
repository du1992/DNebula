//
//  UIImageView+GIFExtension.m
//  DWPromptAnimationTest
//
//  Created by dwang_sui on 16/8/29.
//  Copyright © 2016年 dwang_sui. All rights reserved.
//

#import "UIImageView+GIFExtension.h"
#import "DWLaunchScreen.h"


//@interface UIImageView (){
//    DWLaunchScreen*LaunchScreen;
//}
//
//
//@end

@implementation UIImageView (GIFExtension)

#pragma mark ---解析gif文件数据的方法 block中会将解析的数据传递出来
- (void)dw_GetGifImageWithUrk:(NSURL *)url
               returnData:(void(^)(NSArray<UIImage *> * imageArray,
                                   NSArray<NSNumber *>*timeArray,
                                   CGFloat totalTime,
                                   NSArray<NSNumber *>* widths,
                                   NSArray<NSNumber *>* heights))dataBlock {
    
    //通过文件的url来将gif文件读取为图片数据引用
    CGImageSourceRef source = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    
    //获取gif文件中图片的个数
    size_t count = CGImageSourceGetCount(source);
    
    //定义一个变量记录gif播放一轮的时间
    float allTime=0;
    
    //存放所有图片
    NSMutableArray * imageArray = [[NSMutableArray alloc]init];
    
    //存放每一帧播放的时间
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
    
    //存放每张图片的宽度 （一般在一个gif文件中，所有图片尺寸都会一样）
    NSMutableArray * widthArray = [[NSMutableArray alloc]init];
    
    //存放每张图片的高度
    NSMutableArray * heightArray = [[NSMutableArray alloc]init];
    
    //遍历
    for (size_t i=0; i<count; i++) {
        
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        [imageArray addObject:(__bridge UIImage *)(image)];
        
        CGImageRelease(image);
        
        //获取图片信息
        NSDictionary * info = (__bridge NSDictionary*)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        
        CGFloat width = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelWidth] floatValue];
        
        CGFloat height = [[info objectForKey:(__bridge NSString *)kCGImagePropertyPixelHeight] floatValue];
        
        [widthArray addObject:[NSNumber numberWithFloat:width]];
        
        [heightArray addObject:[NSNumber numberWithFloat:height]];
        
        NSDictionary * timeDic = [info objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        
        CGFloat time = [[timeDic objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime]floatValue];
        
        allTime+=time;
        
        [timeArray addObject:[NSNumber numberWithFloat:time]];
        
    }
    
    dataBlock(imageArray,timeArray,allTime,widthArray,heightArray);
}

#pragma mark ---为UIImageView添加一个设置gif图内容的方法
- (void)dw_SetImage:(NSURL *)imageUrl {
    
    __weak id __self = self;
    [self dw_GetGifImageWithUrk:imageUrl returnData:^(NSArray<UIImage *> *imageArray, NSArray<NSNumber *> *timeArray, CGFloat totalTime, NSArray<NSNumber *> *widths, NSArray<NSNumber *> *heights) {
        
        //添加帧动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.delegate = self; 
        NSMutableArray * times = [[NSMutableArray alloc]init];
        
        float currentTime = 0;
        
        //设置每一帧的时间占比
        for (int i=0; i<imageArray.count; i++) {
            
            [times addObject:[NSNumber numberWithFloat:currentTime/totalTime]];
            
            currentTime+=[timeArray[i] floatValue];
            
        }
        
        [animation setKeyTimes:times];
        
        [animation setValues:imageArray];
        
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
        
        //设置循环
//        animation.repeatCount= MAXFLOAT;
        
        //设置播放总时长
        animation.duration = totalTime;
        
        //Layer层添加
        [[(UIImageView *)__self layer]addAnimation:animation forKey:@"gifAnimation"];
        
    }];
}


-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    
    [DWLaunchScreen endAnimation];
//    [theAnimation clearMemory];
    //结束事件
}

@end
