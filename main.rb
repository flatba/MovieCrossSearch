#
# main Crawler
#
require './crawler/entry_crawler.rb'
require "rubygems"
require "slack-notifier"

Slack::Notifier.new(ENV['WEBHOOK_URL']).ping("クローラーを実行する")
entry = EntryCrawler.new
entry.run
