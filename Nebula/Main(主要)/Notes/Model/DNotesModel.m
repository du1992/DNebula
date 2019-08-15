//
//  DNotesModel.m
//  Nebula
//
//  Created by DUCHENGWEN on 2019/2/17.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#import "DNotesModel.h"
@implementation DNotesModel
+ (void)load{
    [self regiestDB];
}

//主键ID
+ (NSString *)db_pk{
    return @"primaryID";
}


/**获取Cell高度**/
-(void)getCellHeight{
    if (self.textHeight>40) {
        self.textViewHeight=60;
        self.cellHeight=60+15+60;
    }else{
      self.textViewHeight=self.textHeight;
      self.cellHeight=self.textHeight+15+60;
    }
    
    
    if (self.photoList.count==1) {
       
         self.cellHeight=self.cellHeight+190;
        
    }else if (self.photoList.count==2){
        self.cellHeight=self.cellHeight+NotesImageWIDTH+5;
        
    }else if (self.photoList.count==3){
        self.cellHeight=self.cellHeight+261+5;
    }else if (self.photoList.count>3){
        
        self.cellHeight=self.cellHeight+NotesImageHeight4+5;
        
    }
    
    
    
    
   
    
   
}



@end
