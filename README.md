# Arcadia-High-Mobile-iOS

The official source code for Arcadia High Mobile (avaliable on the Apple app store). Includes source code for the iOS version of the app. 
The purpose of AHS App Dev Team is to drive a culture where students can collaborate to produce application(s) that would revolutionize the way that the community stays connected.

Languages used for iOS include - Swift/Obj-C

Contact us at: hsappdev@students.ausd.net

# Old repository description

I would like to thank everyone who has worked on this app. I would also like to keep a record of team memebers here as well.

Founders: Seongwook Jang (Project Manager), Jason Zhao (Lead Programmer), Tiger Ma (Server Programmer), Albert Yeung (Graphic Desinger), Jessica Chou (Graphic Desinger), Nathan Wong (Graphic Desinger), Paul Lee (Content Editor), Alex Hitti (Content Editor).

2nd Gen: Elle Yokota, Miranda Chen, Jocelyn Thai, Roselind Zeng

3rd Gen: Alex Dang, Arina Miyadi, Richard Wei, Danielle Wong, Emily Yu, Kimberly Yu, Steffi Huang

4th Gen: Rachel Saw, Jennifer Wong, Kelly Cheng, Kyrene Tam, Arina Miyadi, Steffi Huang, Jeffrey Aaron Jeyasingh, Xing Liu, Joshua McMahon, Richard Wei

If there are parts you do not understand, please reach out to us. Thank you!

For reference, the old repo can be found [here](https://github.com/AHSAppDevTeam/Arcadia-High-Mobile).

# XCode setup 

 - After cloning, you must generate your own xcode project that will be specific to your computer.

 - Before continuing, you must first make sure you have [Brew](https://brew.sh/) and [Cocoapods](https://cocoapods.org/) installed.

 - Afterwards, make sure you install [xcodegen](https://github.com/yonaskolb/XcodeGen/) by running this command in the terminal: `brew install xcodegen`.

 - Next, run these commands in order:
1. `cd .../Arcadia-High-Mobile-iOS/AHS/`
2. `xcodegen` (this should generate a `.xcodeproj` file. **DO NOT OPEN IT**)
3. `pod install` (this should generate a `.xcworkspace`)

 - Now, open the generated `.xcworkspace` file.

 - Make sure to select the `AHS` target on the top bar like this:

![AHS Target image](https://imgur.com/qMvgXym.png)

 - Now, click on the AHS project (as opposed to the Pods project)
 
 - Under the "Signing & Capabilities" tab, make sure to sign into our shared Apple developer account via our Apple ID.

 - Now, make a selection for a team. Select "Arcadia Unified School District"
 
 You should now be all set up and ready to compile the app!

