//
//  loginManager.m
//  master
//
//  Created by jin on 15/9/30.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "loginManager.h"
#import "XGPush.h"
#import "LoginViewController.h"
@implementation loginManager
+(loginManager*)share{

    static dispatch_once_t once;
    static loginManager*manager;
    dispatch_once(&once, ^{
        
        if (!manager) {
            manager=[[loginManager alloc]init];
        }
    });

    return manager;
}


-(void)loginWithUsername:(NSString *)username Password:(NSString *)password LoginComplite:(loginComplite)loginComPlite{

    NSString*urlString=[self interfaceFromString:interface_login];
    NSString* openUDID = [OpenUDID value];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:username forKey:@"mobile"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:openUDID forKey:@"machineCode"];
    if ([delegate getPhoneType]) {
        [dict setObject:[delegate getPhoneType] forKey:@"machineType"];
    }else{
        
        [dict setObject:@"unknowIphone" forKey:@"machineType"];
    }
    __weak typeof(loginComplite)weakLoginBlock=loginComPlite;
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"inviteCode"] forKey:@"inviteCode"];
            [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"integrity"] forKey:@"integrity"];
            [delegate.userInforDic setObject:[[[dict objectForKey:@"entity"] objectForKey:@"user"]objectForKey:@"certification"] forKey:@"certification"];
            NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
            [users setObject:username forKey:@"username"];
            [users setObject:password forKey:username];
            [users synchronize];
            [delegate requestInformation];
            loginComPlite;
            [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
            delegate.signInfo=[[NSMutableDictionary alloc]initWithDictionary:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"signInfo"]];
            //注册推送
//            [self setupPushWithDictory];
            delegate.userPost=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"userPost"] integerValue];
            delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
            if (delegate.pullToken) {
                [delegate sendData:delegate.pullToken];
            }
            
            [delegate setHomeView];
            
        } else if ([[dict objectForKey:@"rspCode"] integerValue]==500) {
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}




@end
