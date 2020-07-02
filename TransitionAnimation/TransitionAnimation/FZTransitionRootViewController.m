//
//  FZTransitionRootViewController.m
//  TransitionAnimation
//
//  Created by 张发政 on 2020/7/2.
//  Copyright © 2020 张发政. All rights reserved.
//

#import "FZTransitionRootViewController.h"
#import "FZTransitionSecondViewController.h"

@interface FZTransitionRootViewController ()
@property (nonatomic, strong) UIImageView * customImageView;
@property (nonatomic, strong) UIButton *customButton;
@end

@implementation FZTransitionRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.customImageView];
    [self.view addSubview:self.customButton];
}

- (void)jumpAction{
    FZTransitionSecondViewController *vc = [FZTransitionSecondViewController new];
    vc.resources = self.customImageView.image;
    vc.startFrame = self.customImageView.frame;
    [self presentViewController:vc animated:YES completion:nil];
}

- (UIImageView *)customImageView{
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc]init];
        _customImageView.image = [UIImage imageNamed:@"army"];
        [_customImageView sizeToFit];
        _customImageView.frame = CGRectMake((self.view.frame.size.width - _customImageView.frame.size.width)/2, (self.view.frame.size.height - _customImageView.frame.size.height)/2, _customImageView.frame.size.width, _customImageView.frame.size.height);
    }
    return _customImageView;
}

- (UIButton *)customButton{
    if (!_customButton) {
        _customButton = [[UIButton alloc]initWithFrame:CGRectMake(30, _customImageView.frame.origin.y+_customImageView.frame.size.height, self.view.frame.size.width - 60, 44)];
        _customButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_customButton setTitle:@"Aramy" forState:UIControlStateNormal];
        [_customButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [_customButton addTarget:self action:@selector(jumpAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customButton;
}


@end
