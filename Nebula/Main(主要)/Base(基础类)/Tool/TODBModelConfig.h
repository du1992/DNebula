//
//  TODBModelConfig.h
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#ifndef TODBModelConfig_h
#define TODBModelConfig_h

#define TO_MODEL_DEBUG  1

#define TO_MODEL_DATABASE_PATH [[NSString alloc] initWithString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"TOModel.db"]]

#define TO_MODEL_LOG(x...) if(TO_MODEL_DEBUG){NSLog(x);}

#endif /* TODBModelConfig_h */
