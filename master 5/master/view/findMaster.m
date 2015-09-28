//
//  findMaster.m
//  master
//
//  Created by jin on 15/8/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findMaster.h"
#import "UIImage+GIF.h"
#define BUTTON_TAG 10
#define TIMELABEL_TAG 11
#define SCORELABELTAG 12
@implementation findMaster
{

    UIView*_noticeView;
    UIView*_firObjcView;
    UILabel*_timeLabel;//连续登陆label
    UILabel*_scoreLabel;//总积分标签

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    

        [self customUI];
        [self createScrollLabel];
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
    _firObjcView=[[UIView alloc]initWithFrame:CGRectMake(0, 94, SCREEN_WIDTH, 50)];
    _firObjcView.backgroundColor=COLOR(100, 172, 196, 1);
    _firObjcView.userInteractionEnabled=YES;
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 15)];
    _timeLabel.font=[UIFont systemFontOfSize:14];
    _timeLabel.textColor=[UIColor whiteColor];
    [_firObjcView addSubview:_timeLabel];
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(45, 30, 40, 15)];
    _scoreLabel.textColor=[UIColor whiteColor];
    _scoreLabel.font=[UIFont systemFontOfSize:14];
    [_firObjcView addSubview:_scoreLabel];
    UIButton*signButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, _firObjcView.frame.size.height/2-10, 100, 20)];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSString*state;
    if (delegate.isSignState) {
        
         [signButton setTitle:@"已签到" forState:UIControlStateNormal];
        
    }else {
        
        [signButton setTitle:@"今日签到+10" forState:UIControlStateNormal];
        [signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [signButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    signButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [signButton setBackgroundColor:[UIColor whiteColor]];
    signButton.layer.cornerRadius=10;
    signButton.tag=BUTTON_TAG;
    [_firObjcView addSubview:signButton];
    [self addSubview:_firObjcView];

}


-(void)sign:(UIButton*)button{

    if (self.signin) {
        self.signin();
    }

}



-(void)createScrollLabel{

    _noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 30)];
    _noticeView.backgroundColor=COLOR(16, 118, 162, 1);
    [self addSubview:_noticeView];
    _tv=[[TextFlowView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-10, 30)Text:@""];
    [_tv startRun];
    [_tv setColor:[UIColor whiteColor]];
    [_tv setFont:[UIFont systemFontOfSize:15]];
    [_noticeView addSubview:_tv];
 
}

-(void)reloadData{

    UIButton*button=(id)[self viewWithTag:BUTTON_TAG];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (!delegate.isSignState) {
        [button setTitle:[NSString stringWithFormat:@"今日签到+%lu",self.model.nextDayIntegral] forState:UIControlStateNormal];
    }
    
    _timeLabel.text=[NSString stringWithFormat:@"您已经连续登陆了%lu天",self.model.renewDay];
    _scoreLabel.text=[NSString stringWithFormat:@"%lu",self.model.totalIntegral];
   
}


@end
