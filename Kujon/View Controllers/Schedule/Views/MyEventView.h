//
// Created by Wojciech Maciejewski on 11/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CalendarLib/MGCEventView.h>
#import <CalendarLib/MGCStandardEventView.h>


@interface MyEventView : MGCEventView


/*! Title of the event - displayed in bold */
@property (nonatomic, copy)	NSString *title;

/*! Subtitle - diplayed below the title or next to it if the view is not large enough. */
@property (nonatomic, copy)	NSString *subtitle;

/*! Detail - displayed with a smaller font and right aligned. */
@property (nonatomic, copy)	NSString *detail;

/*! The color is used for background or text, depending on the style. */
@property (nonatomic) UIColor *fontColor;
@property (nonatomic) UIColor *myBackgrounColor;

/*! Style of the view. */
@property (nonatomic) MGCStandardEventViewStyle style;

/*! Font used to draw the event content. Defaults to system font. */
@property (nonatomic) UIFont *font;
@end