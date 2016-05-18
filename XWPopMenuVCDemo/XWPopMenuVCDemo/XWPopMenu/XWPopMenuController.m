//
//  XWPopMenuController.m
//  Spread
//
//  Created by 邱学伟 on 16/4/22.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWPopMenuController.h"
#import "PublishMenuButton.h"

//导入自定义控制器->
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"

//自定义颜色rgba
#define ColorWithRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1.0] //<<< 用10进制表示颜色，例如（255,255,255）黑色

//屏幕尺寸
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface XWPopMenuController ()

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *itemButtons;

@property(assign,nonatomic)NSUInteger upIndex;

@property(assign,nonatomic)NSUInteger downIndex;

@property(strong,nonatomic)UIImageView *closeImgView;

@property(strong,nonatomic)NSArray *ary;

@end

@implementation XWPopMenuController

- (NSMutableArray *)itemButtons
{
    if (_itemButtons == nil) {
        _itemButtons = [NSMutableArray array];
    }
    return _itemButtons;
}

-(NSArray *)ary{
    
    if (_ary==nil) {
        
        _ary = [NSArray array];
        
        _ary = @[@"group-2",@"group-3",@"group-4"];
    }
    
    return _ary;
}

//重新初始化主视图样式 透明->
-(void)loadView{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [view setBackgroundColor:[UIColor blackColor]];
    
    //获取截取的背景图片，便于达到模糊背景效果
    UIImageView *imgView = [[UIImageView alloc]initWithImage:_backImg];
    
    //模糊效果层
    UIView *blurView =[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [blurView setBackgroundColor:ColorWithRGBA(64, 64, 64, 0.9)];// [UIColor colorWithWhite:0.9 alpha:0.8]];
    
    [imgView addSubview:blurView];
    
    [view addSubview:imgView];
    
    self.view = view;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加菜单按钮
    [self setMenu];
    //添加底部关闭按钮
    [self insertCloseImg];
    
    //定时器控制每个按钮弹出的时间
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(popupBtn) userInfo:nil repeats:YES];
    
    //添加手势点击事件
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesBegan:)];
    [self.view addGestureRecognizer:touch];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.6 animations:^{
        
        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, M_PI);
    }];
}

//关闭图片
- (void)insertCloseImg{
    
    UIImage *img = [UIImage imageNamed:@"popPlus"];
    
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    
    imgView.frame = CGRectMake(self.view.center.x-15, self.view.frame.size.height-45, 30, 30);
    
    [self.view addSubview:imgView];
    
    _closeImgView = imgView;
    
}


- (void)popupBtn{
    
    if (_upIndex == self.itemButtons.count) {
        
        [self.timer invalidate];
        
        _upIndex = 0;
        
        return;
    }
    
    PublishMenuButton *btn = self.itemButtons[_upIndex];
    
    [self setUpOneBtnAnim:btn];
    
    _upIndex++;
}

//设置按钮从第一个开始向上滑动显示
- (void)setUpOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        btn.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        
        //获取当前显示的菜单控件的索引
        _downIndex = self.itemButtons.count - 1;
    }];
    
}


//按九宫格计算方式排列按钮
- (void)setMenu{
    
    int cols = 3;
    int col = 0;
    int row = 0;
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat wh = 100;
    
    CGFloat margin = ([UIScreen mainScreen].bounds.size.width - cols * wh) / (cols + 1);
    
    //此处按照不同屏幕尺寸适配
    CGFloat oriY = 500;
    if (kScreenHeight == 480) {
        //4/4s
        oriY = 313;
    }else if (kScreenHeight == 568){
        //5/5s
        oriY = 400;
    }else if (kScreenHeight == 667){
        //6/6S
        oriY = 500;
    }else{
        //6P 736
        oriY = 569;
    }
    
    for (int i = 0; i < self.ary.count; i++) {
        
//        NSArray *arrTitle = @[@"文字",@"照片",@"链接",@"视频",@"寻亲",@"文章"];
        NSArray *arrTitle = @[@"文字",@"照片",@"链接",@"视频",@"寻亲",@"文章"];
        
        
        PublishMenuButton *btn = [PublishMenuButton buttonWithType:UIButtonTypeCustom];
        
        //图标图片和文本
        UIImage *img = [UIImage imageNamed:self.ary[i]];
        NSString *title = arrTitle[i];
        
        [btn setImage:img forState:UIControlStateNormal];
        [btn setTitle:title forState:UIControlStateNormal];
        
        //列数(个数除总列数取余)
        col = i % cols;
        //行数(个数除总列数取整)
        row = i / cols;
        //x 平均间隔 + 前图标宽度
        x = margin + col * (margin + wh);
        //y 起始y + 前宽度
        y = row * (margin + wh) + oriY;
        
        
        btn.frame = CGRectMake(x, y, wh, wh);
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
        btn.tag = 1000 + i;
        
        [btn addTarget:self action:@selector(touchDownBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemButtons addObject:btn];
        
        [self.view addSubview:btn];
        
    }
    
}


//点击按钮进行放大动画效果直到消失
- (void)touchDownBtn:(PublishMenuButton *)btn{
    
    
    NSLog(@"%ld为btn.tag的值，根据不同的按钮需要做什么操作可以写这里",btn.tag);
    //根据选中的不同按钮的tag判断进入相应的界面->
    
    if (btn.tag == 1000) {
        //纯文本
        TwoViewController *publishTextVC = [[TwoViewController alloc] init];
        
        [publishTextVC toDissmissSelf:^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
            [UIView animateWithDuration:0.2 animations:^{
                _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
            }];
        }];
        [self presentViewController:publishTextVC animated:YES completion:nil];

    }else if(btn.tag == 1001){
        //图文
        OneViewController *publishVC = [[OneViewController alloc] init];
        [publishVC.navigationItem setTitle:@"发布"];
        [publishVC toDissmissSelf:^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
            [UIView animateWithDuration:0.2 animations:^{
                _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
            }];
        }];
        [self presentViewController:publishVC animated:YES completion:nil];
    }else{
        //链接 
        ThreeViewController *publishLinkVC = [[ThreeViewController alloc] init];
        [publishLinkVC.navigationItem setTitle:@"发布"];
        [publishLinkVC toDissmissSelf:^{
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
            [UIView animateWithDuration:0.2 animations:^{
                _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
            }];
        }];
        [self presentViewController:publishLinkVC animated:YES completion:nil];

    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        btn.transform = CGAffineTransformMakeScale(2.0, 2.0);
        btn.alpha = 0;
    }];
    
}


//设置按钮从后往前下落
- (void)returnUpVC{
    
    if (_downIndex == -1) {
        
        [self.timer invalidate];
        
        return;
    }
    
    PublishMenuButton *btn = self.itemButtons[_downIndex];
    
    [self setDownOneBtnAnim:btn];
    
    _downIndex--;
}

//按钮下滑并返回上一个控制器
- (void)setDownOneBtnAnim:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.6 animations:^{
        
        btn.transform = CGAffineTransformMakeTranslation(0, self.view.bounds.size.height);
        
    } completion:^(BOOL finished) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
}

//点击事件返回上一控制器,并且旋转145弧度关闭按钮
-(void)touchesBegan:(UITapGestureRecognizer *)touches{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(returnUpVC) userInfo:nil repeats:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _closeImgView.transform = CGAffineTransformRotate(_closeImgView.transform, -M_PI_2*1.5);
    }];
    
}

@end
