//
//  FZTransitionSecondViewController.m
//  TransitionAnimation
//
//  Created by 张发政 on 2020/7/2.
//  Copyright © 2020 张发政. All rights reserved.
//

#import "FZTransitionSecondViewController.h"
#import "UIImage+ImageEffects.h"
#import "FZInteractiveTransition.h"

@interface FZTransitionSecondViewController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView * customImageView;
@property (nonatomic, strong) UIButton *customButton;
@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) FZInteractiveTransition *transitionManage;
@end

@implementation FZTransitionSecondViewController

- (instancetype)init{
    if (self = [super init]) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        _transitionManage = [[FZInteractiveTransition alloc] init];
        _transitionManage.transitionStyleType = FZTransitionStyleTypeVideoDetails;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.customImageView];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.customButton];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    _transitionManage.type = FZPresentOneTransitionTypePresent;
    return _transitionManage;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    _transitionManage.type = FZPresentOneTransitionTypeDismiss;
    return _transitionManage;
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)customImageView{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc]init];
        _customImageView.image = self.resources;
        _customImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height/2)+40);
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _customImageView;
}

- (UIButton *)customButton{
    if (!_customButton) {
        _customButton = [[UIButton alloc]initWithFrame:CGRectMake(30, _customImageView.frame.origin.y+_customImageView.frame.size.height, self.view.frame.size.width - 60, 44)];
        _customButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_customButton setTitle:@"Bcak" forState:UIControlStateNormal];
        [_customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_customButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}

- (UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.image = [self.resources blurImage];
        _backgroundImageView.frame = CGRectMake(0, (self.view.frame.size.height/2)+40, self.view.frame.size.width, (self.view.frame.size.height/2)-40);
    }
    return _backgroundImageView;
}

- (void)setResources:(UIImage *)resources{
    _resources = resources;
    _transitionManage.resources = resources;
}

- (void)setStartFrame:(CGRect)startFrame{
    _startFrame = startFrame;
    _transitionManage.startFrame = startFrame;
}

@end
