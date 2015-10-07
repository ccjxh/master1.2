//
//  findMaster.m
//  master
//
//  Created by jin on 15/8/9.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "findMaster.h"
#import "UIImage+GIF.h"
#import "hotRankCollectionViewCell.h"

#define BUTTON_TAG 10
#define TIMELABEL_TAG 11
#define SCORELABELTAG 12
@implementation findMaster
{

    UIView*_noticeView;
    UIView*_firObjcView;
    UILabel*_timeLabel;//连续登陆label
    UILabel*_scoreLabel;//总积分标签
    UIScrollView*_backView;
    BOOL _isShowNotice;//是否显示通知

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
    
        [self createScrollLabel];
        [self customUI];
        [self customCollection];
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
//    self.wokerButton.layer.borderColor=COLOR(194, 194, 194, 1).CGColor;
//    self.workHeadButton.layer.borderColor=COLOR(194, 194, 194, 1).CGColor;
//    self.wokerButton.backgroundColor=[UIColor whiteColor];
//    self.workHeadButton.backgroundColor=[UIColor whiteColor];
//    self.wokerButton.layer.borderWidth=2;
//    self.workHeadButton.layer.borderWidth=2;
//    self.wokerButton.layer.masksToBounds=YES;
//    self.workHeadButton.layer.masksToBounds=YES;
//    self.wokerButton.layer.cornerRadius=20;
//    self.workHeadButton.layer.cornerRadius=20;
    _firObjcView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 40)];
    _firObjcView.backgroundColor=COLOR(100, 172, 196, 1);
    _firObjcView.userInteractionEnabled=YES;
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 150, 15)];
    _timeLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel.textColor=[UIColor whiteColor];
    [_firObjcView addSubview:_timeLabel];
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(25, 22, 40, 15)];
    _scoreLabel.textColor=[UIColor whiteColor];
    _scoreLabel.font=[UIFont systemFontOfSize:12];
    [_firObjcView addSubview:_scoreLabel];
    UIButton*signButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-120, _firObjcView.frame.size.height/2-10, 100, 20)];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==1) {
        
        [signButton setTitle:[NSString stringWithFormat:@"明日签到+%lu",[[delegate.signInfo objectForKey:@"nextDayIntegral"]integerValue]] forState:UIControlStateNormal];
        signButton.userInteractionEnabled=NO;
        
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

    _noticeView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 20)];
    _noticeView.backgroundColor=COLOR(16, 118, 162, 1);
    [self addSubview:_noticeView];
    _tv=[[TextFlowView alloc]initWithFrame:CGRectMake(30, 0, SCREEN_WIDTH-10, 20)Text:@""];
    [_tv startRun];
    [_tv setColor:[UIColor whiteColor]];
    [_tv setFont:[UIFont systemFontOfSize:15]];
    [_noticeView addSubview:_tv];
 
}

-(void)reloadData{

    UIButton*button=(id)[self viewWithTag:BUTTON_TAG];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==0) {
        [button setTitle:[NSString stringWithFormat:@"今日签到+%lu",self.model.nextDayIntegral] forState:UIControlStateNormal];
    }else{
        
        [button setTitle:[NSString stringWithFormat:@"明日签到+%lu",self.model.nextDayIntegral] forState:UIControlStateNormal];
        button.userInteractionEnabled=NO;
    }

    _timeLabel.text=[NSString stringWithFormat:@"您已经连续登陆了%lu天",[[delegate.signInfo objectForKey:@"renewDay"] integerValue]];
    _scoreLabel.text=[NSString stringWithFormat:@"%lu",[[delegate.signInfo objectForKey:@"totalIntegral"] integerValue]];
    if (_isShowNotice==NO) {
        _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 0);
    }else{
    
     _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 20);
    }
   
    _firObjcView.frame=CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 40);
    _backView.frame=CGRectMake(0, CGRectGetMaxY(_firObjcView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-64-140);
}


-(void)hideNotice{

    _isShowNotice=NO;
    [self reloadData];

}

-(void)showNotice{

    _isShowNotice=YES;
    [self reloadData];

}

-(void)customCollection{

    _backView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_firObjcView.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-64-140)];
    _backView.userInteractionEnabled=YES;
    UIView*tempView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, 155)];
    tempView.backgroundColor=[UIColor whiteColor];
    tempView.layer.cornerRadius=5;
    [_backView addSubview:tempView];
    NSArray*imageNames=@[@"5.png",@"6.png"];
    NSArray*title=@[@"工长",@"师傅"];
    NSArray*contentArray=@[@"待办、管理现场进度、进度把控",@"工程施工、专业技能"];
    for (NSInteger i=0; i<imageNames.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 5+i*70, SCREEN_WIDTH-40, 70)];
        button.backgroundColor=[UIColor whiteColor];
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 45, 45)];
        imageview.image=[UIImage imageNamed:imageNames[i]];
        [button addSubview:imageview];
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, 20, 100, 20)];
        nameLabel.text=title[i];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.textColor=[UIColor blackColor];
        UILabel*functionLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+10, CGRectGetMaxY(nameLabel.frame), 180, 20)];
        
        functionLabel.font=[UIFont systemFontOfSize:14];
        functionLabel.textColor=[UIColor lightGrayColor];
        functionLabel.text=contentArray[i];
        [button addSubview:functionLabel];
        
        [button addSubview:nameLabel];
        if (i==0) {
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 69, SCREEN_WIDTH-40, 1)];
            view.backgroundColor=COLOR(217, 217, 217, 1);
            [button addSubview:view];
        }
        tempView.userInteractionEnabled=YES;
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:button];
        
    }
    
    
    [self addSubview:_backView];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    CGFloat space=(SCREEN_WIDTH-180-45)/3;
    [layout setMinimumInteritemSpacing:space];
    [layout setMinimumLineSpacing:10];
    [layout setItemSize:CGSizeMake(60, 75)];
    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(20, 190, SCREEN_WIDTH-40, _backView.frame.size.height-190) collectionViewLayout:layout];
    _collection.backgroundColor=[UIColor whiteColor
                                 ];
    _collection.layer.cornerRadius=5;
    [_backView addSubview:_collection];
    _collection.delegate=self;
    _collection.dataSource=self;
    [ _collection setCollectionViewLayout:layout animated:YES];
    
    UINib *nib=[UINib nibWithNibName:@"hotRankCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"cell"];
    [_collection reloadData];
    
}


-(void)push:(UIButton*)button{

    if (self.workBlock) {
        self.workBlock();
    }

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return 6;

}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString*cellName=@"cell";
    hotRankCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    return cell;

}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 10, 2, 10);
}

@end
