# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

def testing_pods
    pod 'Quick'
    pod 'Nimble'
end

def logic_pods
    pod 'RealmSwift'
    pod 'ReactiveCocoa', '~> 5.0.0'
end

def ui_pods
    pod 'JTAppleCalendar', '~> 6.0'
end

target 'Askio' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    
    logic_pods
    ui_pods
    pod 'SnapKit'
    
    # Pods for Askio
end

target 'AskioCore' do
    logic_pods
end

target 'AskioCore-MacOS' do
    platform :osx, '10.11'
    logic_pods
end

target 'AskioCoreTests' do
    platform :osx, '10.11'
    testing_pods
    
end
