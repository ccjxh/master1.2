//
//  friendViewController.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "friendViewController.h"
#import "myFriendView.h"
#import "myCheatViewController.h"
@interface friendViewController ()

@end

@implementation friendViewController
{
   
    __block  myFriendView*backView;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"huanxinLogin" object:nil];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createUI];
    [self CreateFlow];
    [self noData];
    [self netIll];
    [self request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUI) name:@"huanxinLogin" object:nil];
   
    
    // Do any additional setup after loading the view.
}

-(void)updateUI{

    [self request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)request{

    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            NSMutableArray*Array=[[NSMutableArray alloc]initWithArray:buddyList];
    
            backView.dataArray=Array;
            [backView.tableview reloadData];
        }
    } onQueue:nil];

}


-(void)createUI{

    backView=[[myFriendView alloc]init];
    __weak typeof(self)WeSelf=self;
    __weak typeof(myFriendView*)WeView=backView;
    backView.friendDidSelect=^(NSIndexPath*indexPath){
        myCheatViewController*cvc=[[myCheatViewController alloc]init];
        EMBuddy*buddy=WeView.dataArray[indexPath.section];
        cvc.buddy=buddy;
        cvc.hidesBottomBarWhenPushed=YES;
        [WeSelf pushWinthAnimation:WeSelf.navigationController Viewcontroller:cvc];
        
    };
    self.view=backView;
}




@end
