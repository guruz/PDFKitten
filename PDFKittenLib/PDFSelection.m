#import "PDFSelection.h"
#import "PDFRenderingState.h"

CGFloat horizontal(CGAffineTransform transform) {
	return transform.tx / transform.a;
}

@implementation PDFSelection

+ (PDFSelection *)selectionWithState:(PDFRenderingState *)state {
	PDFSelection *selection = [[PDFSelection alloc] init];
	selection.initialState = state;
	return [selection autorelease];
}

- (CGAffineTransform)transform {
	return CGAffineTransformConcat([self.initialState textMatrix], [self.initialState ctm]);
}

- (CGRect)frame {
	return CGRectMake(0, self.descent, self.width, self.height);
}

- (CGFloat)height {
	return self.ascent - self.descent;
}

- (CGFloat)width {
	return horizontal(self.finalState.textMatrix) - horizontal(self.initialState.textMatrix);
}

- (CGFloat)ascent {
	return MAX([self ascentInUserSpace:self.initialState], [self ascentInUserSpace:self.finalState]);
}

- (CGFloat)descent {
	return MIN([self descentInUserSpace:self.initialState], [self descentInUserSpace:self.finalState]);
}

- (CGFloat)ascentInUserSpace:(PDFRenderingState *)state {
	return state.font.fontDescriptor.ascent * state.fontSize / 1000;
}

- (CGFloat)descentInUserSpace:(PDFRenderingState *)state {
	return state.font.fontDescriptor.descent * state.fontSize / 1000;
}

- (void)dealloc {
    
    if (_initialState)
        [_initialState release], _initialState = nil;
    
    if (_finalState)
        [_finalState release], _finalState = nil;
	
	[super dealloc];
}

@synthesize frame, transform;
@end
