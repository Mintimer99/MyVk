# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyVK' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MyVK
	pod "PBImageView"
	pod 'Alamofire'
	pod 'Kingfisher', '~> 7.0'
	pod 'RealmSwift', '~>10'
  pod 'KeychainSwift', '~> 20.0'
  pod 'FirebaseCore'
  pod 'FirebaseDatabase'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Realm'
      create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
      create_symlink_phase.always_out_of_date = "1"
    end
  end
end
