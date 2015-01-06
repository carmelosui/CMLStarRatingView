CMLStarRatingView
=================

<p align="center" >
  <img src="https://raw.githubusercontent.com/carmelosui/CMLStarRatingView/master/example.png">
</p>

A rating view, the rating image, the rating level counts are configurable, you can even use different image for every rating level.

Some concepts:
- `stencil` mean the "star" you see in a rating view, the `stencil` of this project is defined as a `UIView` subclass
- `AreaJudger` is the object used to test if user is touching in certain stencil, you can subclass this class and configure to use your subclass when initializing `CMLStarRatingView`, to provider better touch experience.

Usage:  
Copy all the files to your project.  

to add it on your view:

```objc
  NSMutableArray *stencils = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {
        CMLStarRatingStencilView *view = [[CMLStarRatingStencilView alloc] initWithNoneRatingImage:[UIImage imageNamed:@"star_none"] halfRatingImage:[UIImage imageNamed:@"star_half"] wholeRatingImage:[UIImage imageNamed:@"star_whole"]];
        [stencils addObject:view];
    }
    
  CMLStarRatingView *starRatingView = [[CMLStarRatingView alloc] initWithStencilViews:array stencilSize:CGSizeMake(50, 50) minStencilSpacing:10 minLeftRightMargin:20 layoutStrategy:CMLStarRatingViewLayoutStrategyTryMinSpacing hitJudgerClass:nil];
  starRatingView.frame = CGRectMake(0, 200, 500, 100);
  [self.view addSubview:starRatingView];
```

to get/set rating value:
```objc
  CMLStarRatingValue *rating = [starRatingView ratingValue];
  [starRatingView setRatingValue:[[CMLStarRatingValue alloc] initWithWholeStarCount:3 hasHalfStar:YES]];
```

to register value change callback:
```objc
  [starRatingView setValueChangeCallback:^(CMLStarRatingView *) {
        //value changed
    } reportOnTouchEndOnly:YES];
```

You can subclass `CMLStarRatingAreaJudger` to gain better touch response by changing the hit test area of the stencils.
