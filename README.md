# Askio

##What is that?
This app is directed to women who want to track their stomach ache / menstruation.
Simple view of a calendar + ability to schedule everyday notification.
Each day is able to store info about occurance of pain/menstruation + scale 1 - 3 for each.
This data is also presented on the calendar view as little dots (1-3) blue for pain and red for menstruation.

##What is used?
Swift 3  
Pods 1.1.1  

Pods:  
ReactiveCocoa 5.0 - FRP Framework   
SnapKit - A little change from my usual PureLayout  
JTAppleCalendar - Used for a calendar view.  
Realm - I use it as data storage.  


##Testing
Currently test count is close to none, however I plan to add them in near future. This is my playground to play with tests a little bit, as I've splitted application into two separate modules  
AskioCore - Contains ViewModels, Models, Repositories  
Askio - AppDelegate, ViewControllers, Other classes that require UIKit  

The idea for that was to test all the code that does not require UIKit to run as MacOS framework. This result in situation where we do not need Simulator to run most of our tests.  
I've share this idea in one of my blog posts: https://eliaszsawicki.com/are-your-views-dumb-enough/

##How do I run it?
You need XCode with verison >= 8.0  
Open Askio.xcworkspace  
Hit run with Askio as selected target  
