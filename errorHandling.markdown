---
layout: default
---

# Error handling
	  
Error handling in Cocoa and iPhone sdk is not that straight forward. You can throw exceptions (as most Java programmers would immediately think to do. I know I did!) but on further reading there is a considerable performance hit in doing so, especially for errors you are expected. In Java we have two types of exceptions, checked and runtime. Checked are defined on method signatures and the compiler will not compiled code that doesn't explicitly deal with them. Runtime are exceptions that are unexpected. Out of memory for example.

In the [Introduction to Exception Programming Topics for Cocoa](http://developer.apple.com/mac/library/documentation/cocoa/Conceptual/Exceptions/Exceptions.html) Apple recommends using NSError objects wherever errors are expected rather than exceptions. i.e. Java checked exceptions. 

Therefore in dXml I have taken the following approach to errors:

* If the error to be generated is the result of a program fault, i.e. a bug, then throw a NSException.
* If the error is caused by bad input such as corrupt xml of a typo by a user, then generate and return a NSError. A good example would be a SOAP fault coming back from a server.

This is why methods which deal with input and output generally have a **NSError \*** reference as part of the method signature. This is an indicator to you that you need to look for and handle likely errors. Lets look at an example. Here is the code to send a soap message to a server:

{% highlight objc linenos %}

// other imports.
#import "NSError+SoapFault.h"

	// class code ...
 
	NSError *error = nil;
	DCWebServiceResponse *response = [service postXmlNodePayload: xml errorVar:&error];

	// Check for errors.
	if (response == nil) {
		if (error.isSoapFault) {
			NSLog(@"Fault code    = &@", error.soapFaultCode);
			NSLog(@"Fault message = &@", error.soapFaultMessage);
			return;
		}
	}

{% endhighlight %}

This sample code is aligned with what Apple recommends. First we create a NSError reference pointing to the `nil` object. This is recommended and the error traps may not work correctly if it is not pointing to nil. 

Next we make the call to the web service, passing the NSError \*'s memory address. Huh? Ok, It took me some time to get my head around this, so here goes. 

Basically we are passing a pointer to the memory address, where the pointer to an NSError object is stored. Currently this pointer is set to `nil`. The idea is that if an error occurs, the `postXmlNodePayload:` method can create an instance of NSError and then change the NSError \* from pointing at `nil` to point to the newly created NSError. In a sense this is like reaching outside the method and setting a value in the method that called you. Once the thread is back in the original method, it can make use of the error variable to access the created NSError.

This is why we pass error as **&error** in the method call. It basically says _"Don't pass what error is pointing to, pass a reference to the variable itself._

Once the service has executed we then check the returned response. This is also according to the Apple recommendations which say it is preferable not to check the error variable itself. I'm not sure why at this point, but that's what they say. Once we have an error you can see that we are using some of the new **NSError+SoapFault** category methods to check for a soap fault and access the contents. 

Thats it. Simple really.

