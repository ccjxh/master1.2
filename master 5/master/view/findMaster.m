//
//  findMaster.m
//  master
//
//  Created by jin on 15/8/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findMaster.h"

@implementation findMaster

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    
//        [self initADView];  //加载广告栏信息
        [self customUI];
    }
    
    return self;

}

//工长
- (IBAction)workHead:(id)sender {
    
    if (self.workHeadBlock) {
        self.workHeadBlock();
    }
}


//师傅
- (IBAction)work:(id)sender {
    
    if (self.workBlock) {
        self.workBlock();
    }
    
}


-(void)customUI{

    self.backgroundColor=COLOR(232, 233, 232, 1);
    self.wokerButton.layer.borderColor=COLOR(194, 194, 194, 1).CGColor;
    self.workHeadButton.layer.borderColor=COLOR(194, 194, 194, 1).CGColor;
    self.wokerButton.backgroundColor=[UIColor whiteColor];
    self.workHeadButton.backgroundColor=[UIColor whiteColor];
    self.wokerButton.layer.borderWidth=2;
    self.workHeadButton.layer.borderWidth=2;
    self.wokerButton.layer.masksToBounds=YES;
    self.workHeadButton.layer.masksToBounds=YES;
    self.wokerButton.layer.cornerRadius=20;
    self.workHeadButton.layer.cornerRadius=20;

}

-(void)initADView{

    self.ADView.autoScrollTimeInterval=2;
    self.ADView.tag=100;
    self.ADView.delegate=self;
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    self.ADView.imageURLStringsGroup=delegate.pictureArray;
    self.ADView.layer.masksToBounds=YES;
    self.ADView.layer.cornerRadius=5;
    self.ADView.delegate=self;
    self.ADView.pageControlAliment=0;
    self.ADView.dotColor=COLOR(255, 255, 255, 0.4);

}


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

    if (self.adImageOnclick) {
        self.adImageOnclick(index);
    }
}





@end
