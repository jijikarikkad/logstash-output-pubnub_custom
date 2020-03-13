# encoding: utf-8
require "logstash/outputs/base"
require 'pubnub'

# An logstash-output-pubnub output that does nothing.
class LogStash::Outputs::PubnubCustom < LogStash::Outputs::Base
  config_name "pubnub_custom"

    # config_param :pubnub_channel, :string
  config :pubnub_publish_key, :validate => :string, :required => true
  config :pubnub_subscribe_key, :validate => :string, :required => true
  config :channel_keys, :validate => :string, :required => true 
  # config :max_entries, :validate => :integer, :default => -1
  # config :ip_key, :string, :default => 'ip'

  public
  def register
    @pubnub = Pubnub.new( publish_key: @pubnub_publish_key, subscribe_key: @pubnub_subscribe_key, logger: Logger.new(STDOUT) )
  end # def register

  public
  def receive(event)
    document = {}.merge(event.to_hash)
    keys = @channel_keys.to_s.split(",")
    message = JSON.parse(document['message'])
    channel = message[keys[0]]+ ":"+ message[keys[1]]+ ":"+  message[keys[2]]
    puts channel
    @pubnub.publish(http_sync: true, message: document , channel: channel.to_s)
  end # def event
end # class LogStash::Outputs::LogstashOutputPubnub
