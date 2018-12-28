#!/opt/rbenv/shims/ruby

# -*- coding: utf-8 -*-
# record AGQR
# usage: use with crontab
# 29,59 * * * sleep 55; ruby agqr.rb
# requirements
# crontab, ruby >~ 1.9, ffmpeg, rtmpdump

#ARGV[0]にはLINEのアクセストークンをいれる

require 'yaml'
require 'shellwords'

rtmpdump = '/usr/bin/rtmpdump'
ffmpeg = '/usr/bin/ffmpeg'
agqr_stream_url = 'rtmp://fms-base1.mitene.ad.jp/agqr/aandg22'

#current = File.dirname(File.expand_path(__FILE__))
current = "/mnt/agqr"

save_dir = "#{current}/data/"
Dir.mkdir(save_dir) if !File.exist?(save_dir)
%w(mp3 flv).each do |dir|
  path = save_dir + dir
  Dir.mkdir(path) if !File.exist?(path)
end

schedule_yaml = "#{current}/schedule.yaml"
if !File.exist?(schedule_yaml)
  puts "Config file (#{schedule_yaml}) is not found!"
  puts "Please make #{schedule_yaml}."
  exit 1
end

today = Time.now

# ruby 1.9.x でも動くために汚いけど書き換える
# WDAY = %w(日 月 火 水 木 金 土).zip((0..6).to_a).to_h
tmp = { }
%w(日 月 火 水 木 金 土).each_with_index do |v, i|
  tmp[v] = i
end
WDAY = tmp

schedule = YAML.load_file(schedule_yaml)
schedule.each do |program|

  program_wday = WDAY[program['wday']]

  is_next_day_program = false

  # appropriate wday
  h, m = program['time'].split(':').map(&:to_i)
  hstr, mstr = program['time'].split(':')
  if h.zero? && m.zero?
    # check next day's wday
    # if today.wday is 6 (Sat), next_wday is 0 (Sun)
    next_wday = (today.wday + 1).modulo(7)
    is_appropriate_wday = program_wday == next_wday
    is_next_day_program = true
  else
    # check today's wday
    is_appropriate_wday = program_wday == today.wday
  end

  # appropriate time
  if is_next_day_program
    # 日付を跨ぐので録音開始の日付が1日ずれる
    next_day = today + 60 * 60 * 24
    # today.day + 1 してたら 31 を超えるとTimeがエラー吐く
    program_start = Time.new(next_day.year, next_day.month, next_day.day, h, m, 0)
  else
    program_start = Time.new(today.year, today.month, today.day, h, m, 0)
  end

  is_appropriate_time = (program_start - today).abs < 120

  length = program['length'] * 60 + 10

  if is_appropriate_wday && is_appropriate_time
    title = (program['title'].to_s + ' (' + today.strftime('%F ') + hstr + ':' + mstr + ':00 ' + today.strftime('%z %Z') + ')') #.gsub(' ','')
    flv_path = Shellwords.escape("#{save_dir}flv/#{title}.flv")
    
    # record stream
    rec_command = "#{rtmpdump} -r #{agqr_stream_url} --live -B #{length} -o #{flv_path} >/dev/null 2>&1"
    system rec_command

    # encode flv -> m4a
    m4a_path = Shellwords.escape("#{save_dir}mp3/#{title}.m4a")
    m4a_encode_command = "#{ffmpeg} -y -i #{flv_path} -vn -acodec copy #{m4a_path} >/dev/null 2>&1"
    system m4a_encode_command

    # encode m4a -> mp3
    mp3_path = Shellwords.escape("#{save_dir}mp3/#{title}.mp3")
    mp3_encode_command = "#{ffmpeg} -i #{m4a_path} #{mp3_path} >/dev/null 2>&1"
    system mp3_encode_command

    # delete m4a
    system "rm -rf #{m4a_path}"

    # LINE Notify
    if ARGV.length > 0 then
      system "curl -X POST -H 'Authorization: Bearer #{ARGV[0]}' -F 'message=「#{program['title'].to_s} 」の録音を終了しました。' https://notify-api.line.me/api/notify"
    end
  end
end
