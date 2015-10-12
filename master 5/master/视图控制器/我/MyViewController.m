//
//  MyViewController.m
//  master
//
//  Created by jin on 15/5/18.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "MyViewController.h"
#import "MyInformationTableViewCell.h"
#import "MyserviceViewController.h"
#import "BasicInfoViewController.h" //基本信息界面
#import "SetViewController.h"  //设置界面
#import "CommonAdressController.h"  //常用地址界面
#import "myProjectCaseViewController.h"//工程案例界面
#import "CollectViewController.h" //收藏界面
#import "myRecommendPeopleViewController.h"
#import "myCaseViewController.h"
#import "myServiceSelectedViewController.h"
#import "myFirstTableViewCell.h"
#import "myPageTableViewCell.h"
#import "myPublicViewController.h"
#import "myIntegralListViewController.h"
#import "MyShareViewController.h"

@interface MyViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic)NSMutableArray*dataArray;
@end

@implementation MyViewController

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self initDate];
    [self.tableview reloadData];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initDate];
    [self.tableview reloadData];
//    self.navigationController.navigationBarHidden=YES;
}

-(void)receiveNotice{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update) name:@"updateUI" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealRefer:) name:@"headRefersh" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateIntral) name:@"integrityUpdate" object:nil];
    
}


-(void)updateIntral{
    
    [_tableview reloadData];

}

-(void)dealRefer:(NSNotification*)nc{
    
    [self initDate];
   
}

-(void)update{
    
    [self initDate];
    [self.tableview reloadData];
    
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"update" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"headRefersh" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"integrityUpdate" object:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.tableview.separatorStyle=0;
    [self receiveNotice];
    
}



-(void)initDate{
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }
    AppDelegate*Delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSArray*FirstArray=@[@"基本信息"];
    NSArray*secondArray=@[@"成为宝师傅"];
    if (Delegate.userPost==2||Delegate.userPost==3) {
        secondArray=@[@"我的服务"];
    }
    NSArray*findJobArray=@[@"我的发布"];
    NSArray*thirdArray=@[@"工程案例"];
    NSArray*fourArray=@[@"我的收藏"];
    NSArray*fifArray=@[@"设置"];
    NSArray*sixarray=@[@"我的积分"];
    NSArray*sevenArray=@[@"我的分享"];
    if (!_dataArray) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    [_dataArray addObject:FirstArray];
    [_dataArray addObject:secondArray];
    [_dataArray addObject:findJobArray];
//    [_dataArray addObject:thirdArray];
    if (Delegate.userPost==2||Delegate.userPost==3) {
        [_dataArray addObject:thirdArray];
    }
    [_dataArray addObject:fourArray];
    [_dataArray addObject:sixarray];
    [_dataArray addObject:sevenArray];
    [_dataArray addObject:fifArray];
    [self.tableview reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
    if (indexPath.section==0) {
        myFirstTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell=[[[NSBundle mainBundle]loadNibNamed:@"myFirstTableViewCell" owner:nil options:nil]lastObject];
            
        }
        NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,model.icon];
        [cell.headImahe sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:headImageName]];
        [cell.headImahe setContentScaleFactor:[[UIScreen mainScreen] scale]];
        cell.headImahe.contentMode =  UIViewContentModeScaleAspectFill;
        cell.headImahe.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.headImahe.clipsToBounds=YES;
        cell.name.text=model.realName;
        cell.headImahe.layer.cornerRadius=10;
        cell.integrity.text=[NSString stringWithFormat:@"%lu%%",(long)delegate.integrity];
        cell.integrity.textColor=COLOR(220, 115, 0, 1);
        cell.detail.text=model.mobile;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
     myPageTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"myPageTableViewCell" owner:nil options:nil]lastObject];
    }
    cell.typeImage.image=[UIImage imageNamed:_dataArray[indexPath.section][indexPath.row]];
    cell.type.text=_dataArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 85;
    }
    return 50;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section==0) {
        return 0;
    }
    if (section==1) {
        return 20;
    }
    return 1;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [[SelectManager share]tableviewDidSelectWithKindOfClass:@"MyViewController" IndexPath:indexPath Navigatingation:self.navigationController Tableview:tableView];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
