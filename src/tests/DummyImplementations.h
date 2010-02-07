//
//  DummyImplementations.h
//  dXml
//
//  Created by Derek Clarkson on 31/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXPathAbstractSelector.h"


@interface DummySelector : DCXPathAbstractSelector
{
	NSArray *nodes;
}

@property (retain, nonatomic) NSArray *nodes;

@end

@interface ErrorFilter : NSObject<DCXPathFilter> {
@private
}

@end

