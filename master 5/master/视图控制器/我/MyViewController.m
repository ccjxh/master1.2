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
        cell.detail.text=[NSString stringWithFormat:@"电话%@",model.mobile];
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
    
     AppDelegate*Delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            //个人基本信息
            BasicInfoViewController *ctl = [[BasicInfoViewController alloc] init];
            ctl.hidesBottomBarWhenPushed=YES;
            ctl.block=^(NSString*realName,NSString*corve){
                AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                model.icon=corve;
                [[dataBase share]addInformationWithModel:model];
                [self.tableview reloadData];
            };
            
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
            case 1:
        {
            switch (indexPath.row) {
                case 0:
                    {
                        //我的服务
                        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
                        PersonalDetailModel*model=[[dataBase share]findPersonInformation:delegate.id];
                        if (delegate.userPost==3||delegate.userPost==4||delegate.userPost==2) {
                            MyserviceViewController*mvc=[[MyserviceViewController alloc]initWithNibName:@"MyserviceViewController" bundle:nil];
                            mvc.hidesBottomBarWhenPushed=YES;
                            [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
                            return;
                        }
                        myServiceSelectedViewController*svc=[[myServiceSelectedViewController alloc]initWithNibName:@"myServiceSelectedViewController" bundle:nil];
                        svc.hidesBottomBarWhenPushed=YES;
                        [self pushWinthAnimation:self.navigationController  Viewcontroller:svc];
                        
            
            }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            
        case 2:{
        
            myPublicViewController*mvc=[[myPublicViewController alloc]init];
            mvc.hidesBottomBarWhenPushed=YES;
            [self pushWinthAnimation:self.navigationController Viewcontroller:mvc];
            
        }
            
            break;
            
            
            
        case 3:
        {
            if (Delegate.userPost==2||Delegate.userPost==3) {
            if (indexPath.row == 0) {
                myCaseViewController *ctl = [[myCaseViewController alloc] initWithNibName:@"myCaseViewController" bundle:nil];
                ctl.hidesBottomBarWhenPushed=YES;
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            }else if (indexPath.row==1){
                myRecommendPeopleViewController*rvc=[[myRecommendPeopleViewController alloc]initWithNibName:@"myRecommendPeopleViewController" bundle:nil];
                rvc.hidesBottomBarWhenPushed=YES;
                [self pushWinthAnimation:self.navigationController Viewcontroller:rvc];
            }
            }else{
            
                    CollectViewController *cVC = [[CollectViewController alloc] init];
                    cVC.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:self.navigationController Viewcontroller:cVC];
 
            }
            
    }
            break;
        case 4:
        {
            if (Delegate.userPost==2||Delegate.userPost==3){
            switch (indexPath.row) {
                case 0:
                {
                    CollectViewController *cVC = [[CollectViewController alloc] init];
                    cVC.hidesBottomBarWhenPushed=YES;
                    [self pushWinthAnimation:self.navigationController Viewcontroller:cVC];
                }
                    break;
                default:
                    break;
                }
            }else{
                SetViewController *ctl = [[SetViewController alloc] init];
                ctl.hidesBottomBarWhenPushed=YES;
                [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
            
            }
        }
            break;
        case 5:
        {
            SetViewController *ctl = [[SetViewController alloc] init];
            ctl.hidesBottomBarWhenPushed=YES;
            [self pushWinthAnimation:self.navigationController Viewcontroller:ctl];
        }
            break;
        default:
            break;
    }

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
