//
//  checkManager.m
//  master
//
//  Created by jin on 15/9/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "checkManager.h"

@implementation checkManager
{

    NSString*trackViewUrl;
}
+(checkManager*)share{
    static dispatch_once_t once;
    static checkManager*manager;
    dispatch_once(&once, ^{
       
        if (!manager) {
            manager=[[checkManager alloc]init];
        }
        
    });

    return manager;
}

-(void)checkNewVersionWithAppleID:(NSString*)ID{

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *URL =[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",ID];
    [[httpManager share]POST:URL parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dic=(NSDictionary*)responseObject;
        NSArray *infoArray = [dic objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *lastVersion = [releaseInfo objectForKey:@"version"];
            if ([lastVersion floatValue]> [currentVersion floatValue]) {
                NSString*content;
                if ([[dic objectForKey:@"results"][0] objectForKey:@"releaseNotes"]) {
                    content=[[dic objectForKey:@"results"][0] objectForKey:@"releaseNotes"];
                }
                trackViewUrl=[[dic objectForKey:@"results"][0] objectForKey:@"trackViewUrl"];
                FDAlertView *alert = [[FDAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本%@啦",[[dic objectForKey:@"results"][0] objectForKey:@"version"]] icon:nil message:content delegate:self buttonTitles:@"以后再说",@"马上更新", nil];
                [alert setButtonTitleColor:[UIColor blackColor] fontSize:14 atIndex:0];
                [alert show];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
 }];

}

-(void)alertView:(FDAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        NSURL *url = [NSURL URLWithString:trackViewUrl];
        [[UIApplication sharedApplication]openURL:url];
    }
}


-(void)checkVersion{

    NSString*urlString=[self interfaceFromString:interface_version];
    NSDictionary*dict=@{@"appKey":@"com.baoself.master"};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            //新版本更新机制
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];

}

@end
