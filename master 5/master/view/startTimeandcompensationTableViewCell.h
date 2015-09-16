//
//  startTimeandcompensationTableViewCell.h
//  master
//
//  Created by jin on 15/9/16.
//  Copyright (c) 2015年 JXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface startTimeandcompensationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textviewHeight;
-(void)setContentWithModel:(NSString*)content;
@end
