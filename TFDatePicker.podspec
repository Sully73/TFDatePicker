#
#  Be sure to run `pod spec lint TFDatePicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TFDatePicker"
  s.version      = "0.0.1"
  s.summary      = "Enhanced Textual NSDatePicker."

  s.description  = <<-DESC
  Enhanced Textual NSDatePicker, which has a popover control to selecting date and time using the standard controls.
                   DESC


  # s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = "Tom Fewster"
  s.osx.deployment_target = "10.7"
  s.source       = { :git => "https://github.com/Sully73/TFDatePicker.git", :tag => "0.0.1" }
  s.source_files  = 'TFDatePicker/TFDatePicker/**/*.{h,m}'
  s.resource_bundles  = { 'TFDatePicker' => [ 'TFDatePicker/TFDatePicker/*.{png,xib}'] }
  s.requires_arc = true
end
