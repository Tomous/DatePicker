//
//  DCDatePickerView.h
//  DatePicker
//
//  Created by 大橙子 on 2018/6/20.
//  Copyright © 2018年 中都格罗唯视. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef enum{
    
    // 开始日期
    DateTypeOfStart = 0,
    
    // 结束日期
    DateTypeOfEnd = 1,
    
}DateType;

@protocol DatePickerViewDelegate <NSObject>

- (void)getSelectDate:(NSString *)date type:(DateType)type;
-(void)cancleBtnDidClick;
@end
@interface DCDatePickerView : UIView
@property(nonatomic,strong)UIDatePicker * datePickerView;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)UIButton * cannelBtn;

@property (nonatomic,strong)UIButton *startBtn;
@property (nonatomic,strong) UILabel *startTimeLabel;
@property (nonatomic,strong) UIButton *endBtn;
@property (nonatomic,strong) UILabel *endTimeLabel;

@property(nonatomic,assign)BOOL isDatePiker;

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

@property (nonatomic, assign) DateType type;

+(id)datePickerView;

@end
