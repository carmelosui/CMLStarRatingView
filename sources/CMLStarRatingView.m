#import "CMLStarRatingView.h"

#import "CMLStarRatingStencilView.h"
#import "CMLStarRatingAreaJudger.h"

@interface CMLStarRatingView ()

@property (nonatomic, strong) NSArray *judgers;
@property (nonatomic, strong) CMLStarRatingViewRatingChangeCallback valueChangeCallback;
@property (nonatomic, assign) BOOL reportValueChangeOnTouchEndOnly;
@property (nonatomic, assign) CMLStarRatingValue *ratingValueWhenTouchBegan;
@property (nonatomic, assign) Class hitJudgerClass;

@end

@implementation CMLStarRatingView

-(instancetype)initWithStencilViews:(NSArray *)stencilViews stencilSize:(CGSize)stencilSize minStencilSpacing:(CGFloat)minStencilSpacing minLeftRightMargin:(CGFloat)minLeftRightMargin layoutStrategy:(CMLStarRatingViewLayoutStrategy)strategy hitJudgerClass:(__unsafe_unretained Class)hitJudgerClass
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stencilViews = stencilViews;
    _stencilViewSize = stencilSize;
    _minStencilSpacing = minStencilSpacing;
    _minLeftRightMargin = minLeftRightMargin;
    _layoutStrategy = strategy;
    _hitJudgerClass = hitJudgerClass ? hitJudgerClass : [CMLStarRatingAreaJudger class];
    
    [_stencilViews enumerateObjectsUsingBlock:^(CMLStarRatingStencilView *stencilView, NSUInteger idx, BOOL *stop) {
        [self addSubview:stencilView];
        [stencilView setRating:CMLStarRatingStencilViewRatingNone];
    }];
    
    return self;
}

-(void)setValueChangeCallback:(CMLStarRatingViewRatingChangeCallback)block reportOnTouchEndOnly:(BOOL)reportOnTouchEndOnly
{
    self.valueChangeCallback = block;
    self.reportValueChangeOnTouchEndOnly = reportOnTouchEndOnly;
}

-(CMLStarRatingValue *)ratingValue
{
    __block NSInteger wholeStars = 0;
    __block BOOL halfStar = NO;
    [self.stencilViews enumerateObjectsUsingBlock:^(CMLStarRatingStencilView *view, NSUInteger idx, BOOL *stop) {
        switch (view.rating) {
            case CMLStarRatingStencilViewRatingNoInitialized:
                [NSException raise:@"ThisIsImpossible" format:nil];
                break;
            case CMLStarRatingStencilViewRatingNone:
                *stop = YES;
                break;
            case CMLStarRatingStencilViewRatingHalf:
                *stop = YES;
                halfStar = YES;
                break;
            case CMLStarRatingStencilViewRatingWhole:
                wholeStars++;
                break;
                
            default:
                break;
        }
    }];
    
    return [[CMLStarRatingValue alloc] initWithWholeStarCount:wholeStars hasHalfStar:halfStar];
}

-(void)setRatingValue:(CMLStarRatingValue *)ratingValue
{
    for (NSInteger i = 0; i < ratingValue.wholeStarCount; i++) {
        CMLStarRatingStencilView *view = self.stencilViews[i];
        [view setRating:CMLStarRatingStencilViewRatingWhole];
    }
    
    if (ratingValue.hasHalfStar) {
        CMLStarRatingStencilView *view = self.stencilViews[ratingValue.wholeStarCount];
        [view setRating:CMLStarRatingStencilViewRatingHalf];
    }
}

-(void)updateJudgers
{
    NSMutableArray *judgers = [[NSMutableArray alloc] init];
    [self.stencilViews enumerateObjectsUsingBlock:^(CMLStarRatingStencilView *view, NSUInteger idx, BOOL *stop) {
        CMLStarRatingAreaJudger *judger = [[_hitJudgerClass alloc] initWithArea:view.frame stencilView:view ratingView:self];
        [judgers addObject:judger];
    }];
    self.judgers = judgers;
}

-(void)layoutSubviews
{
    const NSInteger stencilCount = self.stencilViews.count;
    
    CGFloat stencilsAndSpacingsWidth = 0;
    const CGFloat minStencilsAndSpacingsWidth = stencilCount * self.stencilViewSize.width + (stencilCount - 1) * self.minStencilSpacing;
    
    if (self.layoutStrategy == CMLStarRatingViewLayoutStrategyTryMaxSpacing) {
        CGFloat maxStencilAndSpacingWidth = CGRectGetWidth(self.bounds) - 2 * self.minLeftRightMargin;
        stencilsAndSpacingsWidth = MAX(minStencilsAndSpacingsWidth, maxStencilAndSpacingWidth);
    }
    else if (self.layoutStrategy == CMLStarRatingViewLayoutStrategyTryMinSpacing) {
        stencilsAndSpacingsWidth = minStencilsAndSpacingsWidth;
    }
    else {
        [NSException raise:@"ThisIsImpossible" format:nil];
    }
    
    const CGFloat spacingWidth = floor((stencilsAndSpacingsWidth - self.stencilViewSize.width * stencilCount) / (stencilCount - 1));
    const CGFloat marginWidth = floor((CGRectGetWidth(self.bounds) - stencilsAndSpacingsWidth)/2);
    
    CGFloat x = marginWidth;
    CGFloat y = floor((CGRectGetHeight(self.bounds) - self.stencilViewSize.height) / 2);
    for (NSInteger i = 0; i < stencilCount; i++) {
        CGRect stencilFrame = CGRectMake(x, y, self.stencilViewSize.width, self.stencilViewSize.height);
        UIView *stencilView = self.stencilViews[i];
        stencilView.frame = stencilFrame;
        x += self.stencilViewSize.width + spacingWidth;
    }
    
    [self updateJudgers];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.ratingValueWhenTouchBegan = self.ratingValue;
    UITouch *touch = touches.anyObject;
    [self updateRatingByTouch:touch];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    [self updateRatingByTouch:touch];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    [self updateRatingByTouch:touch];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if only report on touch end, and while user is moving the touch, there comes a phone call
    //the touch is canceled, the value change is not reported, so we need to revert the value
    //if report continously, then when the touch is canceled, the value changed by touch move has
    //already been reported, so it is safe to do nothing
    if (self.reportValueChangeOnTouchEndOnly) {
        [self setRatingValue:self.ratingValueWhenTouchBegan];
        self.ratingValueWhenTouchBegan = nil;
    }
}

-(void)updateRatingByTouch:(UITouch*)touch
{
    __block CMLStarRatingAreaJudger *judgerHit = nil;
    
    [self.judgers enumerateObjectsUsingBlock:^(CMLStarRatingAreaJudger *judger, NSUInteger idx, BOOL *stop) {
        if ([judger isInMyArea:touch]) {
            judgerHit = judger;
            *stop = YES;
        }
    }];
    
    if (!judgerHit) {
        return;
    }
    
    CMLStarRatingValue * const originalValue = self.ratingValue;
    
    NSInteger judgerHitIndex = [self.judgers indexOfObject:judgerHit];
    CMLStarRatingStencilView *view = [judgerHit relatedStencilView];
    if (self.halfRatingAllowed && [judgerHit isInMyLeftArea:touch]) {
        [view setRating:CMLStarRatingStencilViewRatingHalf];
    }
    else {
        [view setRating:CMLStarRatingStencilViewRatingWhole];
    }
    
    NSArray *leftJudgers = [self.judgers subarrayWithRange:NSMakeRange(0, judgerHitIndex)];
    NSArray *rightJudgers = [self.judgers subarrayWithRange:NSMakeRange(judgerHitIndex + 1, self.judgers.count - judgerHitIndex - 1)];
    [self setRated:YES ForJudgers:leftJudgers];
    [self setRated:NO ForJudgers:rightJudgers];
    
    CMLStarRatingValue *newValue = self.ratingValue;
    [self reportValueChangeByTouch:touch newValue:newValue oldValue:originalValue];
}

-(void)reportValueChangeByTouch:(UITouch*)touch newValue:(CMLStarRatingValue*)newValue oldValue:(CMLStarRatingValue*)oldValue
{
    if ([newValue isEqualToRating:oldValue]) {
        return;
    }
    if (!self.valueChangeCallback) {
        return;
    }
    if (self.reportValueChangeOnTouchEndOnly && touch.phase != UITouchPhaseEnded) {
        return;
    }
    __weak CMLStarRatingView *weakSelf = self;
    self.valueChangeCallback(weakSelf);
}

-(void)setRated:(BOOL)rated ForJudgers:(NSArray*)judgers
{
    [judgers enumerateObjectsUsingBlock:^(CMLStarRatingAreaJudger *judger, NSUInteger idx, BOOL *stop) {
        CMLStarRatingStencilView *view = [judger relatedStencilView];
        [view setRating:rated ? CMLStarRatingStencilViewRatingWhole : CMLStarRatingStencilViewRatingNone];
    }];
}

@end
