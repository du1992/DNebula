//
//  DPoint.h
//  Nebula
//
//  Created by DUCHENGWEN on 2019/1/22.
//  Copyright © 2019年 liujiliu. All rights reserved.
//

#ifndef sphereTagCloud_DBPoint_h
#define sphereTagCloud_DBPoint_h

struct DPoint {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};

typedef struct DPoint DPoint;


DPoint DPointMake(CGFloat x, CGFloat y, CGFloat z) {
    DPoint point;
    point.x = x;
    point.y = y;
    point.z = z;
    return point;
}

#endif
