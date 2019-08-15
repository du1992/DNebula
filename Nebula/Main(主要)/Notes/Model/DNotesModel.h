//
//  DNotesModel.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
#define TransverseImageWIDTH  (kScreenWidth-40)/3
#define NotesImageWIDTH        (kScreenWidth-31)/2
#define NotesImageWIDTH4       (kScreenWidth-32)/3

#define NotesImageHeight4        NotesImageWIDTH4+221


@interface DNotesModel : DBaseModel

/** 笔记文字内容*/
@property (strong, nonatomic) NSString *notesTextContent;
/** 笔记图片集合*/
@property (strong, nonatomic) NSMutableArray  *photoList;
/** 创建时间 */
@property (strong, nonatomic) NSString  *createTime;
/** 文字高度 */
@property (assign, nonatomic) NSInteger textHeight;
/** 文字视图高度 */
@property (assign, nonatomic) NSInteger textViewHeight;
/** Cell高度 */
@property (assign, nonatomic) NSInteger cellHeight;
/**上级ID**/
@property(nonatomic,strong)   NSString*  superiorID;

/**获取Cell高度**/
-(void)getCellHeight;

@end
NS_ASSUME_NONNULL_END
