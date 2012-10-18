# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :livereload do
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/views/.+\.(erb|haml|html)})
  watch(%r{(public/).+\.(css|js|html)})

  watch(%r{app/assets/stylesheets/(.+\.css)$})  { |m| "assets/#{m[1]}" }
  watch(%r{app/assets/stylesheets/(.+\.less)}) { |m| "assets/style.css"}

  # Rails Assets Pipeline
  watch(%r{(app|vendor)/assets/\w+/(.+\.(js)).*})  { |m| "/assets/#{m[2]}" }
  #watch(%r{app/assets/javascripts/(.+\.js).*$})   { |m| "assets/#{m[1]}" }
  watch(%r{config/locales/.+\.yml})
end



