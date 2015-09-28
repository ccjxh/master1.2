//
//  findMaster.h
//  master
//
//  Created by jin on 15/8/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
/*
 选择界面view
 **/

@interface findMaster : UIView<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *ADView;
@property (weak, nonatomic) IBOutlet UIButton *workHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *wokerButton;
@property(nonatomic)NSMutableArray* urlArray;
@property(nonatomic,strong)TextFlowView*tv;
@property(nonatomic)myIntegralInforModel*model;
@property(nonatomic,copy)void(^adImageOnclick)(NSInteger index);
@property(nonatomic,copy)void(^workHeadBlock)();
@property(nonatomic,copy)void(^workBlock)();
@property(nonatomic,copy)void(^signin)();
-(void)reloadData;
@end
