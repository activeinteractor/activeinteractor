# frozen_string_literal: true

desc 'publish activeinteractor to all sources'
task :publish do
  Rake::Task['build'].invoke
  lastest_package = Dir['pkg/activeinteractor-*.gem'].last
  puts "\033[0;36m==> Publishing #{lastest_package} to rubygems.org\033[0m"
  system("gem push #{lastest_package}")
  puts "\033[0;32m==> Published #{lastest_package} to github package registry\033[0m"
  system(
    "gem push --KEY github --host https://rubygems.pkg.github.com/activeinteractor/activeinteractor #{lastest_package}"
  )
end
