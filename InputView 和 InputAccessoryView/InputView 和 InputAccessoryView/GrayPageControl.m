//
//  GrayPageControl.m
//
//  InputView 和 InputAccessoryView
//
//  Created by qugo on 16/8/17.
//  Copyright © 2016年 steven. All rights reserved.
//


#import "GrayPageControl.h"


@implementation GrayPageControl


- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if ( self ) {

        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];

        [self setCurrentPage:1];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {

        activeImage = [UIImage imageNamed:@"inactive_page_image"];
        inactiveImage = [UIImage imageNamed:@"active_page_image"];

        [self setCurrentPage:1];
	}
	return self;
}


- (void)updateDots {

    for (int i = 0; i < [self.subviews count]; i++) {

        UIImageView* dot = [self.subviews objectAtIndex:i];

        if (i == self.currentPage) {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = activeImage;
            }
            else {
                
                dot.backgroundColor = [UIColor colorWithPatternImage:activeImage];
            }
        }
        else {
            
            if ( [dot isKindOfClass:UIImageView.class] ) {
                
                ((UIImageView *) dot).image = inactiveImage;
            }
            else {
                
                dot.backgroundColor = [UIColor colorWithPatternImage:inactiveImage];
            }
        }
    }
}

-(void) setCurrentPage:(NSInteger)page {

    [super setCurrentPage:page];

    [self updateDots];
}


@end
