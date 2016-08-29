Pod::Spec.new do |s|

s.name         = "LGPPhotoBrowser"
s.version      = "0.0.3"
s.summary      = "The most easy way for autoLayout.    一个图片浏览，可以旋转放大，左右滑动"

s.homepage     = "https://github.com/LiaoGuopeng/LGPPhotoBrowser"

s.license      = "MIT"

s.author             = { "guopeng liao" => "756581014@qq.com" }

s.platform     = :ios
s.platform     = :ios, "7.0"

s.source       = { :git => "https://github.com/LiaoGuopeng/LGPPhotoBrowser", :tag => "0.0.3"}

s.source_files  = "三图复用/LGPPhotoBrowser/**/*.{h,m}"

# s.public_header_files = "Classes/**/*.h"


s.requires_arc = true

s.dependency "Masonry", "~> 1.0.1"
s.dependency "SDWebImage", "~> 3.8.1"

# s.frameworks = "Masonry", "SDWebImage"

end