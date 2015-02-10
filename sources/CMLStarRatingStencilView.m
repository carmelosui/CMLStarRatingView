#import "CMLStarRatingStencilView.h"

@interface CMLStarRatingStencilView ()

@property (nonatomic, strong) UIImageView *stencilImageView;

@property (nonatomic, strong) UIImage *noneRatingImage;
@property (nonatomic, strong) UIImage *halfRatingImage;
@property (nonatomic, strong) UIImage *wholeRatingImage;

@property (nonatomic, strong) UIColor *selectedStarTintColor;
@property (nonatomic, strong) UIColor *unselectedStarTintColor;

@end

@implementation CMLStarRatingStencilView

-(instancetype)initWithNoneRatingImage:(UIImage *)noneRatingImage halfRatingImage:(UIImage *)halfRatingImage wholeRatingImage:(UIImage *)wholeRatingImage
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _noneRatingImage = noneRatingImage;
    _halfRatingImage = halfRatingImage;
    _wholeRatingImage = wholeRatingImage;
    
    self.stencilImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.stencilImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.stencilImageView];
    
    return self;
}

-(void)setRating:(CMLStarRatingStencilViewRating)rating
{
    if (_rating == rating) {
        return;
    }
    _rating = rating;
    
    UIImage *toUseImage = nil;
    switch (_rating) {
        case CMLStarRatingStencilViewRatingNone:
            toUseImage = self.noneRatingImage;
            self.stencilImageView.tintColor = self.unselectedStarTintColor;
            break;
        case CMLStarRatingStencilViewRatingHalf:
            toUseImage = self.halfRatingImage;
            break;
        case CMLStarRatingStencilViewRatingWhole:
            toUseImage = self.wholeRatingImage;
            self.stencilImageView.tintColor = self.selectedStarTintColor;
            break;
            
        default:
            break;
    }
    
    self.stencilImageView.image = toUseImage;
}

-(void)setSelectedStarTintColor:(UIColor*)color
{
    _selectedStarTintColor = color;
}

-(void)setUnSelectedStarTintColor:(UIColor*)color
{
    _unselectedStarTintColor = color;
}

@end
