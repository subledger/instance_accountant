# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :minitest do
  watch /^spec\/(.*)_spec[.]rb$/

  watch /^lib\/(.+)[.]rb$/ do |m|
    "spec/#{m[1]}_spec.rb"
  end

  watch /^spec\/spec_helper[.]rb$/ do
    'spec'
  end
end

guard :rubocop do
  watch /.+[.]rb$/
  watch /(?:.+\/)?[.]rubocop[.]yml$/ do |m|
    File.dirname m[0]
  end
end
