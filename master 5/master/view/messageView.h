//
//  messageView.h
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "RootView.h"

@interface messageView : RootView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITableView*tableview;
@property(nonatomic)NSMutableArray*dataArray;
@end
