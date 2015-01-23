#import "CMLStarRatingValue.h"

@implementation CMLStarRatingValue

-(instancetype)initWithWholeStarCount:(NSInteger)wholeStarCount hasHalfStar:(BOOL)hasHalfStar
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _wholeStarCount = wholeStarCount;
    _hasHalfStar = hasHalfStar;
    
    return self;
}

-(BOOL)isEqualToRating:(CMLStarRatingValue*)value
{
    if (self.wholeStarCount == value.wholeStarCount && self.hasHalfStar == value.hasHalfStar) {
        return YES;
    }
    return NO;
}

-(NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@: full star %ld, half star %d", [super debugDescription], (long)self.wholeStarCount, self.hasHalfStar];
}

@end
