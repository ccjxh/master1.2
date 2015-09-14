//
//  myServiceView.h
//  master
//
//  Created by jin on 15/9/14.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myserviceDataSouce.h"

@interface myServiceView : UIView<UITableViewDataSource,UITableViewDelegate>
-(instancetype)initWithDatasource:(myserviceDataSouce*)dataSource;

@end
