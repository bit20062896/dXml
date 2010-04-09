---
layout: default
title: Messaging web services
---
	  
# Messaging web services

Sending messages to web services is simpler because we can use **DCSoapWebServiceConnection** instead of DCUrlConnection. DCSoapWebServiceConnection is actually an extension of DCUrlConnection and therefore gets all of it's functionality. It then adds to it with automatic SOAP envelope handling, SOAP fault handling, SOAP security (ws-security) etc.

**Note: The SOAP security (was-security) is still in it's infancy in this class at this point. It only handles basic auto with userids and passwords. I'm planning to add encryption soon. **

Here's an example of using this class:

{% highlight objc linenos %}

// Common definitions.
#define BANKING_SECURE @"https://localhost:8181/services/Banking"
#define BALANCE_ACTION @"\"http://localhost:8080/banking/balance\""
#define MODEL_SCHEMA @"http://localhost/banking/model"

// Soap payload as an NSString, notice it not the full message.
NSString *xml = @"<dhc:balance xmlns:dhc=\"" MODEL_SCHEMA "\">" 
   @" forAccountNumber>1234</forAccountNumber>"
   @"</dhc:balance>";

//Get a connection object and call the service.
DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection 
   createWithUrl: BANKING soapAction: BALANCE_ACTION];
NSError *error = nil;
DCWebServiceResponse *response = [service postXmlStringPayload: xml errorVar:&error];

// Check for errors.
if (response == nil) {
   if (error.isSoapFault) {
      NSLog(@"Fault code    = &@", error.soapFaultCode);
      NSLog(@"Fault message = &@", error.soapFaultMessage);
      return;
   } else {
      // Non SOAP fault, so do something about the error.
      return;
   }
}

NSLog(@"Balance = &@", [[response bodyContent] xmlNodeWithName: @"balance"].value);
{% endhighlight %}

This is much simpler than the example in [Messaging Urls](messageUrls.html). This is because all the extra work is taken care of for you. 

Firstly DCSoapWebServiceConnection knows you want to send and retrieve SOAP messages so it handles the work of creating the SOAP envelopes. All you need to do is provide the body content of the messages. Hence the initial xml is smaller. Again like DCUrlConnection it has a method called `postXmlNodePayload: errorVar:` which takes a DCXmlNode as a parameter for people who want to use the API instead of xml strings.

Next it also can take the SOAP action as a constructor. 

Thirdly, it knows it will be getting a SOAP response back from the server so it wraps it up in a **DCWebServiceResponse** object. This class provides methods for accessing the contents of the response. 

And finally DCSoapWebServiceConnection also recognises when a SOAP fault is returned instead of the normal response. When this happens it converts the SOAP fault into an instance of NSError and returns that. You can also import the **NSError+SoapFault.h** category header to further add methods to NSError for accessing the fault codes and messages.

# Security

DCSoapWebServiceConnection provides some basic was-security at the moment. In the above example no security is used. Here's the same example with security enabled:

{% highlight objc linenos %}
#import "DCSecurity.h"
// ...

//Get a connection object and call the service.
DCSoapWebServiceConnection *service = [DCSoapWebServiceConnection 
   createWithUrl: BANKING soapAction: BALANCE_ACTION];
[service setUsername:@"username" password:@"password"];
service.securityType = BASIC_USERID_PASSWORD;

// ...
{% endhighlight %}

Once these two lines are added, DCSoapWebServiceConnection automatically knows it has to apply was-security to the message. So before sending it modifies the final SOAP message to add the necessary elements.

**Note: in the future more options will be added. Just have not had time :)**




