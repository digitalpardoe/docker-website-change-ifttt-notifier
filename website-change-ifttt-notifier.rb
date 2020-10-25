#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'diffy'
require 'net/http'
require 'uri'

lock_file = File.open("/tmp/website-change-ifttt-notifier.lock", File::CREAT)
lock_state = lock_file.flock(File::LOCK_EX|File::LOCK_NB)

if !lock_state
  puts "Already running, exiting..."
  exit
end

website_to_check = ENV["WEBSITE_TO_CHECK"]
change_threshold = ENV["CHANGE_THRESHOLD"] || 5
ifttt_webhook_key = ENV["IFTTT_WEBHOOK_KEY"]
ifttt_webhook_event = ENV["IFTTT_WEBHOOK_EVENT"]

output_directory = "/output"
master_file = "#{output_directory}/master.html"
ifttt_webhook = "https://maker.ifttt.com/trigger/#{ifttt_webhook_event}/with/key/#{ifttt_webhook_key}"

def get_source(url)
  page_body = Nokogiri::HTML.parse(URI.open(url)).at("body")
  page_body.text.gsub(/\n\s*{2,}/, "\n")
end

begin
  if !File.file?(master_file)
    File.open(master_file, "w") do |f|
      f.write get_source(website_to_check)
    end
  end

  master_contents = File.open(master_file).read
  current_contents = get_source(website_to_check)

  diff = Diffy::Diff.new(master_contents, current_contents)

  if diff.to_s.empty?
    percentage_change = 0
  else
    line_count = diff.to_s.lines.count
    diff_size = diff.to_s.scan(/^[-\+]/).size

    percentage_change = (diff_size.to_f / line_count.to_f) * 100.00
  end

  puts "Change detected is #{percentage_change}%."

  if percentage_change > change_threshold.to_i
    puts "Threshold met, notifying an updating..."

    uri = URI.parse(ifttt_webhook)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    response = http.request(Net::HTTP::Post.new(uri.request_uri))

    if response.kind_of? Net::HTTPSuccess
      timestamp = Time.now.strftime("%Y%m%d-%H%M")
      File.rename(master_file, master_file.gsub(".html", "-#{timestamp}.html"))
      File.open(master_file, "w") do |f|
        f.write current_contents
      end

      puts "Complete."
    else
      puts "Notification failed!"
    end
  else
    puts "No action to take."
  end
ensure
  lock_file.close
end
