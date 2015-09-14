//
//  myserviceDataSouce.m
//  master
//
//  Created by jin on 15/9/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myserviceDataSouce.h"

@implementation myserviceDataSouce
-(instancetype)init{

    if (self=[super init]) {
    
        
    }
    
    return self;

}



-(NSString*)getIdentityFromIndexPath:(NSIndexPath *)indexPath{


    return [self.identityArray objectAtIndex:indexPath.section];


}

-(model*)getModelFromIndexPath:(NSIndexPath *)indexPath{

    return [self.modelArray objectAtIndex:indexPath.section];

}

@end
