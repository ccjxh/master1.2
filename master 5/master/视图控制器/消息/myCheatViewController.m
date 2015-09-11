//
//  myCheatViewController.m
//  master
//
//  Created by jin on 15/9/6.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "myCheatViewController.h"
#import "messageView.h"
//#import "XMChatBar.h"


@interface myCheatViewController ()<MessageDelegate,IEMChatProgressDelegate,EMChatManagerChatDelegate>

@end

@implementation myCheatViewController
{

    messageView*_backView;
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO];
    
}



-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager]setEnable:YES];
    
    
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
    EMConversation *netConversations = [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:eConversationTypeChat];
    _backView.convenit=netConversations;
    [_backView.chatListTable reloadData];
//    [_backView.chatListTable setContentOffset:CGPointMake(0, _backView.chatListTable.contentSize.height-_backView.chatListTable.frame.size.height)];
    
}


-(void)createUI{

//    self.automaticallyAdjustsScrollViewInsets=NO;
    _backView=[[messageView alloc]init];
    _backView.delegate=self;
    self.view=_backView;
   
}


-(void)sendMessage:(NSString *)messageText{

    EMChatText*tx=[[EMChatText alloc]initWithText:messageText];
    EMTextMessageBody*body=[[EMTextMessageBody alloc]initWithChatObject:tx];
    EMMessage*message=[[EMMessage alloc]initWithReceiver:self.buddy.username bodies:@[body]];
    message.messageType=eMessageTypeChat;
   EMMessage*temp=[[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:self];
    [[EaseMob sharedInstance].chatManager insertMessageToDB:temp append2Chat:YES];
    
     EMConversation *netConversations= [[EaseMob sharedInstance].chatManager conversationForChatter:self.buddy.username conversationType:YES];
    _backView.convenit=netConversations;
    [_backView.chatListTable reloadData];
    [_backView.chatListTable setContentOffset:CGPointMake(0, _backView.chatListTable.contentSize.height-_backView.chatListTable.frame.size.height)];
    
}



-(void)didSendMessage:(EMMessage *)message error:(EMError *)error{

    [self request];

}


-(void)didReceiveMessage:(EMMessage *)message{

    [self request];

}


@end
