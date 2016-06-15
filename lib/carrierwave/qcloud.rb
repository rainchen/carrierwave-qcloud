require "carrierwave/qcloud/version"
require "carrierwave/qcloud/configuration"
require 'carrierwave/storage/qcloud'

module Carrierwave
  module Qcloud
    def self.register_carrierwave_storage_engine
      CarrierWave.configure do |config|
        config.storage_engines.merge!({ qcloud: 'CarrierWave::Storage::Qcloud' })
      end

      CarrierWave::Uploader::Base.send(:include, CarrierWave::Qcloud::Configuration)
    end
  end
end

Carrierwave::Qcloud.register_carrierwave_storage_engine
