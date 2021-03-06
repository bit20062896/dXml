# dXml v0.1.4 (August 2010)

* Converted build to use scripts from dUseful stuff.
* Converted to create a framework rather than seperate libraries.

# dXml v0.1.3 (14 may 2010)

* Modified DCXPathExecutor:executePath:errorVar: so that it returns NSNull rather than nil if there are no results from the query. This is more in line with standard practice. Nil response is now an indicator that the errorVar contains an error.
* Modified the packaging of the libraries so that build properties can be used to include the correct library, and once set, the developer no longer needs to adjust paths on the fly. Hopefully this will be the last time I have to frag with the artifact layouts :-[

# dXml v0.1.2 (15 Apr 2010)

* Rebuid project files to build separate device and simulator libraries. Then to build separate debug and release versions.

# dXml v0.1.1 (18 Feb 2010)

* Added a basic xpath interpreter to the DCXmlNode.
* Broke XPath and AsString methods out of DCXmlNode and into seperate categories to aid development and testing.
* Fixed DCXmlNode:nodeAtIndex: to return a DCDMNode type rather than a DCXmlNode.
* Updated readme to use a live online soap server for testing. Thanks to dukeatcoding for pointing out the server and suggesting some sample code.
* Added an error trap to pick up on blank responses from servers with no errors. A NSError is now raised by DCUrlConnection.
* Improved error reporting when in debug mode. Previously was throwing exceptions.
* Changed returns from DCXmlNode on all methods which returned NSEnumerator to now return the NSArray or NSDictionary as appropriate. Was trying to do the java thing of not exposing internals, but it ended up making things a little too difficult. 

# dXml v0.1.0 (20 Jan 2010)

* Added more defines to SoapWebServiceConnection.h to help with extracting data from responses.
* Added a new category to NSError to manage soap fault details.
* Added isSoapFault message to WebServiceResponse.
* Added simple BSD license.
* Inline with suggested coding practices on [Cocoa Dev Central](http://cocoadevcentral.com/articles/000082.php) I've renamed all classes and values to have a prefix of "DC". This helps to ensure that when used with other libraries we avoid conflicting names. This is the reason for the minor version increment as all previous code will break.

# dXml v0.0.2 (18 Jan 2010)

* Added changelog to release build and dmg file.
* Renamed NSObject (SoapTemplates) createBasicSoapDOM to createBasicSoapDM to avoid confuson with the w3c DOM.
* Started grouping messages in the api documentation.
* Moved integration tests to their own executable. This is not part of the normal build so that developers do not need a full server setup to build dXml.
* Removed soap faults and exceptions from api. Changed to set NSError references as recommended by Apple's programming guides.
* Changed XmlNode:isEqualsToName: to isEqualToName:.

# dXml v0.0.1 (Jan 2010)

Initial release code to GitHub.