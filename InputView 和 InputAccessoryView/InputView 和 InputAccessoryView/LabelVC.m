//
//  LabelVC.m
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "LabelVC.h"
#import "EmotionTextAttachment.h"
#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface LabelVC ()

@property (nonatomic,strong)UILabel *label;

@end

@implementation LabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    

    
    
}

- (void)setLabelStr:(NSString *)labelStr{
    if (_labelStr != labelStr) {
        _labelStr = labelStr;
    }
    
    NSMutableString *string = [NSMutableString stringWithString:_labelStr];
    
    //正则表达筛选出标签位置
    NSString *pattern = @"/s\\d{3}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //用来拼接新的图文字符
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] init];
    
    NSInteger selectIndex = 0;
    for (NSTextCheckingResult* result in matches){
        //纯文字部分
        NSString *leftStr = [string substringWithRange:NSMakeRange(selectIndex, result.range.location - selectIndex)];
        //表情部分
        NSMutableString *resultStr = [NSMutableString stringWithString:[string substringWithRange:result.range]];
        EmotionTextAttachment *emotionTextAttachment = [EmotionTextAttachment new];
        emotionTextAttachment.image = [UIImage imageNamed:[resultStr stringByReplacingOccurrencesOfString:@"/s" withString:@""]];
        selectIndex = result.range.location + result.range.length;
        
        
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:leftStr]];
        [attrStr appendAttributedString:[NSAttributedString attributedStringWithAttachment:emotionTextAttachment]];
    }
    
    self.label.attributedText = attrStr;
    
}

- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, Kwidth, 200)];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor greenColor];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
