//
//  RootView.h
//  master
//
//  Created by jin on 15/9/8.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIView
@property(nonatomic,copy)void(^tableviewDidselecredAtIndexpath)(NSIndexPath*indexpath);
@end
