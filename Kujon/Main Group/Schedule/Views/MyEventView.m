//
// Created by Wojciech Maciejewski on 11/08/16.
// Copyright (c) 2016 Mobi. All rights reserved.
//

#import "MyEventView.h"
#import <CalendarLib/MGCEventView.h>
#import <CalendarLib/MGCStandardEventView.h>
static CGFloat kSpace = 2;
@interface MyEventView ()

@property(nonatomic) UIView *leftBorderView;
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) NSMutableAttributedString *attrString;

@end

@implementation MyEventView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentMode = UIViewContentModeRedraw;

        _myBackgrounColor = [UIColor blackColor];
        _fontColor = [UIColor whiteColor];
        _style = MGCStandardEventViewStylePlain|MGCStandardEventViewStyleSubtitle;
        _font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
        _leftBorderView = [[UIView alloc]initWithFrame:CGRectNull];
        _textLabel = [[UILabel alloc] initWithFrame:frame];

        [self addSubview:_leftBorderView];
        [self addSubview:_textLabel];
    }
    return self;
}

- (void)redrawStringInRect:(CGRect)rect
{
    // attributed string can't be created with nil string
    NSMutableString *s = [NSMutableString stringWithString:@""];

    if (self.style & MGCStandardEventViewStyleDot) {
        [s appendString:@"\u2022 "]; // 25CF // 2219 // 30FB
    }

    if (self.title) {
        [s appendString:self.title];
    }

    UIFont *boldFont = [UIFont fontWithDescriptor:[[self.font fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:self.font.pointSize];
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc]initWithString:s attributes:@{NSFontAttributeName: boldFont ?: self.font }];

    if (self.subtitle && self.subtitle.length > 0 && self.style & MGCStandardEventViewStyleSubtitle) {
        NSMutableString *s  = [NSMutableString stringWithFormat:@"\n%@", self.subtitle];
        NSMutableAttributedString *subtitle = [[NSMutableAttributedString alloc]initWithString:s attributes:@{NSFontAttributeName:self.font}];
        [as appendAttributedString:subtitle];
    }

    if (self.detail && self.detail.length > 0 && self.style & MGCStandardEventViewStyleDetail) {
        UIFont *smallFont = [UIFont fontWithDescriptor:[self.font fontDescriptor] size:self.font.pointSize - 2];
        NSMutableString *s = [NSMutableString stringWithFormat:@"\t%@", self.detail];
        NSMutableAttributedString *detail = [[NSMutableAttributedString alloc]initWithString:s attributes:@{NSFontAttributeName:smallFont}];
        [as appendAttributedString:detail];
    }

    NSTextTab *t = [[NSTextTab alloc]initWithTextAlignment:NSTextAlignmentRight location:rect.size.width options:[[NSDictionary alloc] init]];
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.tabStops = @[t];
    //style.hyphenationFactor = .4;
    //style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [as addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, as.length)];
    [as addAttribute:NSForegroundColorAttributeName value:self.fontColor range:NSMakeRange(0, as.length)];

    self.attrString = as;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.leftBorderView.frame = CGRectMake(0, 0, 2, self.bounds.size.height);
    [self setNeedsDisplay];
}

- (void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
}

- (void)setMyBackgrounColor:(UIColor *)myBackgrounColor {
    _myBackgrounColor = myBackgrounColor;
}


- (void)setStyle:(MGCStandardEventViewStyle)style
{
    _style = style;
    self.leftBorderView.hidden = !(_style & MGCStandardEventViewStyleBorder);
    [self resetColors];
}

- (void)resetColors
{
    self.leftBorderView.backgroundColor = self.myBackgrounColor;
    self.backgroundColor = self.selected ? self.myBackgrounColor : [self.myBackgrounColor colorWithAlphaComponent:0.9];

    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self resetColors];
}

- (void)setVisibleHeight:(CGFloat)visibleHeight
{
    [super setVisibleHeight:visibleHeight];
    [self setNeedsDisplay];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.textLabel.frame = CGRectMake(5, 5, self.frame.size.width-10, self.frame.size.height-10);
    _textLabel.text = self.title;
    _textLabel.font = self.font;
    _textLabel.textColor = self.fontColor;
    _textLabel.numberOfLines = 0;
    self.textLabel.text = self.title;


    CGRect drawRect = CGRectInset(rect, kSpace, 0);
    if (self.style & MGCStandardEventViewStyleBorder) {
        drawRect.origin.x += kSpace;
        drawRect.size.width -= kSpace;
    }

    [self redrawStringInRect:drawRect];

    CGRect boundingRect = [self.attrString boundingRectWithSize:CGSizeMake(drawRect.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    drawRect.size.height = fminf(drawRect.size.height, self.visibleHeight);

//    if (boundingRect.size.height > drawRect.size.height) {
//        [self.attrString.mutableString replaceOccurrencesOfString:@"\n" withString:@"  " options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.attrString.length)];
//    }

//    [self.attrString drawWithRect:drawRect options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin context:nil];
}


@end