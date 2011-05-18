# RLAgreement View Controller

This project allows developers to include and Agreement, Terms of Service, Non Disclosure Agreement, etc. to an iPhone App.  The controller stores a variable in the user's settings when the user has a valid agreement and it checks every time the user opens the App.

The Agreement text is stored in one or more HTML files that can be formated as needed. It is also possible to include a PDF version of the Agreement and the user can choose to e-mail himself a copy of the PDF file.

# Installation

Compile the code in Xcode to checkout the demo.  You might have to change some of the code/text depending on your specific needs.

* Add MessageUI.framework to your project
* Copy the files `RLAgreementAppDelegate.h` and `RLAgreementAppDelegate` to your code
* Copy the image files for the "previous" and "next" page buttons (prev.png, prev@2x.png, next.png, next@2x.png)
* Modify the method `applicationDidBecomeActive:` in your App Delegate. Check out RLAgreement for an example

# To Do

I plan to use this code to include an NDA to my BETA testers while doing Ad-Hoc Distribution.  I tried to cover all my needs, but if you have an idea let me know and I'll try to add the feature.

Follow [@RiveraLabs](http://twitter.com/riveralabs) on Twitter to send me your ideas.

