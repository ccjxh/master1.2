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
#import "PeoDetailViewController.h"
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
    UIButton*_signButton;//签到button
    UIButton*_refershButton;

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
    _firObjcView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 48)];
    _firObjcView.backgroundColor=COLOR(100, 172, 196, 1);
    _firObjcView.userInteractionEnabled=YES;
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(13, 7.5, 150, 12)];
    _timeLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel.textColor=[UIColor whiteColor];
    [_firObjcView addSubview:_timeLabel];
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(13, CGRectGetMaxY(_timeLabel.frame)+6, 12, 12)];
    imageview.image=[UIImage imageNamed:@"积分.png"];
    [_firObjcView addSubview:imageview];
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+5, CGRectGetMaxY(_timeLabel.frame)+6, 40, 12)];
    _scoreLabel.textColor=[UIColor whiteColor];
    _scoreLabel.font=[UIFont systemFontOfSize:12];
    [_firObjcView addSubview:_scoreLabel];
    _signButton=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-113, 10.5, 100, _firObjcView.frame.size.height-21)];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==1) {
        
        [_signButton setTitle:[NSString stringWithFormat:@"明日签到+%d",[[delegate.signInfo objectForKey:@"nextDayIntegral"]integerValue]] forState:UIControlStateNormal];
        _signButton.userInteractionEnabled=NO;
        
    }else {
        
        [_signButton setTitle:@"今日签到+10" forState:UIControlStateNormal];
        [_signButton addTarget:self action:@selector(sign:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [_signButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _signButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [_signButton setBackgroundColor:[UIColor whiteColor]];
    _signButton.layer.cornerRadius=15;
    _signButton.tag=BUTTON_TAG;
    [_firObjcView addSubview:_signButton];
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
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(13, 5, 10, 12)];
    imageview.image=[UIImage imageNamed:@"公告.png"];
    [_noticeView addSubview:imageview];
    _tv=[[TextFlowView alloc]initWithFrame:CGRectMake(28, 5, SCREEN_WIDTH-10, 12)Text:@""];
    [_tv startRun];
    [_tv setColor:[UIColor whiteColor]];
    [_tv setFont:[UIFont systemFontOfSize:12]];
    [_noticeView addSubview:_tv];
 
}

-(void)reloadData{

    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([[delegate.signInfo objectForKey:@"signState"] integerValue]==0) {
        [_signButton setTitle:[NSString stringWithFormat:@"今日签到+%lu",self.model.nextDayIntegral] forState:UIControlStateNormal];
    }else{
        
        [_signButton setTitle:[NSString stringWithFormat:@"明日签到+%lu",self.model.nextDayIntegral] forState:UIControlStateNormal];
        _signButton.userInteractionEnabled=NO;
    }

    _timeLabel.text=[NSString stringWithFormat:@"您已经连续登陆了%lu天",[[delegate.signInfo objectForKey:@"renewDay"] integerValue]];
    _scoreLabel.text=[NSString stringWithFormat:@"%lu",delegate.integral];
    if (_isShowNotice==NO) {
        _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 0);
    }else{
    
     _noticeView.frame=CGRectMake(_noticeView.frame.origin.x, _noticeView.frame.origin.y, _noticeView.frame.size.width, 20);
    }
   
    _firObjcView.frame=CGRectMake(0, CGRectGetMaxY(_noticeView.frame), SCREEN_WIDTH, 48);
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

    _backView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_firObjcView.frame)+10, SCREEN_WIDTH, 600-64-140)];
    _backView.userInteractionEnabled=YES;
    UIView*tempView=[[UIView alloc]initWithFrame:CGRectMake(13, 0, SCREEN_WIDTH-26, 155)];
    tempView.backgroundColor=[UIColor whiteColor];
    tempView.layer.cornerRadius=5;
    [_backView addSubview:tempView];
    NSArray*title=@[@"工长",@"师傅"];
    NSArray*contentArray=@[@"待办、管理现场进度、进度把控",@"工程施工、专业技能"];
    for (NSInteger i=0; i<title.count; i++) {
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(0, 5+i*70, SCREEN_WIDTH-40, 70)];
        button.backgroundColor=[UIColor whiteColor];
        UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 45, 45)];
        if (i==1) {
            imageview.frame=CGRectMake(15, 15, 45, 45);
        }
        imageview.image=[UIImage imageNamed:title[i]];
        [button addSubview:imageview];
        UILabel*nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+15, 17, 100, 20)];
        if (i==0) {
            nameLabel.frame=CGRectMake(CGRectGetMaxX(imageview.frame)+15, 12, 100, 20);
        }
        nameLabel.text=title[i];
        nameLabel.font=[UIFont systemFontOfSize:16];
        nameLabel.textColor=[UIColor blackColor];
        UILabel*functionLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageview.frame)+15, CGRectGetMaxY(nameLabel.frame), 200, 20)];
        functionLabel.font=[UIFont systemFontOfSize:14];
        functionLabel.textColor=[UIColor lightGrayColor];
        functionLabel.text=contentArray[i];
        [button addSubview:functionLabel];
        [button addSubview:nameLabel];
        if (i==0) {
            
            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(2, 69, SCREEN_WIDTH-30, 1)];
            view.backgroundColor=COLOR(217, 217, 217, 1);
            [button addSubview:view];
            
        }
        tempView.userInteractionEnabled=YES;
        button.tag=40+i;
        [button addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [tempView addSubview:button];
        
    }
    
    [self addSubview:_backView];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection=UICollectionViewScrollDirectionVertical;
    CGFloat space=(SCREEN_WIDTH-180-45)/4;
    [layout setMinimumInteritemSpacing:space];
    [layout setMinimumLineSpacing:10];
    [layout setItemSize:CGSizeMake(50, 75)];
    _collection=[[UICollectionView alloc]initWithFrame:CGRectMake(13, 170, SCREEN_WIDTH-26, _backView.frame.size.height-170) collectionViewLayout:layout];
    NSInteger height=CGRectGetMaxY(_collection.frame);
    [_backView setContentSize:CGSizeMake(SCREEN_WIDTH, height)];
    _collection.backgroundColor=[UIColor whiteColor];
    _collection.layer.cornerRadius=5;
    [_backView addSubview:_collection];
    _collection.delegate=self;
    _collection.dataSource=self;
    UIImageView*hotImageview=[[UIImageView alloc]initWithFrame:CGRectMake(28, 18, 20, 20)];
    hotImageview.image=[UIImage imageNamed:@"排行榜.png"];
    [_collection addSubview:hotImageview];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(hotImageview.frame)+28, 18, 90, 16)];
    label.text=@"热度排行榜";
    label.textColor=COLOR(146, 146, 146, 1);
    label.font=[UIFont systemFontOfSize:16];
    [_collection addSubview:label];
    [ _collection setCollectionViewLayout:layout animated:YES];
    UINib *nib=[UINib nibWithNibName:@"hotRankCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collection registerNib:nib forCellWithReuseIdentifier:@"cell"];
    _refershButton=[[UIButton alloc]initWithFrame:CGRectMake(_collection.bounds.size.width/2-30, _collection.bounds.size.height/2-30 , 60, 60)];
    _refershButton.backgroundColor=[UIColor blackColor];
    [_refershButton addTarget:self action:@selector(refershData) forControlEvents:UIControlEventTouchUpInside];
    _refershButton.hidden=YES;
    [_collection addSubview:_refershButton];
    [_collection reloadData];
    [_collection bringSubviewToFront:_refershButton];

}



-(void)refershData{

    if (self.refershHotRank) {
        self.refershHotRank();
    }

}


-(void)showNoDataPiceure{

    _refershButton.hidden=NO;

}


-(void)hideNoDataPicture{

    _refershButton.hidden=YES;

}

-(void)push:(UIButton*)button{

    switch (button.tag) {
        case 40:
        {
            if (self.workHeadBlock) {
                self.workHeadBlock();
            }

        }
            break;
          case 41:
        {
        
            
            if (self.workBlock) {
                self.workBlock();
            }
        }
            break;
        default:
            break;
    }
   

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    NSLog(@"%lu",_hotArray.count);
    return _hotArray.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MasterDetailModel*model=_hotArray[indexPath.row];
    static NSString*cellName=@"cell";
    hotRankCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellName forIndexPath:indexPath];
    cell.name.text=model.realName;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",changeURL,model.icon]] placeholderImage:[UIImage imageNamed:@"头像.png"]];
    return cell;

}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(52, 10, 2, 10);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    MasterDetailModel*model=_hotArray[indexPath.row];
//    PeoDetailViewController*pvc=[[PeoDetailViewController alloc]init];
//    
//    [self pushWinthAnimation:self.na Viewcontroller:pvc];

    if (self.push) {
        self.push(indexPath);
    }

}

@end
