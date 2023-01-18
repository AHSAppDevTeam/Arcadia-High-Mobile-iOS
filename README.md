# Arcadia-High-Mobile-iOS

The official source code for Arcadia High Mobile (avaliable on the Apple app store). Includes source code for the iOS version of the app. 
The purpose of AHS App Dev Team is to drive a culture where students can collaborate to produce application(s) that would revolutionize the way that the community stays connected.

Languages used for iOS include - Swift/Obj-C

Contact us at: dev@ahs.app

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

 - Now, go to our [Firebase console](https://console.firebase.google.com/) and download the `GoogleService-Info.plist` file from the iOS project. 
 
 **NOTE: you may want to change the `DATABASE_URL` to `https://ahs-app.firebaseio.com/` if it isn't already as shown below:**
 
 ![database url in google service plist](https://imgur.com/DoQBQei.png)

 - Download [this NFC salt file](https://github.com/AHSAppDevTeam/NFC-Reader/blob/master/salts/keys.xcconfig) too (if you can't access the repo, ask someone to add you to the Github org).

 - Place the `GoogleService-Info.plist` file and the `keys.xcconfig` file inside `.../Arcadia-High-Mobile-iOS/AHS/AHS/`.
 
 - Next, run these commands in order:
1. `cd .../Arcadia-High-Mobile-iOS/AHS/`
2. `xcodegen` (this should generate a `.xcodeproj` file. **DO NOT OPEN IT**)
3. `pod install` (this should generate a `.xcworkspace`)

 - Now, open the generated `.xcworkspace` file.

 - Make sure to select the `AHS` target on the top bar like this:

![AHS Target image](https://imgur.com/qMvgXym.png)

 - Now, click on the AHS project (as opposed to the Pods project)
 
 - Under the "Signing & Capabilities" tab, make sure to sign into our shared Apple developer account via our Apple ID.

 - Now, make a selection for a team. Select "Arcadia Unified School District" like this:
 
 ![AHS Signing team image](https://imgur.com/wcpA9U9.png)
 
 You should now be all set up and ready to compile the app!
 
 Tip: if you pull a commit that has either added or deleted a file and that file change is not shown in xcode, all you have to do is rerun `xcodegen` and `pod install` again. However, make sure you are in this directory: `.../Arcadia-High-Mobile-iOS/AHS/`.
 
 # Updating to new version
 
 When uploading a new version, make sure to change the bundle version info in `Info.plist` to the next version number. When doing this, make sure to change **both `Bundle version string (short)` AND `Bundle version` to the new version string**. See this screenshot:
 
 ![info.plist bundle version settings](https://imgur.com/CB8wTb7.png)
 
 For all other steps, please follow online guides on how to publish iOS apps from XCode (because I'm too lazy to type it all out here).
 
 Note: on App Store Connect, when the app finishes uploading, choose the encryption exempt option. Our app does not use encryption.

