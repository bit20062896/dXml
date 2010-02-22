//
//  WebServiceResponse.h
//  dXml
//
//  Created by Derek Clarkson on 26/11/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlNode.h"
#import "XmlDocument.h"

/**
 * Returned from a sucessful call to a soap web service. 
 * It contains all the data from the service.
 * \see SoapWebServiceConnection
 */
@interface WebServiceResponse : NSObject {
	@private
	XmlDocument *document;
}

/**
 * The raw xml document as returned by the service.
 */
@property (nonatomic, readonly) XmlDocument *document;

/**
 * Constructor used by the connection to create this instance.
 */
- (WebServiceResponse *) initWithDocument: (XmlDocument *) aDocument;

/**
 * Gives direct access to the Body node. ie. \\Envelope\\Body.
 */
- (XmlNode *) bodyElement;

/**
 * Gives direct access to the first node within the Body node. Useful when you know there will be only one node within
 * the Body node.
 */
- (XmlNode *) bodyContent;

/**
 * Returns a NSEnumerator of the nodes within the Body node. This is useful when for example you get this reply:
 * \code
 * ...
 * &lt;Body&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 *    &lt;Data&gt; ... &lt;/Data&gt;
 * &lt;/Body&gt;
 * \endcode
 * This NSEnumator will loop through all the "Data" elements in turn.
 */
- (NSEnumerator *) bodyContents;

@end