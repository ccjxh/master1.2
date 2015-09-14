//
//  myserviceDataSouce.h
//  master
//
//  Created by jin on 15/9/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <Foundation/Foundation.h>
/*我的服务数据源封装**/


typedef enum {

    startTime,//开始工作时间
    skill,//技能
    serviceAdress,//服务区域
    certain,//证书
    serviceIntroude,//服务介绍
    compensation,//薪资期望
    workState,//工作状态
    

}myServiceCellType;
@interface myserviceDataSouce : NSObject
@property(nonatomic,strong)NSString*identity;//注册的标志
@property(nonatomic,strong)model*model; //数据模型
@property(nonatomic,strong)NSMutableArray*identityArray;//cell注册类型数组
@property(nonatomic,strong)NSMutableArray*modelArray;//cell数据源数组
-(NSString*)getIdentityFromIndexPath:(NSIndexPath*)indexPath;   //获得cell注册类型
-(model*)getModelFromIndexPath:(NSIndexPath*)indexPath; //获取cell所需要的model
@end
