# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'check-in' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for check-in
  #  pod 'KinveyKit'
  pod 'Parse'
  pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'
  pod 'RealmSwift', '~> 2.0.2'
  # pod 'Firebase'
  # pod 'Firebase/Auth'
  # pod 'Firebase/Database'

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end

end
