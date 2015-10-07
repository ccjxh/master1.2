//
//  hotRankCollectionViewCell.m
//  master
//
//  Created by jin on 15/10/5.
//  Copyright © 2015年 JXH. All rights reserved.
//

#import "hotRankCollectionViewCell.h"

@implementation hotRankCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.layer.cornerRadius=self.headImage.layer.bounds.size.width/2;
    self.headImage.layer.masksToBounds=YES;
}

@end
