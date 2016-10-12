//
//  HTMLParser.h
//  Kujon
//
//  Created by Adam on 11.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLParser : NSObject

+ (NSAttributedString *)parseHTMLString:(NSString *)string usingRegularFont:(UIFont *)regularFont andBoldFont:(UIFont *)boldFont;

@end
