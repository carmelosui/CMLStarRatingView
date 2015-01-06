#import <Foundation/Foundation.h>

@import CoreGraphics;
#import "CMLStarRatingStencilView.h"

@interface CMLStarRatingAreaJudger : NSObject

-(instancetype)initWithArea:(CGRect)area stencilView:(CMLStarRatingStencilView*)stencil ratingView:(UIView*)ratingView;

-(UIView*)ratingView;
-(CMLStarRatingStencilView*)relatedStencilView;

#pragma mark - override these methods if you want a better hit test

//Test if the touch is inside the area of this stencil
//inside should mean either in left area or in right area
-(BOOL)isInMyArea:(UITouch*)touch;

//Test if the touch is in the left part of the area of the stencil
//if in the left area, then the stencil should be considered half rated
-(BOOL)isInMyRightArea:(UITouch*)touch;

//Test if the touch is in the right part of the area of the stencil
//if in the right area, the stencil should be considerted whole rated
-(BOOL)isInMyLeftArea:(UITouch*)touch;

@end
