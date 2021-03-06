//
//  NSObject+SoapTemplates.h
//  dXml
//
//  Created by Derek Clarkson on 4/12/09.
//  Copyright 2009 Derek Clarkson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCXmlDocument.h"

/**
  * Adds the ability to generate a Soap message template to any class. This is useful for classes wishing to generate
  * soap web service messages.
  */
@interface NSObject (SoapTemplates)

/** \name Templates */

/**
  * Returns a DCXmlDocument which contains the basic soap message elements. Essentially this creates the Evelope, Header
  * and Body elements. Here is a copy of the
  * output from this method
  * \code
  * &lt;?xml version="1.0" encoding="UTF-8"?&gt;
  * &lt;soapenv:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  *	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  *	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"&gt;
  *	&lt;soapenv:Header /&gt;
  *	&lt;soapenv:Body /&gt;
  * &lt;/soapenv:Envelope&gt;
  * \endcode
  */
-(DCXmlDocument *) createBasicSoapDM;

/**
 * Returns a DCXmlDocument which contains a standard soap fault structure. Here is a copy of the
 * output from this method
 * \code
 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;
 * &lt;soapenv:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 *	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 *	xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"&gt;
 *	&lt;soapenv:Header /&gt;
 *	&lt;soapenv:Body /&gt;
 * &lt;/soapenv:Envelope&gt;
 * \endcode
 */
-(DCXmlDocument *) createSoapFaultDM;
@end
