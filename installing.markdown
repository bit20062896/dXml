---
layout: default
title:  Installing
---

# Installing into XCode

Initially installing dXml was quite simple. Then I discovered that I needed 4 versions of the libraries. Initially I brought them in and just switched them in and out manually. The problem I found was that this cluttered up the library search path in the target build settings and wasn't veery reliable.

The solution I eventually worked out was to store the 4 different versions of dXml in a directory structure which could be easily navigated using build settings. This means that depending on your selection of Release/Debug and device/simulator, XCode will select the correct library to link into the final application. 

Here's what the directory structure looks like from the download:

![Directories](images/lib%20directories.png)

So lets get it installed and running.

## Step 1: Copying the files to your hard drive

You will need to have the dXml files in a directory somewhere so you can access them in XCode. In this example, I created a directory called "dXml" in a tools directory and dragged the files from the downloaded dmg file. It should look something like this:

![Installed files](images/Installed%20files.png)

## Step 2: Adding the Framework

In Xcode, create a new group in the frameworks group and call it **dXml**. You can actually call it anything you like, but dXml works well.

![Directories](images/Adding%20new%20framework%20group.png)

## Step 3: Installing the files

Open finder and go to the dXml vn.n.n device which is the attached dmg file. Here you need to select all the header files and one of the directories containing the compile libraries. **Debug** or **Release**, it doesn't matter which. You can bring both in, but as you will see, there is no need. We only need one lib to be referenced by a target and it doesn't matter which one it is.

![Files to be added to XCode](images/Selected%20files.png)

Once you have selected the files, drag them to the dXml group you created in XCode. When XCode prompts, tell it **NOT** to copy the files into your project. When done, it should look something like this:

![dXml ready to go](images/Files%20in%20xcode.png)

_Note: I did a little extra here to tidy up. You can leave the sub groups it creates and the two libraries it will be referencing. But it's neater to drag one of the library files out of the created sub groups to sit with the headers and then deleted the subgroups and extra library file (Telling it not to trash them of course!). As I said, it doesn't matter which library you have in xcode._

## Step 4: Setting up the Target library search path

Xcode will have automatically added the libdXml.a library to the currently selected target. Now what we need to do is to tell that target how to find the correct library to compile into your application, depending on your build settings.

Now there are a variety of setups that you can do here with settings in the project vs settings in individual targets. I prefer to do as many settings at the project level as possible and only add settings to the targets which are specific to them. 

First open the current target settings and go to the **Build** tab, then locate the **Library search path** setting.

![Target library search path](images/Target%20lsp.png)

The double click to open the dialog for editing the path. You will see that the paths **${SRCROOT}/../tools/dXml/Debug/iphoneos** and **${SRCROOT}/../dXml/Debug/iphonesimulator** have been added to the search path. If you dragged the Release directory in as well you would see two addition paths as well.

![Created search paths](images/Paths.png)

Because I like to use the project settings instead of target settings where possible, I just delete all the dXml hard coded paths that have been added and close the dialog.

## Step 5: Setting up the Project library search path

Now open the project settings, select the **Build** tab and again, find the **Library Search Paths** and double click to open the editing dialog. It will probably be blank, so click the **\[+\]** button to add a line and enter this:

**${SRCROOT}/../tools/dXml/${CONFIGURATION}/${PLATFORM_NAME}**

![Project search paths](images/Project%20paths.png)

The way XCode works (AFAIK) is that when you add a library to a target, it knows it needs to add it to the final application. It uses the selected library as a reference for classes and such during compilation, but when actually assembling the finished product, it searches for the library to include in the **Library Search Paths** setting. This is why I said it doesn't matter which version of the library you add to the target. It's not the one compiled into the finished product.

By using the two build settings: **${CONFIGURATION}** and **${PLATFORM_NAME}** we are telling XCode to search a path built from their current values, rather than hard coded paths. CONFIGURATION has one of two values (Debug or Release) and PLATFORM_NAME matches the current target platform (Device or simulator). So by using both we are telling the linker to search down through the dXml directories to the matching library.

Clever ay? :-)


