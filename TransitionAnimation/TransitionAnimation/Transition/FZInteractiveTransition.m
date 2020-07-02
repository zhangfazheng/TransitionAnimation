//
//  FZInteractiveTransition.m
//  TransitionAnimation
//
//  Created by 张发政 on 2020/7/2.
//  Copyright © 2020 张发政. All rights reserved.
//

#import "FZInteractiveTransition.h"
#import "UIImage+ImageEffects.h"
#import "UIView+ScreensShot.h"

@implementation FZInteractiveTransition
+ (instancetype)transitionWithTransitionType:(FZPresentOneTransitionType)type
{
    FZInteractiveTransition *tranistion = [[FZInteractiveTransition alloc] initWithTransitionType:type];
    return tranistion;
}

- (instancetype)initWithTransitionType:(FZPresentOneTransitionType)type
{
    if (self) {
        self = [super init];
        self.type = type;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //为了将两种动画的逻辑分开，变得更加清晰，我们分开书写逻辑，
    switch (_type) {
        case FZPresentOneTransitionTypePresent:
            if (_transitionStyleType == FZTransitionStyleTypeVideoDetails) {
                [self presentAnimation:transitionContext];
            }else if (_transitionStyleType == FZTransitionStyleTypeAuthorVideoSet){
                [self videoSetPresentAnimation:transitionContext];
            }else if (_transitionStyleType == FZTransitionStyleTypePlayVideo){
                [self videoPlayPresentAnimation:transitionContext];
            }
            break;
            
        case FZPresentOneTransitionTypeDismiss:
            if (_transitionStyleType == FZTransitionStyleTypeVideoDetails) {
                [self dismissAnimation:transitionContext];
            }else if (_transitionStyleType == FZTransitionStyleTypeAuthorVideoSet){
                [self videoSetDismissAnimation:transitionContext];
            }else if (_transitionStyleType == FZTransitionStyleTypePlayVideo){
                [self videoPlayDismissAnimation:transitionContext];
            }
            break;
    }
}

- (void)videoPlayPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIImage *imageSc = [fromVC.view screenShot];
    fromVC.view.hidden = true;
    toVC.view.hidden = false;
    UIImageView *snapView = [[UIImageView alloc] initWithImage:imageSc];
    snapView.frame = fromVC.view.frame;
    
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapView];
    
    toVC.view.alpha = 0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        snapView.alpha = 0.0f;
    }];
    [UIView animateWithDuration:0.2 delay:0.2 options:0 animations:^{
        toVC.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromVC.view.hidden = false;
        [snapView removeFromSuperview];
    }];
}

- (void)videoPlayDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    fromVC.view.hidden = NO;
    toVC.view.hidden = false;
    
    [containerView addSubview:fromVC.view];
    
    toVC.view.alpha = 0.0f;
    [UIView animateWithDuration:0.2 animations:^{
        fromVC.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    [UIView animateWithDuration:0.2 delay:0.4 options:0 animations:^{
        toVC.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        fromVC.view.hidden = false;
        //[snapView removeFromSuperview];
    }];
}

- (void)videoSetPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    UIImage *imageSc = [fromVC.view screenShot];
    UIImageView *snapView = [[UIImageView alloc] initWithImage:imageSc];
    snapView.frame = fromVC.view.frame;
    fromVC.view.hidden = true;
    [containerView addSubview:toVC.view];
    [containerView addSubview:snapView];
    
    //UIImage *blur = [_resources blurredImageWithRadius:80 iterations:2.0f tintColor:[UIColor clearColor]];
    UIImageView *blurImage = [[UIImageView alloc] initWithFrame:_startFrame];
    blurImage.image = _resources;
    blurImage.alpha = 0.0f;
    [snapView addSubview:blurImage];
    
    [UIView animateWithDuration:0.2 animations:^{
        blurImage.alpha = 1.0f;
    }];
    
    [UIView animateWithDuration:0.3 delay:0.1 options:0 animations:^{
       
        blurImage.frame = CGRectMake(0, 0, blurImage.frame.size.width, snapView.frame.size.height);
        
    } completion:^(BOOL finished) {
        toVC.view.alpha = 0.0f;
        [UIView animateWithDuration:0.2 animations:^{
            toVC.view.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
            fromVC.view.hidden = false;
            [snapView removeFromSuperview];
        }];
    }];
}

- (void)videoSetDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toVC.view.alpha = 1.0f;
    toVC.view.hidden = false;
    fromVC.view.hidden = false;
    fromVC.view.alpha = 1.0f;
    
    UIImage *imageSc = [toVC.view screenShot];
    UIImageView *snapView = [[UIImageView alloc] initWithImage:imageSc];
    snapView.frame = toVC.view.frame;
    
    UIImageView *blurImage = [[UIImageView alloc] initWithFrame:fromVC.view.bounds];
    [containerView addSubview:fromVC.view];
    [containerView addSubview:snapView];
    blurImage.image = _resources;
    blurImage.frame = fromVC.view.bounds;
    blurImage.alpha = 0.0f;
    [snapView addSubview:blurImage];
    
    [UIView animateWithDuration:0.3 animations:^{
        blurImage.alpha = 1.f;
    } completion:^(BOOL finished) {
        //动画吧
        [UIView animateWithDuration:0.3f animations:^{
            
            blurImage.frame  = self.startFrame;
            
        }];
    }];
    
    [UIView animateWithDuration:0.1 delay:0.3 options:0 animations:^{
        blurImage.alpha = 0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了标记失败
            //[transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            fromVC.view.hidden = false;
            fromVC.view.alpha = 1;
            toVC.view.hidden = NO;
            toVC.view.alpha = 1.f;
            [blurImage removeFromSuperview];
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }
    }];
}

//实现present动画逻辑代码
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIImage *image = [fromVC.view screenShot];
    UIImageView *snapView = [[UIImageView alloc] initWithImage:image];
    snapView.alpha = 1.0f;
    snapView.frame = fromVC.view.frame;
    //因为对截图做动画，vc1就可以隐藏了
    toVC.view.alpha = 0;
    fromVC.view.hidden = true;
    //这里有个重要的概念containerView，如果要对视图做转场动画，视图就必须要加入containerView中才能进行，可以理解containerView管理着所有做转场动画的视图
    UIView *containerView = [transitionContext containerView];
    //将截图视图和vc2的view都加入ContainerView中
    [containerView addSubview:snapView];
    [containerView addSubview:toVC.view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_startFrame];
    imageView.image = _resources;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIImage *blur = [_resources blurImage];//[_resources blurredImageWithRadius:100 iterations:2.0f tintColor:[UIColor clearColor]];
    
    UIImageView *detailsView = [[UIImageView alloc] initWithFrame:_startFrame];
    detailsView.image = blur;
    
    [snapView addSubview:detailsView];
    [snapView addSubview:imageView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:0 animations:^{
        imageView.frame   = CGRectMake(0, 0, toVC.view.frame.size.width, (toVC.view.frame.size.height/2)+40);
        detailsView.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame), toVC.view.frame.size.width, toVC.view.frame.size.height - imageView.frame.size.height);
    } completion:nil];
    
    [UIView animateWithDuration:0.2 delay:0.3 options:0 animations:^{
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [snapView  removeFromSuperview];
    }];
    
}
//实现dismiss动画逻辑代码
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    toVC.view.hidden = false;
    fromVC.view.hidden = true;
    //参照present动画的逻辑，present成功后，containerView的最后一个子视图就是截图视图，我们将其取出准备动画
    UIImage *image = [toVC.view screenShot];
    UIImageView *snapView = [[UIImageView alloc] initWithImage:image];
    snapView.frame = fromVC.view.frame;
    [containerView addSubview:fromVC.view];
    [containerView addSubview:snapView];
        
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, toVC.view.frame.size.width, (toVC.view.frame.size.height/2)+40)];
    imageView.image = _resources;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
        
    //MoreInfoView *blurImage = [[MoreInfoView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), toVC.view.frame.size.width, toVC.view.frame.size.height - imageView.height)];
    //blurImage.isBlur = YES;
    UIImage *blur = [_resources blurImage];//[_resources blurredImageWithRadius:80 iterations:1.5f tintColor:[UIColor clearColor]];
    //blurImage.image = blur;
    
    UIImageView *detailsView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), toVC.view.frame.size.width, toVC.view.frame.size.height - imageView.frame.size.height)];
    detailsView.image = blur;
    //[blurImage addSubview:detailsView];
    
    [snapView addSubview:detailsView];
    [snapView addSubview:imageView];
        
        //动画吧
    [UIView animateWithDuration:0.3f animations:^{
            
        imageView.frame   = self.startFrame;
        //blurImage.frame   = _startFrame;
        detailsView.frame = self.startFrame;
            
    }];
    [UIView animateWithDuration:0.2 delay:0.3 options:0 animations:^{
        snapView.alpha = 0;
    } completion:^(BOOL finished) {
        if ([transitionContext transitionWasCancelled]) {
            //失败了标记失败
            [transitionContext completeTransition:NO];
        }else{
            //如果成功了，我们需要标记成功，同时让vc1显示出来，然后移除截图视图，
            [transitionContext completeTransition:YES];
            fromVC.view.hidden = false;
            toVC.view.hidden = NO;
            [snapView removeFromSuperview];
        }
    }];
    
}
@end
