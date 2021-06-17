# Arcadia-High-Mobile-iOS

The official source code for Arcadia High Mobile (avaliable on the Apple app store). Includes source code for the iOS version of the app. 
The purpose of AHS App Dev Team is to drive a culture where students can collaborate to produce application(s) that would revolutionize the way that the community stays connected.

Languages used for iOS include - Swift/Obj C

Contact us at: hsappdev@students.ausd.net

---
Old repository description:

I would like to thank everyone who has worked on this app. I would also like to keep a record of team memebers here as well.

Founders: Seongwook Jang (Project Manager), Jason Zhao (Lead Programmer), Tiger Ma (Server Programmer), Albert Yeung (Graphic Desinger), Jessica Chou (Graphic Desinger), Nathan Wong (Graphic Desinger), Paul Lee (Content Editor), Alex Hitti (Content Editor).

2nd Gen: Elle Yokota, Miranda Chen, Jocelyn Thai, Roselind Zeng

3rd Gen: Alex Dang, Arina Miyadi, Richard Wei, Danielle Wong, Emily Yu, Kimberly Yu, Steffi Huang

4th Gen: Rachel Saw, Jennifer Wong, Kelly Cheng, Kyrene Tam, Arina Miyadi, Steffi Huang, Jeffrey Aaron Jeyasingh, Xing Liu, Joshua McMahon, Richard Wei

If there are parts you do not understand, please reach out to us. Thank you!

---
For reference, the old repo can be found [here](https://github.com/AHSAppDevTeam/Arcadia-High-Mobile).

---

# XCode setup 

After cloning, you must reinstall CocoaPods due to location issues across different systems.

Run these commands in order:
1. `cd .../AHS/AHS/`
2. `pod deintegrate`
3. `pod install`
4. `cd ../`
5. `git update-index --assume-unchanged AHS.xcodeproj/project.pbxproj`

This should regenerate the project file to suit your specific system.

Now, you might be asking, why not add the file to `.gitignore` if it's different across systems? Well, you need the project file in the first place in order to install CocoaPods at all. Just make sure to not recommit **your** new project file to the repo as that would require everyone else to reinstall CocoaPods.
