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


@interface AppDelegate ()<TencentSessionDelegate,WXApiDelegate,UIAlertViewDelegate>
@property (nonatomic) CLLocationManager *locMgr;
@property(nonatomic)BOOL havePushMessage;//是否有推送消息
@property(nonatomic)NSDictionary*pushDictory;//推送字典
@property(nonatomic)BOOL isLoginSuccess;//登陆是否成功
@property(nonatomic)NSTimer*timer;

@end
/**
 * 用户岗位(1--雇主,2--师傅，3--包工头，4--项目经理)
 */
@implementation AppDelegate


-(void)dealloc{

    [_timer invalidate];

}


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
        
//        [self setupBaiDuMap];//设置地图
       
        
        [WXApi registerApp:@"wxaa561e93e30b45ca"];//微信注册
        
        [self setupADImage];
        
        
    }else{
        
        
        [self setupguide];
        
    }
    

    
    return YES;
}




/*评分相关设置**/
-(void)setupRecommend{

    //评分
    [Appirater setAppId:@"1031874136"];
    [Appirater setDaysUntilPrompt:0];
    [Appirater setUsesUntilPrompt:5];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:2];
    [Appirater setDebug:NO];
    [Appirater appLaunched:YES];

}


//云测相关设置
-(void)setupTestLin{

    [TestinAgent init:@"c5ea5096fd7481f747bbad61c3005e8d" channel:nil config:[TestinConfig defaultConfig]];
    

}


-(void)deafter{

    if (_isLoginSuccess) {
        [self setHomeView];
    }else{
        
        [self setupLoginView];
    }


}

//推送
-(void)setupPushWithDictory {
    
    //注销之后需要再次注册前的准备
    void (^successCallback)(void) = ^(void){
        //如果变成需要注册状态
        if(![XGPush isUnRegisterStatus])
        {
            //iOS8注册push方法
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
            
            float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
            if(sysVer < 8){
                [self resignNoticeation];
            }
            else{
                [self registerPushForIOS8];
            }
#else
            //iOS8之前注册push方法
            //注册Push服务，注册后才能收到推送
            [self resignNoticeation];
#endif
        }
    };
    [XGPush initForReregister:successCallback];
    
    //推送反馈回调版本示例
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleLaunching's successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleLaunching's errorBlock");
    };
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //清除所有通知(包含本地通知)
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
}



#pragma mark-获取已开通城市的列表
-(void)getOpenCity{

    NSString*urlString=[self interfaceFromString: interface_getOpenCityList];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*array=[dict objectForKey:@"entities"];
    
            [[dataBase share]addCityToDataBase:array Pid:30000];
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
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

//-(void)setupBaiDuMap{
//
//    _mapManager = [[BMKMapManager alloc]init];
//    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//    BOOL ret = [_mapManager start:@"GK6ttaQ8hXmIyFRjafl9gGP2"  generalDelegate:nil];
//    if (!ret) {
//        
//    }
//
//}




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



-(void)setHomeView{
    
    findMasterViewController*hvc=[[findMasterViewController alloc]init];
    hvc.title=@"找师傅";
    UINavigationController*nc=[[UINavigationController alloc]initWithRootViewController:hvc];
    nc.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc.navigationBar.barStyle=1;
    orderViewController*ovc=[[orderViewController alloc]initWithNibName:@"orderViewController" bundle:nil];
    UINavigationController*nc1=[[UINavigationController alloc]initWithRootViewController:ovc];
    nc1.navigationBar.barTintColor=COLOR(67, 172, 219, 1);
//    [nc.navigationBar setBackgroundImage:[self returnImageFromName:@"导航栏.png"] forBarMetrics:UIBarMetricsDefault];
//    nc.navigationController.navigationBar.translucent = NO;
//    UIImageView*imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
//    imageview.image=[UIImage imageNamed:@"导航栏.png"];
//    
//    [nc.navigationBar insertSubview:imageview atIndex:0];
    ovc.title=@"订单";
    [nc1.navigationController.navigationBar.layer setMasksToBounds:YES];
//    nc1.navigationBar.barStyle=1;
    MyViewController*mvc=[[MyViewController alloc]init];
    UINavigationController*nc2=[[UINavigationController alloc]initWithRootViewController:mvc];
    nc2.navigationBar.barStyle=1;
    nc2.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    mvc.title=@"我";
    UITabBarItem*item1=[[UITabBarItem alloc]initWithTitle:@"找师傅" image: [UIImage imageNamed:@"找师傅-未选择"] selectedImage: [self returnImageFromName:@"找师傅"]];
    
    UITabBarItem*item2=[[UITabBarItem alloc]initWithTitle:@"找活干" image: [UIImage imageNamed:@"找工作-未选择"] selectedImage: [self returnImageFromName:@"找工作"]];
    UITabBarItem*item3=[[UITabBarItem alloc]initWithTitle:@"我的" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    findWorkViewController*fvc=[[findWorkViewController alloc]init];
    fvc.title=@"找活干";
    UITabBarItem*friendItem=[[UITabBarItem alloc]initWithTitle:@"消息" image: [UIImage imageNamed:@"我的-未选择"] selectedImage: [self returnImageFromName:@"我的"]];
    UINavigationController*nc4=[[UINavigationController alloc]initWithRootViewController:fvc];
    nc4.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    nc4.navigationBar.barStyle=1;
    
    friendViewController*frvc=[[friendViewController alloc]init];
    frvc.title=@"消息";
    UINavigationController*friendNC=[[UINavigationController alloc]initWithRootViewController:frvc];
    friendNC.navigationBar.barTintColor=COLOR(22, 168, 234, 1);
    friendNC.navigationBar.barStyle=1;

    UITabBarController*cvc=[[UITabBarController alloc]init];
    cvc.viewControllers=@[nc,nc4,friendNC,nc2];
    cvc.tabBar.selectedImageTintColor=COLOR(0, 166, 237, 1);
    nc.tabBarItem=item1;
    nc1.tabBarItem=item2;
    nc2.tabBarItem=item3;
    nc4.tabBarItem=item2;
    friendNC.tabBarItem=friendItem;
    self.window.rootViewController=cvc;
    if (_havePushMessage) {
        NSString*str=[_pushDictory objectForKey:PUSHKEY];
        NSArray*array=[str componentsSeparatedByString:@"\"type\":\""];
        NSString*type=[array[1] componentsSeparatedByString:@"\"}"][0];
        if ([type isEqualToString:@"masterOrderContact"]==YES||[type isEqualToString:@"masterOrderAccept"]==YES||[type isEqualToString:@"masterOrderReject"]==YES||[type isEqualToString:@"masterOrderFinish"]==YES||[type isEqualToString:@"masterOrderStop"]==YES||[type isEqualToString:@"masterOrderStop"]==YES) {
            cvc.selectedIndex=1;
            NSArray*sepArray=[str componentsSeparatedByString:@"\"entityId\":"];
            NSString*ID=[sepArray[1] componentsSeparatedByString:@","][0];
            MNextOrderDetailViewController*mvc=[[MNextOrderDetailViewController alloc]initWithNibName:@"orderDetailOrderViewController" bundle:nil];
            mvc.id=[ID integerValue];
            [nc1 pushViewController:mvc animated:NO];
           
        }else if ([type isEqualToString:@"personalPass"]==YES||[type isEqualToString:@"personalFail"]==YES||[type isEqualToString:@"masterPostPass"]==YES||[type isEqualToString:@"masterPostFail"]==YES||[type isEqualToString:@"foremanPostPass"]==YES||[type isEqualToString:@"foremanPostFail"]==YES||[type isEqualToString:@"managerPostPass"]==YES||[type isEqualToString:@"managerPostFail"]==YES){
            
        }else if ([type isEqualToString:@"requestRecommend"]==YES){
            cvc.selectedIndex=2;
            myRecommendPeopleViewController*rvc=[[myRecommendPeopleViewController alloc]initWithNibName:@"myRecommendPeopleViewController" bundle:nil];
            rvc.hidesBottomBarWhenPushed=YES;
            [nc2 pushViewController:rvc animated:NO];
        }else if ([type isEqualToString:@"projectAuditPass"]==YES||[type isEqualToString:@"projectAuditFail"]==YES){
        
            cvc.selectedIndex=2;
            myPublicViewController*mvc=[[myPublicViewController alloc]init];
            [nc2 pushViewController:mvc animated:NO];
        }
        
        if (!type) {
            CustomDialogView *dialog = [[CustomDialogView alloc]initWithTitle:@"" message:@"当前账号在其他设备登陆,若非本人操作,你的登陆密码可能已经已经泄露,请及时修改密码.紧急情况可以联系客服" buttonTitles:@"确定", nil];
            [dialog showWithCompletion:^(NSInteger selectIndex) {
                
                [self setLogout];
                
            }];
        }
    }
}


-(UIImage*)returnImageFromName:(NSString*)name{

    UIImage *img = [UIImage imageNamed:name];
    img =  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
    
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
            [delegate requestAdImage];
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
    
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
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
//    });
    
}



-(NSString*)getPhoneType{

    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    NSString* userPhoneName = [[UIDevice currentDevice] name];

    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    else if ([platform isEqualToString:@"iPhone1,2"]) platform= @"iPhone 3G ";
    else if ([platform isEqualToString:@"iPhone3,1"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,2"]) platform= @"iPhone 4";
    else if ([platform isEqualToString:@"iPhone3,3"]) platform= @"iPhone 4";
    else  if ([platform isEqualToString:@"iPhone4,1"]) platform= @"iPhone 4S";
    else if ([platform isEqualToString:@"iPhone5,1"]) platform= @"iPhone 5";
    else  if ([platform isEqualToString:@"iPhone5,2"]) platform= @"iPhone 5";
    else if ([platform isEqualToString:@"iPhone5,3"]) platform= @"iPhone 5c";
    else if ([platform isEqualToString:@"iPhone5,4"]) platform= @"iPhone 5c";
    else  if ([platform isEqualToString:@"iPhone6,1"]) platform= @"iPhone 5s";
    else if ([platform isEqualToString:@"iPhone6,2"]) platform= @"iPhone 5s";
    else  if ([platform isEqualToString:@"iPhone7,1"]) platform= @"iPhone 6 Plus ";
    else  if ([platform isEqualToString:@"iPhone7,2"]) platform= @"iPhone 6";
    else if ([platform isEqualToString:@"iPad2,5"])   platform= @"iPad Mini 1G (A1432)";
    else if ([platform isEqualToString:@"iPad2,6"])   platform= @"iPad Mini 1G (A1454)";
    else if ([platform isEqualToString:@"iPad2,7"])   platform= @"iPad Mini 1G (A1455)";
    
    else if ([platform isEqualToString:@"iPad3,1"])   platform= @"iPad 3 (A1416)";
    else if ([platform isEqualToString:@"iPad3,2"])   platform= @"iPad 3 (A1403)";
   else  if ([platform isEqualToString:@"iPad3,3"])   platform= @"iPad 3 (A1430)";
   else  if ([platform isEqualToString:@"iPad3,4"])   platform= @"iPad 4 (A1458)";
   else  if ([platform isEqualToString:@"iPad3,5"])   platform= @"iPad 4 (A1459)";
  else   if ([platform isEqualToString:@"iPad3,6"])   platform= @"iPad 4 (A1460)";
    
   else  if ([platform isEqualToString:@"iPad4,1"])   platform= @"iPad Air (A1474)";
   else  if ([platform isEqualToString:@"iPad4,2"])   platform= @"iPad Air (A1475)";
   else  if ([platform isEqualToString:@"iPad4,3"])   platform= @"iPad Air (A1476)";
   else  if ([platform isEqualToString:@"iPad4,4"])   platform= @"iPad Mini 2G (A1489)";
    else if ([platform isEqualToString:@"iPad4,5"])   platform= @"iPad Mini 2G (A1490)";
    else if ([platform isEqualToString:@"iPad4,6"])   platform= @"iPad Mini 2G (A1491)";
    
   else  if ([platform isEqualToString:@"i386"])      platform= @"iPhone Simulator";
    else if ([platform isEqualToString:@"x86_64"])    platform= @"iPhone Simulator";
    
    else{
    
        return [NSString stringWithFormat:@"%@的%@",userPhoneName,@"iphone6s/iphone6s+"];
    }
    return [NSString stringWithFormat:@"%@的%@",userPhoneName,platform];

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




//技能筛选项请求
-(void)requestSkills
{
    NSString*urlString=[self interfaceFromString:interface_skill];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSMutableArray*array =[self arrayFromJosn:responseObject Type:@"servicerSkills" Model:@"skillModel"];
        [[dataBase share]deleAllSkillInformation];
        
        for (NSInteger i=0; i<array.count; i++) {
            skillModel*model=array[i];
            [[dataBase share]addSkillModel:model];
            
        }
        
    } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}


//广告栏图片
-(void)requestAdImage{
    [_pictureArray removeAllObjects];
    NSString*urlString=[self interfaceFromString:interface_banners];
    [[httpManager manager]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary*dict=(NSDictionary*)responseObject;
        if ([[dict objectForKey:@"rspCode"] integerValue]==200) {
            NSArray*Array=[dict objectForKey:@"entities"];
            for (NSInteger i=0; i<Array.count; i++) {
                NSDictionary*inforDic=Array[i];
                NSString*url=[[inforDic objectForKey:@"advertising"] objectForKey:@"resource"];
                NSString*temp=[NSString stringWithFormat:@"%@%@",changeURL,url];
                
                [_pictureArray addObject:temp];
            }
        
        }
         [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}





//缓存个人信息
-(void)requestInformation{
    NSString *urlString = [self interfaceFromString:interface_personalDetail];
    [[httpManager share]GET:urlString parameters:nil success:^(AFHTTPRequestOperation *Operation, id responseObject) {
        NSDictionary *dict = (NSDictionary*)responseObject;
        NSDictionary *entityDic = [dict objectForKey:@"entity"];
        NSDictionary *userDic = [entityDic objectForKey:@"user"];
        PersonalDetailModel*model=[[PersonalDetailModel alloc]init];
        [model setValuesForKeysWithDictionary:userDic];
        [[dataBase share]addInformationWithModel:model];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"updateUI" object:nil userInfo:nil];
        } failure:^(AFHTTPRequestOperation *Operation, NSError *error) {
        
    }];
}

-(void)resignNoticeation{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
}


//- (void)registerPushForIOS8{
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//    
//    //Types
//    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//    
//    //Actions
//    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
//    acceptAction.identifier = @"单据通知";
//    acceptAction.title = @"进入";
//    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
//    acceptAction.destructive = NO;
//    acceptAction.authenticationRequired = NO;
//    
//    //Categories
//    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
//    
//    inviteCategory.identifier = @"INVITE_CATEGORY";
//    
//    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
//    
//    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
//    
//    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
//    
//    
//    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
//    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    
//    
//#endif
//}
//

//-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
//    //notification是发送推送时传入的字典信息
//    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
//    
//    //删除推送列表中的这一条
//    [XGPush delLocalNotification:notification];
//    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
//    
//    //清空推送列表
//    //[XGPush clearLocalNotifications];
//}

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

    
//    注册设备
//    [[XGSetting getInstance] setChannel:@"appstore"];
//    [[XGSetting getInstance] setGameServer:@"巨神峰"];

    
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
    
//    if (application.applicationState == UIApplicationStateActive) {
//        [JKNotifier showNotifer:notification.alertBody];
//    }


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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)registerPushForIOS8{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}






@end
