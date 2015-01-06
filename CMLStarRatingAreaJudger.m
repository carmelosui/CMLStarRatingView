#import "CMLStarRatingAreaJudger.h"

@interface CMLStarRatingAreaJudger ()

@property (nonatomic, strong) CMLStarRatingStencilView *relatedStencilView;
@property (nonatomic, strong) UIView *ratingView;
@property (nonatomic, assign) CGRect area;

@end

@implementation CMLStarRatingAreaJudger

-(instancetype)initWithArea:(CGRect)area stencilView:(CMLStarRatingStencilView *)stencil ratingView:(UIView *)ratingView
{
    self = [super init];
    if (!self) {
        return self;
    }
    
    _area = area;
    _relatedStencilView = stencil;
    _ratingView = ratingView;
    
    return self;
}

-(BOOL)isInMyArea:(UITouch *)touch
{
    CGPoint touchInView = [touch locationInView:self.ratingView];
    if (CGRectContainsPoint(self.area, touchInView)) {
        return YES;
    }
    return NO;
}

-(BOOL)isInMyLeftArea:(UITouch *)touch
{
    if (![self isInMyArea:touch]) {
        return NO;
    }
    CGRect leftRect = CGRectMake(CGRectGetMinX(self.area), CGRectGetMinY(self.area), CGRectGetWidth(self.area)/2, CGRectGetHeight(self.area));
    CGPoint touchInView = [touch locationInView:self.ratingView];
    if (CGRectContainsPoint(leftRect, touchInView)) {
        return YES;
    }
    return NO;
}

-(BOOL)isInMyRightArea:(UITouch *)touch
{
    if (![self isInMyArea:touch]) {
        return NO;
    }
    CGRect rightRect = CGRectMake(CGRectGetMinX(self.area), CGRectGetMinY(self.area) + floor(CGRectGetWidth(self.area)/2), CGRectGetWidth(self.area)/2, CGRectGetHeight(self.area));
    CGPoint touchInView = [touch locationInView:self.ratingView];
    if (CGRectContainsPoint(rightRect, touchInView)) {
        return YES;
    }
    return NO;
}

@end
