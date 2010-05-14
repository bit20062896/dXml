---
layout: default
title: XPath queries
---

# XPath queries
	  
XPath queries are the latest addition to dXml. First off this is not a complete implementation of XPath. I've taken some of the core xpath functionality as defined at [WC3School](http://www.w3schools.com/XPath/xpath_syntax.asp) and implemented it so that you can use it to drill down through a document when you need access to a specific node and don't want to use the API get there. Of course, under the covers the XPath implementation is using the API so all thats really happening is that a parser converts your XPath into a set of API calls to do the work. This means that XPaths can be developer friendly, but in performance and memory constrained situations, may not be as efficient.

Ok, lets have a look. Heres the list of supported XPath tokens you can use in a XPath requests to dXml:

<table class="table examples">
	<tr class="header">
		<td class="headerCell">XPath Token</td>
		<td class="headerCell">Description</td>
	</tr>
	<tr class="row">
		<td class="cell">&lt;element-name&gt;</td>
		<td class="cell">
			Locates all sub elements of the current element with the name element-name.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">//&lt;element-name&gt;</td>
		<td class="cell">
From the current element, locates all occurrences of element-name, no matter where they occur below it. i.e. if a sub element has a sub element with the name, it will be returned. This is a good way to get to a low level xml element providing it's name is unique.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">/</td>
		<td class="cell">
Has two meanings depending on where it occurs in the XPath, if it's the first character, this instructs the processor to start from the root element  of the document, regardless of which document node is passed to the XPath processor. Otherwise it serves to seperate element names in the XPath expression. 
		</td>
	</tr>
	<tr class="row">
		<td class="cell">[nn]</td>
		<td class="cell">
Where <em>nn</em> is an integer. Can occur in a number of places. If preceeded by an element name, it returns the <em>n</em>th occurance of the element with that name. If not, it returns the <em>n</em>th occurance of any element. Note also that XPath, unlike C, is <strong>1</strong> based not 0 based when indexing elements. So <code>abc[1]</code> refers to the first "abc" element, not the second.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">..</td>
		<td class="cell">
Refers to the parent element of the current element. This is a shortcut that lets you effectively traverse back up the document model tree structure.
		</td>
	</tr>
</table>

## Processing

Processing a XPath expression is fairly straight forward. The parser breaks up the expression into a series of tokens, and them builds a processing chain of commands to execute it. Each command in the chain takes in a current list of nodes, executes on each one in turn and then returns a new list of nodes for subsequent commands to work with. Once all commands have executed, the final list of nodes is returned.

## Example XPaths

Here are some example XPaths using this example xml document.

{% highlight xml linenos %}
<abc>
    <def>
        <ghi>lmn</ghi>
        <ghi>rst</ghi>
    </def>
    <def>
        <ghi>xyz</ghi>
    </def>
    <opq />
</abc>
{% endhighlight %}

<table class="table examples">
	<tr class="header">
		<td class="headerCell">XPath</td>
		<td class="headerCell">Result</td>
	</tr>
	<tr class="row">
		<td class="cell">/abc</td>
		<td class="cell">
Locates the root element "abc". Note that generally you would only have a single root element, so using the element name really doesn't do much more than confirm it. Also note that it doesn't matter from what DCXmlNode you execute this from, it will still go to the root element.
		</td>
	</tr>
	<tr class="row">
		<td class="cell"></td>
		<td class="cell">

		</td>
	</tr>
	<tr class="row">
		<td class="cell">/abc/def</td>
		<td class="cell">
Locates and returns both "def" elements.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">/abc/def[1]/ghi</td>
		<td class="cell">
Returns the two "ghi" elements inside the first "def" element.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">ghi</td>
		<td class="cell">
If executed from the second "def" element will return the "ghi" element containing the "xyz" text.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">../def[2]</td>
		<td class="cell">
If executed from the first "def" element, will go to it's parent (abc) and then the second "def" element.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">//ghi[1]</td>
		<td class="cell">
If executed from the root "abc" element, will locate all occurrences of "ghi" elements and return the first one. Here it gets a little tricky. In this case all "ghi" elements are found, and then only the first one is returned.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">//ghi/[1]</td>
		<td class="cell">
If executed from the root "abc" element, will locate all occurrences of "ghi" elements and returns the first sub element from each one.
		</td>
	</tr>
	<tr class="row">
		<td class="cell">/abc/def[1]/ghi[2]</td>
		<td class="cell">
Locates the "ghi" element containing the "rst" text.
		</td>
	</tr>
</table>


# Executing XPaths

XPaths can be executed on any **DCXmlNode** which basically means also the root **DCXmlDocument** node as they are an extension of the DCXmlNode class. Here's some example code:

{% highlight objc linenos %}
// Code to create a document ...

DCXPathExecutor *executor = [[DCXPathExecutor alloc] initWithDocument:document];
NSError *error = nil;
id results = [executor executeXPath:@"/xyz" errorVar:&error];
 
if (id == nil && error != nil) {
    // Handle the error.
}
{% endhighlight %}

This block of code is fairly standard. 

Anyway, We set the return value as an id because it can be any one of 4 possible values:

* An pointer to `[NSNull null]` meaning there where no matching nodes. This is valid because the xml may be quite valid but not have the data you think should be there.

* A **DCTextNode** if there was only a single text node in the final result.

* A **DCXmlNode** if there was only a single xml node in the final result.

* A **NSArray** containing any number of DCTextNode and DCXmlNode instances.

* A `nil` which indicates there is an error waiting in the error variable.

Which one you get depends on the xml and your XPath. 

