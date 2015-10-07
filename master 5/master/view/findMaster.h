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

@interface findMaster : UIView<SDCycleScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet SDCycleScrollView *ADView;
@property (weak, nonatomic) IBOutlet UIButton *workHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *wokerButton;
@property(nonatomic)NSMutableArray*dataArray;//热度排行榜数据源
@property(nonatomic)NSMutableArray* urlArray;
@property(nonatomic,strong)TextFlowView*tv;//通知公告
@property(nonatomic)myIntegralInforModel*model;//签到信息
@property (nonatomic) UICollectionView *collection;//热度排行榜视图
@property(nonatomic,copy)void(^adImageOnclick)(NSInteger index);
@property(nonatomic,copy)void(^workHeadBlock)();
@property(nonatomic,copy)void(^workBlock)();
@property(nonatomic,copy)void(^signin)(); //签到事件
-(void)reloadData;
-(void)hideNotice;
-(void)showNotice;
@end
