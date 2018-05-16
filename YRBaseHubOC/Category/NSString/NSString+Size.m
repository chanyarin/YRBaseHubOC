//
//  NSString+Size.m
//  YRProduct
//
//  Created by hwkj on 2018/2/11.
//  Copyright © 2018年 Yarin. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)heightForSize:(CGSize)size attributes:(NSDictionary *)attributes {
    // 段落设置与实际显示的 Label 属性一致 采用 NSMutableParagraphStyle 设置Nib 中 Label 的相关属性传入到 NSAttributeString 中计算；
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    //@{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:style}
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CGSize stringSize =  [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    NSLog(@" size =  %@", NSStringFromCGSize(stringSize));
    
    // 并不是高度计算不对，我估计是计算出来的数据是 小数，在应用到布局的时候稍微差一点点就不能保证按照计算时那样排列，所以为了确保布局按照我们计算的数据来，就在原来计算的基础上 取ceil值，再加1；
    CGFloat sizeHeight = ceil(stringSize.height) + 1;
    
    return sizeHeight;
}

@end
