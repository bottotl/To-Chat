//
//  TweetCell.m
//  Step-it-up
//
//  Created by syfll on 15/7/31.
//  Copyright © 2015年 JFT0M. All rights reserved.
//






#import "TweetCell.h"


@implementation TweetCell

@synthesize tweet = _tweet;

-(void)setTweet:(Tweet *)tweet{
    if (_tweet != tweet) {
        _tweet = tweet;
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        //用户头像
        if (!self.ownerImgView) {
            self.ownerImgView = [[UITapImageView alloc] initWithFrame:CGRectMake(10, 10, 33, 33)];
            [self.ownerImgView doCircleFrame];
            [self.contentView addSubview:self.ownerImgView];
        }
        //用户昵称
        if (!self.ownerNameBtn) {
            self.ownerNameBtn = [UIButton initUserButton];
            self.ownerNameBtn.frame = CGRectMake(kTweetCell_PadingLeft, 18, 50, 20);
            [self.ownerNameBtn addTarget:self action:@selector(userBtnClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.ownerNameBtn];
        }
        //发表的时间
        if (!self.timeLabel) {
            self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth - 55, 18, 55, 12)];
            self.timeLabel.font = kTweet_TimtFont;
            self.timeLabel.textAlignment = NSTextAlignmentRight;
            self.timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            [self.contentView addSubview:self.timeLabel];
        }
        //发表的时间前面的闹钟图案
        if (!self.timeClockIconView) {
            self.timeClockIconView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - kPaddingLeftWidth - 70, 20, 12, 12)];
            self.timeClockIconView.image = [UIImage imageNamed:@"time_clock_icon"];
            [self.contentView addSubview:self.timeClockIconView];
        }
        //动态（tweet）的内容
        if (!self.contentLabel) {
            self.contentLabel = [[UITTTAttributedLabel alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, kTweetCell_PadingTop, kTweetCell_ContentWidth, 20)];
            self.contentLabel.font = kTweet_ContentFont;
            self.contentLabel.textColor = [UIColor colorWithHexString:@"0x222222"];
            self.contentLabel.numberOfLines = 0;
            
            self.contentLabel.linkAttributes = kLinkAttributes;
            self.contentLabel.activeLinkAttributes = kLinkAttributesActive;
            self.contentLabel.delegate = self;
            [self.contentLabel addLongPressForCopy];
            [self.contentView addSubview:self.contentLabel];
        }
        //评论按钮
        if (!self.commentBtn) {
            self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.commentBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- kTweetCell_LikeComment_Width, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.commentBtn setImage:[UIImage imageNamed:@"tweet_comment_btn"] forState:UIControlStateNormal];
            [self.commentBtn addTarget:self action:@selector(commentBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.commentBtn];
        }
        //点赞按钮
        if (!self.likeBtn) {
            self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.likeBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- 2*kTweetCell_LikeComment_Width -5, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.likeBtn];
        }
        //删除按钮(先初始化了，哪怕后面不用)
        if (!self.deleteBtn) {
            self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.deleteBtn.frame = CGRectMake(kScreen_Width - kPaddingLeftWidth- 3*kTweetCell_LikeComment_Width -5, 0, kTweetCell_LikeComment_Width, kTweetCell_LikeComment_Height);
            [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateNormal];
            [self.deleteBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            self.deleteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.contentView addSubview:self.deleteBtn];
        }
        //动态（tweet）发表的地点(先初始化了，哪怕后面不用)
        if (!self.locaitonBtn) {
            self.locaitonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.locaitonBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            self.locaitonBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            self.locaitonBtn.frame = CGRectMake(kTweetCell_PadingLeft, 0, 100, 15);
            //            self.locaitonBtn.titleLabel.minimumScaleFactor = 0.80;
            self.locaitonBtn.titleLabel.adjustsFontSizeToFitWidth = NO;
            self.locaitonBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
            [self.locaitonBtn setTitleColor:[UIColor colorWithHexString:@"0x3bbd79"] forState:UIControlStateNormal];
            [self.locaitonBtn addTarget:self action:@selector(locationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.locaitonBtn];
        }
        //动态（tweet）发表的设备(先初始化了，哪怕后面不用)
        if (!self.deviceLabel) {
            self.deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, 100, 15)];
            self.deviceLabel.font = kTweet_TimtFont;
            self.deviceLabel.minimumScaleFactor = 0.50;
            self.deviceLabel.adjustsFontSizeToFitWidth = YES;
            self.deviceLabel.textAlignment = NSTextAlignmentLeft;
            self.deviceLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
            [self.contentView addSubview:self.deviceLabel];
        }
        //评论（点赞）列表前面的的小三角形(先初始化了，哪怕后面不用)
        if (!self.commentOrLikeBeginImgView) {
            self.commentOrLikeBeginImgView = [[UIImageView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft +20, 0, 15, 7)];
            self.commentOrLikeBeginImgView.image = [UIImage imageNamed:@"commentOrLikeBeginImg"];
            [self.contentView addSubview:self.commentOrLikeBeginImgView];
        }
        
        if (!self.likeUsersView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.likeUsersView = [[UICollectionView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 35) collectionViewLayout:layout];
            self.likeUsersView.scrollEnabled = NO;
            [self.likeUsersView setBackgroundView:nil];
            [self.likeUsersView setBackgroundColor:kColorTableSectionBg];
            [self.likeUsersView registerClass:[TweetLikeUserCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetLikeUser];
            self.likeUsersView.dataSource = self;
            self.likeUsersView.delegate = self;
            [self.contentView addSubview:self.likeUsersView];
        }
        
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.mediaView = [[UICustomCollectionView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 80) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor clearColor]];
            [self.mediaView registerClass:[TweetMediaItemCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItem];
            [self.mediaView registerClass:[TweetMediaItemSingleCCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItemSingle];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self.contentView addSubview:self.mediaView];
        }
        
        
        if (!self.commentListView) {
            self.commentListView = [[UITableView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 20) style:UITableViewStylePlain];
            self.commentListView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.commentListView.scrollEnabled = NO;
            [self.commentListView setBackgroundView:nil];
            [self.commentListView setBackgroundColor:kColorTableSectionBg];
            [self.commentListView registerClass:[TweetCommentCell class] forCellReuseIdentifier:kCellIdentifier_TweetComment];
            [self.commentListView registerClass:[TweetCommentMoreCell class] forCellReuseIdentifier:kCellIdentifier_TweetCommentMore];
            self.commentListView.dataSource = self;
            self.commentListView.delegate = self;
            [self.contentView addSubview:self.commentListView];
        }
        
        if (!_commentOrLikeSplitlineView) {
            _commentOrLikeSplitlineView = [[UIImageView alloc] initWithFrame:CGRectMake(kTweetCell_PadingLeft, 0, kTweetCell_ContentWidth, 1)];
            _commentOrLikeSplitlineView.image = [UIImage imageNamed:@"splitlineImg"];
            [self.contentView addSubview:_commentOrLikeSplitlineView];
        }



    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (!_tweet) {
        return;
    }
    //owner头像
    __weak __typeof(self)weakSelf = self;
    [self.ownerImgView setImageWithUrl:[_tweet.user.avatar urlImageWithCodePathResizeToView:_ownerImgView] placeholderImage:kPlaceholderMonkeyRoundView(_ownerImgView) tapBlock:^(id obj) {
        [weakSelf userBtnClicked];
    }];
    //owner姓名
    [self.ownerNameBtn setUserTitle:_tweet.user.name font:[UIFont systemFontOfSize:17] maxWidth:(kTweetCell_ContentWidth-85)];
    
    [self.contentLabel setLongString:_tweet.content withFitWidth:kTweetCell_ContentWidth maxHeight:kTweet_ContentMaxHeight];
    for (HtmlMediaItem *item in _tweet.htmlMedia.mediaItems) {
        if (item.displayStr.length > 0 && !(item.type == HtmlMediaItemType_Code ||item.type == HtmlMediaItemType_EmotionEmoji)) {
            [self.contentLabel addLinkToTransitInformation:[NSDictionary dictionaryWithObject:item forKey:@"value"] withRange:item.range];
        }
    }
    
    CGFloat curBottomY = kTweetCell_PadingTop +[_tweet contentLabelHeight] +10;
    
    //图片缩略图展示
    if (_tweet.htmlMedia.imageItems.count > 0) {
        
        CGFloat mediaHeight = [_tweet contentMediaHeight];
        [self.mediaView setFrame:CGRectMake(kTweetCell_PadingLeft, curBottomY, kTweetCell_ContentWidth, mediaHeight)];
        [self.mediaView reloadData];
        self.mediaView.hidden = NO;
        
        curBottomY += mediaHeight;
    }else{
        if (self.mediaView) {
            self.mediaView.hidden = YES;
        }
    }
    
    //这条动态（tweet）发表的时间
    [self.timeLabel setLongString:[_tweet.time stringTimesAgo] withVariableWidth:kScreen_Width/2];
    CGFloat timeLabelX = kScreen_Width - kPaddingLeftWidth - CGRectGetWidth(self.timeLabel.frame);
    [self.timeLabel setX:timeLabelX];
    [self.timeClockIconView setX:timeLabelX-15];
    
    curBottomY += 10;
    
    //是否是我发表的
    BOOL isMineTweet = [_tweet.user.global_key isEqualToString:[Login curLoginUser].global_key];
    
    //以下两段if-else 已经判断了4种情况，经过精简得出
    //经需求修改，位置信息只会存在于设备信息上方
    if (_tweet.location.length > 0) {
        [self.locaitonBtn setTitle:_tweet.location forState:UIControlStateNormal];
        self.locaitonBtn.frame = CGRectMake(kTweetCell_PadingLeft, curBottomY +5,
                                            (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 20), 15);
        self.locaitonBtn.hidden = NO;
        //        if(_tweet.device.length > 0) {
        curBottomY += CGRectGetHeight(self.locaitonBtn.bounds) + kTweetCell_LocationCCell_Pading;
        //        }
    }else {
        self.locaitonBtn.hidden = YES;
    }
    
    if(_tweet.device.length > 0) {
        self.deviceLabel.text = [NSString stringWithFormat:@"来自 %@", _tweet.device];
        self.deviceLabel.frame = CGRectMake(kTweetCell_PadingLeft, curBottomY +5,
                                          (isMineTweet? (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 3*kTweetCell_LikeComment_Width- 10):
                                           (kScreen_Width - kTweetCell_PadingLeft- kPaddingLeftWidth- 2*kTweetCell_LikeComment_Width- 10)), 15);
        self.deviceLabel.hidden = NO;
    }else {
        self.deviceLabel.hidden = YES;
    }
    
    //喜欢&评论 按钮
    [self.likeBtn setImage:[UIImage imageNamed:(_tweet.isLiked? @"tweet_liked_btn":@"tweet_like_btn")] forState:UIControlStateNormal];
    [self.likeBtn setY:curBottomY];
    [self.commentBtn setY:curBottomY];
    if (isMineTweet) {
        [self.deleteBtn setY:curBottomY];
        self.deleteBtn.hidden = NO;
    }else{
        self.deleteBtn.hidden = YES;
    }
    
    
    curBottomY += kTweetCell_LikeComment_Height;
    curBottomY += [TweetCell likeCommentBtn_BottomPadingWithTweet:_tweet];
    
    
    curBottomY += 5;
    if ([_tweet numOfLikers] > 0 || _tweet.numOfComments > 0) {
        [_commentOrLikeBeginImgView setY:(curBottomY - CGRectGetHeight(_commentOrLikeBeginImgView.frame))];
        _commentOrLikeBeginImgView.hidden = NO;
    }else{
        _commentOrLikeBeginImgView.hidden = YES;
    }
    
    //点赞的人_列表
    //    可有可无
    if (_tweet.numOfLikers > 0) {
        
        CGFloat likeUsersHeight = [_tweet likeUsersHeightWithTweet];
        [self.likeUsersView setFrame:CGRectMake(kTweetCell_PadingLeft, curBottomY, kTweetCell_ContentWidth, likeUsersHeight)];
        [self.likeUsersView reloadData];
        self.likeUsersView.hidden = NO;
        curBottomY += likeUsersHeight;
    }else{
        if (self.likeUsersView) {
            self.likeUsersView.hidden = YES;
        }
    }
    
    //评论与赞的分割线
    if (_tweet.numOfLikers > 0 && _tweet.numOfComments > 0) {
        [_commentOrLikeSplitlineView setY:(curBottomY -1)];
        _commentOrLikeSplitlineView.hidden = NO;
    }else{
        _commentOrLikeSplitlineView.hidden = YES;
    }
    
    //评论的人_列表
    //    可有可无
    if (_tweet.numOfComments > 0) {
        CGFloat commentListViewHeight = [_tweet commentListViewHeight];
        [self.commentListView setFrame:CGRectMake(kTweetCell_PadingLeft, curBottomY, kTweetCell_ContentWidth, commentListViewHeight)];
        [self.commentListView reloadData];
        self.commentListView.hidden = NO;
    }else{
        if (self.commentListView) {
            self.commentListView.hidden = YES;
        }
    }
}
#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger row = 0;
    if (collectionView == _mediaView) {
        row = _tweet.htmlMedia.imageItems.count;
    }else{
        row = _tweet.numOfLikers;
    }
    return row;
}


//页面里面的两个collectionView（用来显示图片和显示点赞的用户的头像）都用到这个函数所以需要判断
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //两个collectionView都用到这个函数
    if (collectionView == _mediaView) {
        HtmlMediaItem *curMediaItem = [_tweet.htmlMedia.imageItems objectAtIndex:indexPath.row];
        if (_tweet.htmlMedia.imageItems.count == 1) {
            TweetMediaItemSingleCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItemSingle forIndexPath:indexPath];
            ccell.curMediaItem = curMediaItem;
            ccell.refreshSingleCCellBlock = ^(){
                if (_refreshSingleCCellBlock) {
                    _refreshSingleCCellBlock();
                }
            };
            [_imageViewsDict setObject:ccell.imgView forKey:indexPath];
            return ccell;
        }else{
            TweetMediaItemCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetMediaItem forIndexPath:indexPath];
            ccell.curMediaItem = curMediaItem;
            [_imageViewsDict setObject:ccell.imgView forKey:indexPath];
            return ccell;
        }
    }else{
        TweetLikeUserCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetLikeUser forIndexPath:indexPath];
        if (indexPath.row >= _tweet.numOfLikers-1 && _tweet.hasMoreLikers) {
            [ccell configWithUser:nil likesNum:[[NSNumber alloc]initWithInteger: _tweet.numOfLikers]];
        }else{
            User *curUser = [_tweet.like_users objectAtIndex:indexPath.row];
            [ccell configWithUser:curUser likesNum:nil];
        }
        return ccell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize itemSize;
    if (collectionView == _mediaView) {
        if (_tweet.htmlMedia.imageItems.count == 1) {
            itemSize = [TweetMediaItemSingleCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
        }else{
            itemSize = [TweetMediaItemCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
        }
    }else{
        itemSize = CGSizeMake(kTweetCell_LikeUserCCell_Height, kTweetCell_LikeUserCCell_Height);
    }
    return itemSize;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    UIEdgeInsets insetForSection;
    if (collectionView == _mediaView) {
        if (_tweet.htmlMedia.imageItems.count == 1) {
            CGSize itemSize = [TweetMediaItemSingleCCell ccellSizeWithObj:_tweet.htmlMedia.imageItems.firstObject];
            insetForSection = UIEdgeInsetsMake(0, 0, 0, kTweetCell_ContentWidth - itemSize.width);
        }else{
            insetForSection = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }else{
        insetForSection = UIEdgeInsetsMake(kTweetCell_LikeUserCCell_Pading, 5, kTweetCell_LikeUserCCell_Pading, 5);
    }
    return insetForSection;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kTweetCell_LikeUserCCell_Pading;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kTweetCell_LikeUserCCell_Pading/2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _mediaView) {
        //        显示大图
        int count = (int)_tweet.htmlMedia.imageItems.count;
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++) {
            HtmlMediaItem *imageItem = [_tweet.htmlMedia.imageItems objectAtIndex:i];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:imageItem.src]; // 图片路径
            photo.srcImageView = [_imageViewsDict objectForKey:[NSIndexPath indexPathForItem:i inSection:0]]; // 来源于哪个UIImageView
            [photos addObject:photo];
        }
        
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    }else{
        if (indexPath.row >= _tweet.numOfLikers-1 && _tweet.hasMoreLikers) {
            if (_moreLikersBtnClickedBlock) {
                _moreLikersBtnClickedBlock(_tweet);
            }
        }else{
            User *curUser = [_tweet.like_users objectAtIndex:indexPath.row];
            if (_userBtnClickedBlock) {
                _userBtnClickedBlock(curUser);
            }
        }
    }
}
#pragma mark Table M comments
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tweet.numOfComments;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= _tweet.numOfComments-1 && _tweet.hasMoreComments) {
        TweetCommentMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TweetCommentMore forIndexPath:indexPath];
        cell.commentNum = [[NSNumber alloc]initWithInteger:_tweet.numOfComments];
        return cell;
    }else{
        TweetCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_TweetComment forIndexPath:indexPath];
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];
        [cell configWithComment:curComment topLine:(indexPath.row != 0)];
        cell.commentLabel.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = 0;
    if (indexPath.row >= _tweet.numOfComments-1 && _tweet.hasMoreComments) {
        cellHeight = [TweetCommentMoreCell cellHeight];
    }else{
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];
        cellHeight = [TweetCommentCell cellHeightWithObj:curComment];
    }
    return cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= _tweet.numOfComments-1 && _tweet.hasMoreComments) {
        DebugLog(@"More Comment");
        if (_goToDetailTweetBlock) {
            _goToDetailTweetBlock(_tweet);
        }
    }else{
        if (_commentClickedBlock) {
            _commentClickedBlock(_tweet, indexPath.row, [tableView cellForRowAtIndexPath:indexPath]);
        }
    }
}
#pragma mark Table Copy
//
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= _tweet.numOfComments-1 && _tweet.hasMoreComments) {
        return NO;
    }
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        Comment *curComment = [_tweet.comment_list objectAtIndex:indexPath.row];
        [UIPasteboard generalPasteboard].string = curComment.content? curComment.content: @"";
    }
}


#pragma mark Btn M
- (void)likeBtnClicked:(id)sender{
    _tweet.isLiked = !_tweet.isLiked;
    NSLog(@"点赞\n");
    [self.likeBtn setImage:[UIImage imageNamed:(_tweet.isLiked? @"tweet_liked_btn":@"tweet_like_btn")] forState:UIControlStateNormal];
    if (_likeBtnClickedBlock) {
     _likeBtnClickedBlock(_tweet);
    }
}
- (void)commentBtnClicked:(id)sender{
    if (_commentClickedBlock) {
        _commentClickedBlock(_tweet, -1, sender);
    }
}
- (void)deleteBtnClicked:(UIButton *)sender{
    if (_deleteClickedBlock) {
        _deleteClickedBlock(_tweet, _outTweetsIndex);
    }
}

- (void)userBtnClicked{
    if (_userBtnClickedBlock) {
        _userBtnClickedBlock(_tweet.user);
    }
}
- (void)locationBtnClicked:(id)sender{
    if (_locationClickedBlock) {
        _locationClickedBlock(_tweet);
    }
}
#pragma mark TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components{
    if (_mediaItemClickedBlock) {
        _mediaItemClickedBlock([components objectForKey:@"value"]);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    Tweet *tweet = (Tweet *)obj;
    CGFloat cellHeight = 0;
    if (tweet.numOfComments > 0 || tweet.numOfLikers > 0) {
        cellHeight = 6;
    }else{
        cellHeight = 3;
    }
    cellHeight += 20;
    cellHeight += kTweetCell_PadingTop;
    cellHeight += [TweetCell contentLabelHeightWithTweet:tweet];
    cellHeight += [TweetCell contentMediaHeightWithTweet:tweet];
    cellHeight += kTweetCell_LikeComment_Height;
    cellHeight += [[self class] locationHeightWithTweet:tweet];
    cellHeight += [TweetCell likeCommentBtn_BottomPadingWithTweet:tweet];
    cellHeight += [TweetCell likeUsersHeightWithTweet:tweet];
    cellHeight += [TweetCell commentListViewHeightWithTweet:tweet];
    cellHeight += kTweetCell_PadingBottom;
    return cellHeight;
}

+ (CGFloat)contentLabelHeightWithTweet:(Tweet *)tweet{
    return MIN(kTweet_ContentMaxHeight, [tweet.content getHeightWithFont:kTweet_ContentFont constrainedToSize:CGSizeMake(kTweetCell_ContentWidth, CGFLOAT_MAX)]);
}

+ (CGFloat)contentMediaHeightWithTweet:(Tweet *)tweet{
    CGFloat contentMediaHeight = 0;
    NSInteger mediaCount = tweet.htmlMedia.imageItems.count;
    if (mediaCount > 0) {
        HtmlMediaItem *curMediaItem = tweet.htmlMedia.imageItems.firstObject;
        contentMediaHeight = (mediaCount == 1)?
        [TweetMediaItemSingleCCell ccellSizeWithObj:curMediaItem].height:
        ceilf((float)mediaCount/3)*([TweetMediaItemCCell ccellSizeWithObj:curMediaItem].height+kTweetCell_LikeUserCCell_Pading) - kTweetCell_LikeUserCCell_Pading;
    }
    return contentMediaHeight;
}

+ (CGFloat)likeCommentBtn_BottomPadingWithTweet:(Tweet *)tweet{
    if (tweet &&
        (tweet.numOfLikers > 0)){
        return 5.0;
    }else{
        return 0;
    }
}
+ (CGFloat)locationHeightWithTweet:(Tweet *)tweet{
    CGFloat ocationHeight = 0;
    if ( tweet.location.length > 0) {
        ocationHeight = 15 + kTweetCell_LocationCCell_Pading;
    }else{
        ocationHeight = 0;
    }
    return ocationHeight;
}


+ (CGFloat)likeUsersHeightWithTweet:(Tweet *)tweet{
    CGFloat likeUsersHeight = 0;
    if (tweet.numOfLikers> 0) {
        likeUsersHeight = 45;
        //        +30*(ceilf([tweet.like_users count]/kTweet_LikeUsersLineCount)-1);
    }
    return likeUsersHeight;
}

+ (CGFloat)commentListViewHeightWithTweet:(Tweet *)tweet{
    if (!tweet) {
        return 0;
    }
    CGFloat commentListViewHeight = 0;
    
    NSInteger numOfComments = tweet.numOfComments;
    BOOL hasMoreComments = tweet.hasMoreComments;
    
    for (int i = 0; i < numOfComments; i++) {
        if (i == numOfComments-1 && hasMoreComments) {
            commentListViewHeight += [TweetCommentMoreCell cellHeight];
        }else{
            Comment *curComment = [tweet.comment_list objectAtIndex:i];
            commentListViewHeight += [TweetCommentCell cellHeightWithObj:curComment];
        }
    }
    return commentListViewHeight;
}

@end
