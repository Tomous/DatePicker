//
//  ViewController.m
//  DatePicker
//
//  Created by 大橙子 on 2018/6/20.
//  Copyright © 2018年 中都格罗唯视. All rights reserved.
//

#import "ViewController.h"
#import "DCDatePickerView.h"


#define pickViewWidth ScreenWidth - 40
#define pickViewHeight 256
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<DatePickerViewDelegate>
@property(nonatomic,strong)DCDatePickerView * pikerView;
@property (nonatomic,strong) UIView * backWindowView;
@property (nonatomic,copy) NSString * startTimeStr;
@property (nonatomic,copy) NSString * endTimeStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *dateBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 44, 44)];
    dateBtn.backgroundColor = [UIColor redColor];
    [dateBtn addTarget:self action:@selector(dateBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dateBtn];
}
#pragma 日期选择器
-(void)dateBtnDidClick
{
    __weak typeof(self) weakself = self;
    if(self.pikerView==nil){
        _backWindowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _backWindowView.backgroundColor = [UIColor blackColor];
        _backWindowView.alpha = 0.5;
        [[UIApplication sharedApplication].keyWindow addSubview:_backWindowView];
        //点击背景是否隐藏
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleBtnDidClick)];
        tap.delegate = self;
        [_backWindowView addGestureRecognizer:tap];
        
        _pikerView = [DCDatePickerView datePickerView];
        _pikerView.layer.cornerRadius = 9;
        _pikerView.clipsToBounds = YES;
        _pikerView.delegate = self;
        _pikerView.type = 0;
        _pikerView.frame= CGRectMake(20, ScreenHeight, pickViewWidth, pickViewHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:_pikerView];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            weakself.pikerView.frame = CGRectMake(20, (ScreenHeight-pickViewHeight)/2, pickViewWidth, pickViewHeight);
        } completion:^(BOOL finished) {
        }];
        
    }else{
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakself.backWindowView removeFromSuperview];
            weakself.backWindowView = nil;
            weakself.pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 257- 52);
        } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
        }];
    }
}
#pragma DatePickerViewDelegate
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    NSLog(@"%d - %@", type, date);
    
    __weak typeof(self) weakself = self;
    if (type==0) {
        _pikerView.startTimeLabel.text = [NSString stringWithFormat:@"%@", date];
        _pikerView.startTimeLabel.textColor = OrangeColor;
    }else if(type==1){
        _pikerView.endTimeLabel.text = [NSString stringWithFormat:@"%@", date];
    }
    if (![_pikerView.startTimeLabel.text isEqualToString:@""]&&![_pikerView.startTimeLabel.text isEqualToString:@"开始时间"]&&![_pikerView.endTimeLabel.text isEqualToString:@""]&&![_pikerView.endTimeLabel.text isEqualToString:@"结束时间"]) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [weakself.backWindowView removeFromSuperview];
            weakself.backWindowView = nil;
            weakself.pikerView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, pickViewHeight);
        } completion:^(BOOL finished) {
            [self.pikerView removeFromSuperview];
            self.pikerView = nil;
        }];
#warning
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *startDate = [formatter dateFromString:_pikerView.startTimeLabel.text];
        NSDate *endDate = [formatter dateFromString:_pikerView.endTimeLabel.text];
        if ([startDate timeIntervalSinceNow] >= [endDate timeIntervalSinceNow]) {
//            [SVProgressHUD showInfoWithStatus:@"结束时间不能小于开始时间"];
//            [SVProgressHUD dismissWithDelay:1];
            NSLog(@"结束时间不能小于开始时间");
            return;
        }

    }
    NSLog(@"startTimeLabel:%@----endTimeLabel:%@",_pikerView.startTimeLabel.text,_pikerView.endTimeLabel.text);
}
-(void)cancleBtnDidClick
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [weakself.backWindowView removeFromSuperview];
        weakself.backWindowView = nil;
        weakself.pikerView.frame = CGRectMake(20, ScreenHeight, pickViewWidth, pickViewHeight);
    } completion:^(BOOL finished) {
        [self.pikerView removeFromSuperview];
        self.pikerView = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
