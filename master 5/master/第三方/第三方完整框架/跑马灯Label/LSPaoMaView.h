//
//  LSPaoMaView.h
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTCOLOR [UIColor redColor]
#define TEXTFONTSIZE 16

@interface LSPaoMaView : UIView

@property(nonatomic,strong)NSString*content;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
- (void)start;//开始跑马
- (void)stop;//停止跑马

-(void)reloadData;

@end
