//
//  myShareView.m
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "myShareView.h"

@implementation myShareView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        [self createUI];
    }
    
    return self;

}

-(void)createUI{

    NSArray*array=@[@"qq空间",@"qq",@"微信",@"微信朋友圈"];
    for (NSInteger i=0; i<array.count; i++) {
        
        UIButton*button=[[UIButton alloc]initWithFrame:CGRectMake(20+i*70, 84, 50, 50)];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonOnclick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=10+i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:button];
        
    }
    
    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH-40, SCREEN_WIDTH-40)];
    imageview.backgroundColor=[UIColor blackColor];
    [self addSubview:imageview];

}

-(void)buttonOnclick:(UIButton*)button{
    
    SSDKPlatformType type;
    NSInteger version=button.tag-10+1;
    switch (button.tag) {
        case 10:
            //qq好友
            type=SSDKPlatformSubTypeQQFriend;
            break;
            case 11:
            //qq空间
            type=SSDKPlatformSubTypeQZone;
            break;
        case 12:
            type=SSDKPlatformSubTypeWechatSession;
            break;
            case 13:
            type=SSDKPlatformSubTypeWechatTimeline;
            break;
        default:
            break;
    }
    
    NSString*urlString=[self interfaceFromString:interface_shareApp];
    NSString*parent=[NSString stringWithFormat:SHAREAPPKEY,[NSString stringWithFormat:@"%lu",version]];
    NSString*finaUrlString=[NSString stringWithFormat:@"%@?%@",urlString,parent];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupQQParamsByText:@"这么好的app，您值得拥有" title:@"这款app值得拥有" url:[NSURL URLWithString:finaUrlString]   thumbImage:nil image:nil type:SSDKContentTypeAuto forPlatformSubType:type];
    
    //进行分享
    [ShareSDK share:SSDKPlatformSubTypeQQFriend
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];

}

@end
