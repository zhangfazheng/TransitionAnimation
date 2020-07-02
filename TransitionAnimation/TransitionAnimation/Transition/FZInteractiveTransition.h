//
//  FZInteractiveTransition.h
//  TransitionAnimation
//
//  Created by 张发政 on 2020/7/2.
//  Copyright © 2020 张发政. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+ScreensShot.h"
typedef NS_ENUM(NSUInteger, FZPresentOneTransitionType) {
    FZPresentOneTransitionTypePresent = 0,//管理present动画
    FZPresentOneTransitionTypeDismiss//管理dismiss动画
};

typedef NS_ENUM(NSUInteger, FZTransitionStyleType) {
    FZTransitionStyleTypeVideoDetails = 0,
    FZTransitionStyleTypeAuthorVideoSet ,
    FZTransitionStyleTypePlayVideo
};
NS_ASSUME_NONNULL_BEGIN

@interface FZInteractiveTransition : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign) FZPresentOneTransitionType type;
@property (nonatomic, assign) FZTransitionStyleType transitionStyleType;
@property (nonatomic, assign) CGRect startFrame;
@property (nonatomic, strong) UIImage* resources;
+ (instancetype)transitionWithTransitionType:(FZPresentOneTransitionType)type;
- (instancetype)initWithTransitionType:(FZPresentOneTransitionType)type;

@end

NS_ASSUME_NONNULL_END
