//
//  myCheatViewController.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myCheatViewController.h"
#import "messageView.h"
#import "XMChatBar.h"
@interface myCheatViewController ()

@end

@implementation myCheatViewController
{

    messageView*_backView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self CreateFlow];
    [self request];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//获取聊天记录
-(void)request{

    //获取会话
    NSArray *netConversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    EMConversation*conversations=netConversations[0];
   
    NSArray*Array=[conversations loadAllMessages];
    _backView.dataArray=[[NSMutableArray alloc]initWithArray:Array];
    [_backView.tableview reloadData];
//    EMMessage*message=Array[0];
//    NSString*str=((EMTextMessageBody*)message.messageBodies.firstObject).text;
    
}


-(void)createUI{

    self.automaticallyAdjustsScrollViewInsets=NO;
    _backView=[[messageView alloc]init];
    self.view=_backView;
    XMChatBar*bar=[[XMChatBar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-45, SCREEN_WIDTH, 45)];
    [self.view addSubview:bar];
   
}


@end
