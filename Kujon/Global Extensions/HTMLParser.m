//
//  HTMLParser.m
//  Kujon
//
//  Created by Adam on 11.10.2016.
//  Copyright © 2016 Mobi. All rights reserved.
//

#import "HTMLParser.h"

@implementation HTMLParser

+ (NSAttributedString *)parseHTMLString:(NSString *)string usingRegularFont:(UIFont *)regularFont andBoldFont:(UIFont *)boldFont {

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSFontAttributeName value:regularFont range:range];

    NSDictionary *boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary *underlineAttributes = @{ NSUnderlineStyleAttributeName : @1};
    NSDictionary *strikeThroughAttributes = @{ NSStrikethroughStyleAttributeName : @1};

    NSDictionary *replacements = @{
                                   @"<b>(.*?)</b>" : boldAttributes,
                                   @"<u>(.*?)</u>" : underlineAttributes,
                                   @"<s>(.*?)</s>" : strikeThroughAttributes
                                   };

    for (NSString *key in replacements) {

        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:key options:0 error:nil];

        [regex enumerateMatchesInString:string options:0 range:range usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
            NSRange matchRange = [match rangeAtIndex:1];
            [attributedString addAttributes:replacements[key] range:matchRange];
        }];
    }
    [[attributedString mutableString] replaceOccurrencesOfString:@"<b>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"</b>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"<i>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"</i>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"<u>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"</u>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"<s>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"</s>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"&quot;" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    [[attributedString mutableString] replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, attributedString.length)];
    
    return [attributedString copy];
}


@end
