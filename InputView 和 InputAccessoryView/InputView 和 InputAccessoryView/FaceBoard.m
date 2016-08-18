//
//  FaceBoard.m
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "FaceBoard.h"
#import "FaceButton.h"
#import "GrayPageControl.h"
#import "EmotionTextAttachment.h"
#import "NSAttributedString+Emotion.h"

#define FACE_COUNT_ALL  85

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44

@implementation FaceBoard
{
    int width;
    int location;
    NSDictionary *_faceMap;
    UIScrollView *faceView;
    GrayPageControl *facePageControl;
}


- (id)init{
    width = [UIScreen mainScreen].bounds.size.width-16;
    self = [super initWithFrame:CGRectMake(0, 0, width, 216)];
    if (self) {
         self.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];

        //获取表情数据
        NSString *resource = [languages[0] hasPrefix:@"zh"]?@"_expression_cn":@"_expression_cn";
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resource ofType:@"plist"]];
        NSLog(@"%@",[_faceMap description]);
        
        //表情视图
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(8, 0, width, 190)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_COUNT_ALL / FACE_COUNT_PAGE + 1) * width, 190);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 1; i<= FACE_COUNT_ALL; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            [faceButton addTarget:self action:@selector(faceButton:) forControlEvents:UIControlEventTouchUpInside];
            
            //计算表情按钮的坐标
            CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * width/7 +  + ((i - 1) / FACE_COUNT_PAGE * width);
            CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
            faceButton.frame = CGRectMake( x, y, width/7, FACE_ICON_SIZE);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]]
                        forState:UIControlStateNormal];
            
            [faceView addSubview:faceButton];
            
        }
        //添加PageControl
        facePageControl = [[GrayPageControl alloc]initWithFrame:CGRectMake(width/2-50, 190, 100, 20)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //转字符
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"转字符" forState:UIControlStateNormal];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(262, 182, 80, 28);
        [self addSubview:back];

    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [facePageControl setCurrentPage:faceView.contentOffset.x / width];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage * width, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(FaceButton *)sender {
    NSInteger index = sender.buttonIndex;
    NSString *indexStr = [NSString stringWithFormat:@"%03ld",(long)index];
    
    if (self.inputTextView) {
        EmotionTextAttachment *emotionTextAttachment = [[EmotionTextAttachment alloc] init];
        emotionTextAttachment.emotionStr = _faceMap[indexStr];
        emotionTextAttachment.image = [UIImage imageNamed:indexStr];
        
        //记录光标位置
        location = (int)self.inputTextView.selectedRange.location;
        //插入表情
        [self.inputTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emotionTextAttachment] atIndex:self.inputTextView.selectedRange.location];
        self.inputTextView.selectedRange = NSMakeRange(location+1, 0);
    }
    
    if (self.inputTextField) {
        EmotionTextAttachment *emotionTextAttachment = [EmotionTextAttachment new];
        emotionTextAttachment.emotionStr = _faceMap[indexStr];
        emotionTextAttachment.image = [UIImage imageNamed:indexStr];
        //存储光标位置
        location = (int)self.inputTextView.selectedRange.location;
        //插入表情
        [self.inputTextView.textStorage insertAttributedString:[NSAttributedString attributedStringWithAttachment:emotionTextAttachment] atIndex:self.inputTextView.selectedRange.location];
        //光标位置移动1个单位
        self.inputTextView.selectedRange = NSMakeRange(location+1, 0);
        
    }
}

- (void)backFace{
//    NSLog(@"%@",self.inputTextView.textStorage);
    NSString *inputString;
    if (self.inputTextView) {
        inputString = [self.inputTextView.attributedText mgo_getPlainString];
    }
    self.inputTextView.text = inputString;

}


@end
