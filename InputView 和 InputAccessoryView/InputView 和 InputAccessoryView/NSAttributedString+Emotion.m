//
//  NSAttributedString+Emotion.m
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//

#import "NSAttributedString+Emotion.h"
#import "EmotionTextAttachment.h"

@implementation NSAttributedString (Emotion)

-(NSString *) mgo_getPlainString
{
    NSMutableString *sourceString = [NSMutableString stringWithString:self.string];
    __block NSUInteger index = 0;
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value && [value isKindOfClass:[EmotionTextAttachment class]]) {
            [sourceString replaceCharactersInRange:NSMakeRange(range.location + index, range.length) withString:((EmotionTextAttachment *)value).emotionStr];
            index += ((EmotionTextAttachment *)value).emotionStr.length - 1;
        }
        
    }];
    return sourceString;
}

@end
