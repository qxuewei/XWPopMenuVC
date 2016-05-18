//
//  ViewController.m
//  XWPopMenuVCDemo
//
//  Created by 邱学伟 on 16/5/17.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "XWPopMenuController.h"
#import "UIImage+XW.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//发布按钮点击事件
- (IBAction)publishClick:(UIButton *)sender {
    NSLog(@"点击发布按钮->");
    XWPopMenuController *vc = [[XWPopMenuController alloc]init];
    
    //虚化背景
    UIImage *image = [UIImage imageWithCaputureView:self.view];
    
    vc.backImg = image;
    
    [self presentViewController:vc animated:NO completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
