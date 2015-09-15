//
//  AppDelegate.m
//  master
//
//  Created by jin on 15/5/5.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "orderViewController.h"
#import "selectViewController.h"
#import "MyViewController.h"
#import "XGPush.h"
#import "XGSetting.h"
#import "JKNotifier.h"
#import "MNextOrderDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "myRecommendPeopleViewController.h"
#import "OpenUDID.h"
#import <sys/utsname.h>
#import <SMS_SDK/SMS_SDK.h>
#import "CustomDialogView.h"
#import "sys/sysctl.h"
#import "guideViewController.h"
#include <sys/signal.h>
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import "findWorkViewController.h"
#import "findMasterViewController.h"
#import   <TestinAgent/TestinAgent.h>
#import "myPublicViewController.h"
#import "myTabViewController.h"
#import "Appirater.h"
#import "friendViewController.h"
#import "AppDelegate+methods.h"
#import "AppDelegate+request.h"
#import "AppDelegate+setting.h"


@interface AppDelegate ()<TencentSessionDelegate,WXApiDelegate,UIAlertViewDelegate>
@property (nonatomic) CLLocationManager *locMgr;
@property(nonatomic)BOOL havePushMessage;//是否有推送消息
@property(nonatomic)NSDictionary*pushDictory;//推送字典
@property(nonatomic)BOOL isLoginSuccess;//登陆是否成功
@end
/**
 * 用户岗位(1--雇主,2--师傅，3--包工头，4--项目经理)
 */
@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupRecommend];  //评分相关设置
    
    [self setupTestLin];    //云测相关设置
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"baoself#baoselftest" apnsCertName:@"com.zhuobao.master"];    //环信初始化
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    [XGPush startApp:2200123145 appKey:@"IT2RW4D1E84M"];  //信鸽推送初始化
    
     [SMS_SDK registerApp:@"93852832ce02" withSecret:@"a28d5c5bfbb3ddee35bf3a9585895472"]; //短信验证初始化
    
    if (!_pictureArray) {
        
        _pictureArray=[[NSMutableArray alloc]init];
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    [[dataBase share]CreateAllTables]; //创建数据库
    
    [self getOpenCity];   //缓存已开通城市
    
    [self requestSkills];//缓存技能列表并缓存
    

    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:@"first"] integerValue]==1) {
        [self setupRootView];
        _pushDictory=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (_pushDictory) {
            _havePushMessage=YES;
        }
        
        [WXApi registerApp:@"wxaa561e93e30b45ca"];//微信注册
        
        [self setupADImage];
        
        
    }else{
        
        
        [self setupguide];
        
    }
        
    return YES;
}


-(void)deafter{

    if (_isLoginSuccess) {
        [self setHomeView];
    }else{
        
        [self setupLoginView];
    }
}


#pragma mark-获取已开通城市的列表
-(void)getOpenCity{

    [self getAllOpenCity];
}

//设置广告界面
-(void)setupADImage{

    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    niceView.image = [UIImage imageNamed:@"Default.png"];
    niceView.tag=10;
    //添加到场景
    [self.window addSubview:niceView];
    
    //放到最顶层;
    [self.window bringSubviewToFront:niceView];
    
    //开始设置动画;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
    [UIView setAnimationDelegate:self];
    //這裡還可以設置回調函數;
    
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone)];
   
    niceView.alpha = 0.99;
    
    [UIView commitAnimations];
    
}


-(void)startupAnimationDone{
   
    if (_isLoginSuccess) {
        [self setHomeView];
    }else{
        
        [self setupLoginView];
    }

    UIImageView*imageview=(id)[self.window viewWithTag:10];
    [imageview removeFromSuperview];
}


-(void)setHomeView{

    [self setHomePageWithMessage:_havePushMessage Dict:_pushDictory];
    
}

-(void)removeAdImageView{

    [UIView animateWithDuration:0.7f animations:^{
        self.adimage.transform =CGAffineTransformScale(self.adimage.transform, 1.5, 1.6);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.window.rootViewController=_nc;
            [self.adimage removeFromSuperview];
         });
    }];
}


-(void)setupRootView
{
    NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
    NSString*username=[users objectForKey:@"username"];
    if (username) {
        NSString*password=[users objectForKey:username];
        if (password) {
            [self startRequestWithUsername:username Password:password];
        }else{
        
//            [self setupLoginView];
            _isLoginSuccess=NO;
        }
    }else{
//        [self setupLoginView];
        _isLoginSuccess=NO;
    }
}

-(void)setupLoginView{
    LoginViewController*lvc=[[LoginViewController alloc]init];
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    nc.navigationBar.barStyle=1;
    nc.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    self.window.rootViewController=nc;
}



-(void)startRequestWithUsername:(NSString*)username Password:(NSString*)password{
    
    NSString*urlString=[self interfaceFromString:interface_login];
    NSString* openUDID = [OpenUDID value];
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSMutableDictionary*dict=[[NSMutableDictionary alloc]init];
    [dict setObject:username forKey:@"mobile"];
    [dict setObject:password forKey:@"password"];
    [dict setObject:openUDID forKey:@"machineCode"];
    [dict setObject:[delegate getPhoneType] forKey:@"machineType"];
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            [self HXLoginWithUsername:username Password:password];
            NSUserDefaults*users=[NSUserDefaults standardUserDefaults];
            [users setObject:username forKey:@"username"];
            [users setObject:password forKey:username];
            [users synchronize];
            _isLogin=YES;
            [delegate requestInformation];
            [XGPush setAccount:[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"pullTag"]];
            _isLoginSuccess=YES;
            
             [self setupPushWithDictory];
            
            delegate.userPost=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"userPost"] integerValue];
            delegate.id=[[[[dict objectForKey:@"entity"] objectForKey:@"user"] objectForKey:@"id"] integerValue];
            
            [delegate sendData:delegate.pullToken];
        } else if ([[dict objectForKey:@"rspCode"] integerValue]==500) {
            
           
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)setupguide{

    NSUserDefaults*user=[NSUserDefaults standardUserDefaults];
    guideViewController*gvc=[[guideViewController alloc]init];
    
    self.window.rootViewController=gvc;
    
    [user setObject:@"1" forKey:@"first"];
    
    [user synchronize];

}


-(void)sendData:(NSString*)pull{
    
    AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (delegate.pullTokenFinish==YES&&delegate.isSend==NO) {
    NSString* openUDID = [OpenUDID value];
    NSString*urlString=[NSString stringWithFormat:@"%@%@",changeURL,@"/openapi/user/checkMutilClientLogin.json"];
    AppDelegate*delagate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSDictionary*dict=@{@"machineCode":openUDID,@"pullToken":pull,@"machineType":[delagate getPhoneType]};
    [[httpManager share]POST:urlString parameters:dict success:^(AFHTTPRequestOperation *Operation, id responseObject) {
    
        NSDictionary*sict=(NSDictionary*)responseObject;
        NSLog(@"%@",[dict objectForKey:@"msg"]);
           _isSend=YES;
            
    
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
    
        }];
    }
}



-(NSString*)getPhoneType{

    return [self getPhoneType];

}




-(void) setLogout
{
    [XGPush unRegisterDevice];
    
    _isSend=NO;
    
    _pullTokenFinish=NO;
    
    _isLogin=NO;
    
     [XGPush startApp:2200123145 appKey:@"IT2RW4D1E84M"];
    
    LoginViewController*lvc=[[LoginViewController alloc]init];
    
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:lvc];
    nc.navigationBar.barStyle=1;
    nc.navigationBar.barTintColor=COLOR(40, 163, 234, 1);
    self.window.rootViewController=nc;

}


//腾讯QQ分享
-(void)setupQQShare{

    TencentOAuth*tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104650241" andDelegate:self];
}


-(void)dataBase
{
    AreaModel*model=[[dataBase share]findWithCity:@"深圳市"];
    if (model.indexLetter==nil) {
        NSString*urlString=[self interfaceFromString: interface_cityList];
        [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
            NSDictionary*dict=(NSDictionary*)responseObject;
            NSArray*Array=[[NSArray alloc]initWithArray:[dict objectForKey:@"entities"]];
            [[dataBase share]addCityToDataBase:Array Pid:200000];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
            //                NSLog(@"%@",error);
        }];
    }
}



-(void)setupMap{
    
    _mapManager=[[CLLocationManager alloc]init];
    _geocoder=[[CLGeocoder alloc]init];
    _mapManager.delegate=self;
    _mapManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    CLLocationDistance distance=10.0;//十米定位一次
    _mapManager.distanceFilter=distance;
    //启动跟踪定位
    [_mapManager startUpdatingLocation];
    if (![CLLocationManager locationServicesEnabled]) {
        [self.window makeToast:@"定位尚未打开，请检查设置" duration:1 position:@"center"];
    }else{
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if ([[UIDevice currentDevice].systemVersion integerValue]>=8) {
                
                [_mapManager requestWhenInUseAuthorization];
            }
            
        }else{
            
            _mapManager.delegate=self;
            _mapManager.desiredAccuracy=kCLLocationAccuracyBest;
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance=10.0;//十米定位一次
            _mapManager.distanceFilter=distance;
            //启动跟踪定位
            [_mapManager startUpdatingLocation];
            
        }
        
    }
    
}


#pragma mark - CoreLocation 代理
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    //    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    //    //如果不需要实时定位，使用完即使关闭定位服务
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_mapManager stopUpdatingLocation];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        delegate.city=[placemark.addressDictionary objectForKey:@"City"];
        NSString*str=[placemark.addressDictionary objectForKey:@"FormattedAddressLines"][0];
        NSArray*tempArray=[str componentsSeparatedByString:[placemark.addressDictionary objectForKey:@"SubLocality"]];
        delegate.detailAdress=tempArray[1];
        if (!_sendMessage) {
            if (_cityChangeBlock) {
                _cityChangeBlock(delegate.city);
                _sendMessage=YES;
            }
        }
       
        //SubLocality  区
    }];
}


//缓存个人信息
-(void)requestInformation{
    
    [self requestPersonalInformation];
}

-(void)resignNoticeation{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    
    NSString*str=[userInfo objectForKey:PUSHKEY];
    NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
    NSString*type=[array[1] componentsSeparatedByString:@"\"}"][0];
    if ([type isEqualToString:@"masterOrderAccept"]==YES) {
        NSArray*sepArray=[str componentsSeparatedByString:@"\"entityId\":"];
        NSString*ID=[sepArray[1] componentsSeparatedByString:@","][0];
//        [self.window.rootViewController]
        //接受消息的处理
        
        
    }
    
        if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
            
//        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"信鸽服务器接受注册成功");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"信鸽服务器接受注册失败");
    };

    
     [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
   self.pullToken =[XGPush getDeviceToken:deviceToken];
    
    _pullTokenFinish=YES;

    [self sendData:self.pullToken];
    
  }


//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"注册失败Error: %@",err];
    
}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
   
       //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    NSString*str=[userInfo objectForKey:PUSHKEY];
    NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
    NSString*type=[array[1] componentsSeparatedByString:@"\"}"][0];
    if ([type isEqualToString:@"personalPass"]==YES||[type isEqualToString:@"personalFail"]==YES||[type isEqualToString:@"masterPostPass"]==YES||[type isEqualToString:@"masterPostFail"]==YES||[type isEqualToString:@"foremanPostPass"]==YES||[type isEqualToString:@"foremanPostFail"]==YES||[type isEqualToString:@"managerPostPass"]==YES||[type isEqualToString:@"managerPostFail"]==YES) {
        AppDelegate*delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if ([type isEqualToString:@"foremanPostPass"]==YES) {
            
         //3是工头  4是项目经理
            delegate.userPost=3;
        }else if ([type isEqualToString:@"managerPostPass"]==YES){
            delegate.userPost=4;
        }
        [delegate requestInformation];
    }
    
    if ([type isEqualToString:@"openCity"]==YES) {
        
        [self getOpenCity];
        
    }
    
    NSString*content=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSDate *now=[NSDate date];
        notification.fireDate=[now dateByAddingTimeInterval:1];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=content;
        notification.soundName = @"default";
        [notification setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    if (!type) {
        CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] buttonTitles:@"确定", nil];
        [dialog showWithCompletion:^(NSInteger selectIndex) {
            
            [self setLogout];
            
        }];
        
    }
    
    if ([type isEqualToString:@"projectAuditPass"]==YES) {
        [self.window.rootViewController.view makeToast:@"招工信息审核通过" duration:1 position:@"center"];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"public" object:nil userInfo:nil];
    }
    
    if ([type isEqualToString:@"projectAuditFail"]==YES) {
        [self.window.rootViewController.view makeToast:@"招工信息审核不通过" duration:1 position:@"center"];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"public" object:nil userInfo:nil];
    }

    [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return [WXApi handleOpenURL:url delegate:self];
    return [TencentOAuth HandleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
    return [WXApi handleOpenURL:url delegate:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
   
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
