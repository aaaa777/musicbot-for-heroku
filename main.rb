
require 'discordrb'
require 'open3'
#require 'pg'
require 'net/https'
require 'open-uri'

A7ID = 238575590456688641
bot = Discordrb::Commands::CommandBot.new token: ENV['TOKEN'], prefix: '!', help_command: :hep

bot.ready do |e|
  #youtube_url = "https://www.youtube.com/watch?v=Jo1tjBmwuXI"
  #puts "YouTube URL: #{youtube_url}"
  #`mkdir youtube`
  #Dir.chdir "youtube"
  #`curl https://yt-dl.org/downloads/latest/youtube-dl > youtube-dl`
  #`chmod 755 youtube-dl`
  #`./youtube-dl "#{youtube_url}" -o video.mp4`
  #`git clone https://code.google.com/p/plowshare/ plowshare4; cd plowshare4; make install PREFIX=/app/youtube`
  #puts `./bin/plowup zippyshare video.mp4`
end

bot.command(:con) do |e|
  vcch = e.user.voice_channel
  bot.voice_connect(vcch)
  "connected to #{vcch.name}"
end

bot.command(:dc) do |e|
  bot.voices[e.server.id].destroy
  'bye'
end

bot.command(:play) do |e, *args|
  voice_bot = bot.voices[e.server.id]
  return 'not in voice ch. type `!con` first.' unless voice_bot

  url = args.first
  
  command = "youtube-dl #{url} -o - | ffmpeg -loglevel 0 -i - -f s16le -ar 48000 -ac 2 pipe:1"

  IO.popen(command) do |encode_io|
    voice_bot.play(encode_io)
  end

  'video end'
end

bot.command(:eval) do |e, *args|
  return unless e.author.id == A7ID
  eval(args.join(' '))
end

bot.run
