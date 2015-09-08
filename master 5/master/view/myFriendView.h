//
//  myFriendView.h
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myFriendView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic)UITableView*tableview;
@property(nonatomic)NSMutableArray*dataArray;
@property(nonatomic,copy)void(^friendDidSelect)(NSIndexPath*indexPath);
@end
