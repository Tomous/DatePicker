//
//  DCDatePickerView.m
//  DatePicker
//
//  Created by 大橙子 on 2018/6/20.
//  Copyright © 2018年 中都格罗唯视. All rights reserved.
//

#import "DCDatePickerView.h"

#define kScreen_Width  [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kMargin 20


@interface DCDatePickerView ()
@property (nonatomic, strong) NSString *selectDate;

@end

@implementation DCDatePickerView
+(id)datePickerView
{
    return [[self alloc] initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xBDBDBD)
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width - kMargin *2, 70)];
        headerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headerView];
        
        UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 29, (headerView.width-30)/2, 40)];
        startTimeLabel.text = @"开始时间";
        startTimeLabel.textColor = OrangeColor;
        startTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.startTimeLabel = startTimeLabel;
        [headerView addSubview:startTimeLabel];
        
        UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, startTimeLabel.y, startTimeLabel.width, startTimeLabel.height)];
        startBtn.backgroundColor = [UIColor clearColor];
        self.startBtn = startBtn;
        [startBtn addTarget:self action:@selector(startBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:startBtn];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(startBtn.frame), startBtn.y, 30, startBtn.height)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"至";
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        
        UILabel *endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), startBtn.y, startBtn.width, startBtn.height)];
        endTimeLabel.text = @"结束时间";
        endTimeLabel.textColor = [UIColor lightGrayColor];
        endTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.endTimeLabel = endTimeLabel;
        [headerView addSubview:endTimeLabel];
        
        UIButton *endBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), startBtn.y, startBtn.width, startBtn.height)];
        endBtn.backgroundColor = [UIColor clearColor];
        self.endBtn = endBtn;
        [endBtn addTarget:self action:@selector(endBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:endBtn];
        
        UIView * lineView1 = [[UIView alloc]init];
        lineView1.frame = CGRectMake(3, headerView.height - 0.5, startBtn.width - 3, 0.5);
        lineView1.backgroundColor = OrangeColor;
        [headerView addSubview:lineView1];
        
        UIView * lineView = [[UIView alloc]init];
        lineView.frame = CGRectMake(endBtn.x, lineView1.y, startBtn.width, 0.5);
        lineView.backgroundColor = UIColorFromRGB(0xBDBDBD);
        [headerView addSubview:lineView];
        
        
        _datePickerView = [[UIDatePicker alloc]init];
        [_datePickerView setDatePickerMode:UIDatePickerModeDate];
        _datePickerView.locale = [[NSLocale alloc]
                                  initWithLocaleIdentifier:@"zh_Hans_CN"];
        _datePickerView.frame = CGRectMake(0, CGRectGetMaxY(headerView.frame), kScreen_Width - kMargin *2, 195 - 60);
        
        NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate*currentDate = [NSDate date];
        NSDateComponents *com = [[NSDateComponents alloc]init];
        [com setYear:0];//设置最大时间为：当前时间推后0年
        NSDate*maxDate =[calendar dateByAddingComponents:com toDate:currentDate options:0];
        [com setYear:-10];//设置最小时间为：当前时间前推十年
        NSDate*minDate=[calendar dateByAddingComponents:com toDate:currentDate options:0];
        [_datePickerView setMaximumDate:maxDate];
        [_datePickerView setMinimumDate:minDate];
        [self addSubview:_datePickerView];
        
        UIView * toolView = [[UIView alloc]init];
        toolView.frame = CGRectMake(0, CGRectGetMaxY(_datePickerView.frame), kScreen_Width - kMargin *2, 50);
        toolView.backgroundColor = UIColorFromRGB(0xBDBDBD);
        [self addSubview:toolView];
        
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, 0.5, (toolView.width-0.5)/2, toolView.height - 0.5);
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _sureBtn.backgroundColor = [UIColor whiteColor];
        [toolView addSubview:_sureBtn];
        
        _cannelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cannelBtn.frame = CGRectMake(toolView.width - _sureBtn.width, _sureBtn.y, _sureBtn.width, _sureBtn.height);
        [_cannelBtn addTarget:self action:@selector(cannelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_cannelBtn setTitleColor:UIColorFromRGB(0x90959E) forState:UIControlStateNormal];
        [_cannelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cannelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cannelBtn.backgroundColor = [UIColor whiteColor];
        [toolView addSubview:_cannelBtn];
    }
    return self;
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentOlderOneDateStr = [dateFormatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

-(void)startBtnDidClick
{
    self.startTimeLabel.text = @"";
    if ([self.endTimeLabel.text isEqualToString:@""]) {
        self.endTimeLabel.text = @"结束时间";
    }
    self.type = 0;
}
-(void)endBtnDidClick
{
    self.endTimeLabel.text = @"";
    if ([self.startTimeLabel.text isEqualToString:@""]) {
        self.startTimeLabel.text = @"开始时间";
    }
    self.type = 1;
}
-(void)cannelBtnClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(cancleBtnDidClick)]) {
        [_delegate cancleBtnDidClick];
    }
}

-(void)sureBtnClick
{
    self.selectDate = [self timeFormat];
    //delegate
    if (_delegate && [_delegate respondsToSelector:@selector(getSelectDate:type:)]) {
        [_delegate getSelectDate:self.selectDate type:self.type];
    }
}

@end
