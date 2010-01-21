//
//  TestHeaders.h
//  dXml
//
//  Created by Derek Clarkson on 21/01/10.
//  Copyright 2010 Derek Clarkson. All rights reserved.
//

#define WEB_SERVICE_XML			 @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
   @"<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"" \
   @" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">" \
   @"<soap:body>" \
   @"<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">" \
   @"<symbol>MOT</symbol>" \
   @"</m:GetLastTradePrice>" \
   @"</soap:body>" \
   @"</soap:envelope>"

#define PRETTY_WEB_SERVICE_XML @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" \
   @"\n<soap:envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" soap:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">" \
   @"\n\t<soap:body>" \
   @"\n\t\t<m:GetLastTradePrice xmlns:m=\"http://trading-site.com.au\">" \
   @"\n\t\t\t<symbol>MOT</symbol>" \
   @"\n\t\t</m:GetLastTradePrice>" \
   @"\n\t</soap:body>" \
   @"\n</soap:envelope>"



