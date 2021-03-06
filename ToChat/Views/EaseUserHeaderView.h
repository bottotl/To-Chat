//
//  EaseUserHeaderView.h
//  Coding_iOS
//
//  Created by Ease on 15/3/17.
//  Copyright (c) 2015年 Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Login.h"
#import "User.h"
#import "UITapImageView.h"

@interface EaseUserHeaderView : UITapImageView
@property (strong, nonatomic) User *curUser;
@property (strong, nonatomic) UIImage *bgImage;

@property (nonatomic, copy) void (^userIconClicked)();
@property (nonatomic, copy) void (^fansCountBtnClicked)();
@property (nonatomic, copy) void (^followsCountBtnClicked)();
@property (nonatomic, copy) void (^followBtnClicked)();

+ (id)userHeaderViewWithUser:(User *)user image:(UIImage *)image;
- (void)updateData;

@end
