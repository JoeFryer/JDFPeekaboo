#
# Be sure to run `pod lib lint JDFPeekaboo.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JDFPeekaboo"
  s.version          = "0.2.2"
  s.summary          = "JDFPeekaboo is a simple class that hides the navigation bar when you scroll."
  s.description      = <<-DESC
                        JDFPeekaboo is a simple class that hides the navigation bar when you scroll down, and shows it again when you scroll back up. It can actually be any UIView that it hides, and it will also hide a view at the bottom of the screen as well, if you like.
                       DESC
  s.homepage         = "https://github.com/JoeFryer/JDFPeekaboo"
  s.license          = 'MIT'
  s.author           = { "Joe Fryer" => "joe.d.fryer@gmail.com" }
  s.source           = { :git => "https://github.com/JoeFryer/JDFPeekaboo.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/joefryer88'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'

  s.frameworks = 'UIKit'
end
