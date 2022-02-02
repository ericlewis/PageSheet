Pod::Spec.new do |s|
  s.name         = "PageSheet"
  s.version      = "1.2.3"
  s.summary      = "Customizable sheets using UISheetPresentationController in SwiftUI."
  s.description  = <<-DESC
    Customizable sheet presentations in SwiftUI. Using UISheetPresentationController under the hood.
  DESC
  s.homepage     = "https://github.com/ericlewis/PageSheet"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author             = { "Eric Lewis" => "ericlewis777@gmail.com" }
  s.social_media_url   = "https://twitter.com/ericlewis"
  s.ios.deployment_target = "15.0"
  s.source       = { :git => "https://github.com/ericlewis/pagesheet.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
end
