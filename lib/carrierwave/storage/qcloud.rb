require 'carrierwave'
require 'qcloud_cos' # use qcloud cos SDK

module CarrierWave
  module Storage
    ##
    #  qcloud storage engine
    #
    #  CarrierWave.configure do |config|
    #    config.storage           = :qcloud
    #    config.qcloud_app_id     = 'xxxxxx'
    #    config.qcloud_secret_id  = 'xxxxxx'
    #    config.qcloud_secret_key = 'xxxxxx'
    #    config.qcloud_bucket     = "bucketname"
    #  end
    #
    # wiki: https://github.com/richardkmichael/carrierwave-activerecord/wiki/Howto:-Adding-a-new-storage-engine
    # rdoc: http://www.rubydoc.info/gems/carrierwave/CarrierWave/Storage/Abstract
    class Qcloud < Abstract
      # config qcloud sdk by getting configuration from uplander
      def self.configure_qcloud_sdk(uploader)
        QcloudCos.configure do |config|
          config.app_id     = uploader.qcloud_app_id
          config.secret_id  = uploader.qcloud_secret_id
          config.secret_key = uploader.qcloud_secret_key
          config.bucket     = uploader.qcloud_bucket
          config.endpoint   = "http://web.file.myqcloud.com/files/v1/"
        end
      end

      # hook: store the file on qcloud
      def store!(file)
        self.class.configure_qcloud_sdk(uploader)

        qcloud_file = File.new(file)
        qcloud_file.path = uploader.store_path(identifier)
        qcloud_file.store
        qcloud_file
      end

      # hook: retrieve the file on qcloud
      def retrieve!(identifier)
        self.class.configure_qcloud_sdk(uploader)

        if uploader.file # file is present after store!
          uploader.file
        else
          file_path = uploader.store_path(identifier)
          File.new(nil).tap do |file|
            file.path = file_path
            file.stat
          end
        end
      end

      # store and retrieve file using qcloud-cos-sdk
      # sdk ref: https://github.com/zlx/qcloud-cos-sdk/blob/master/wiki/get_started.md#api%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E
      class File < CarrierWave::SanitizedFile
        attr_accessor :qcloud_info
        attr_accessor :path

        # store/upload file to qcloud
        def store
          result = QcloudCos.upload(path, file.to_file)
          # e.g.: {"code"=>0, "message"=>"SUCCESS", "data"=>{"access_url"=>"http://#{bucket}-#{app_id}.file.myqcloud.com/uploads/user/avatar/5/81b97fdf4f5b4353916c0f40878258bc.jpg", "resource_path"=>"/uploads/user/avatar/5/81b97fdf4f5b4353916c0f40878258bc.jpg", "source_url"=>"http://#{bucket}-#{app_id}.cos.myqcloud.com/uploads/user/avatar/5/81b97fdf4f5b4353916c0f40878258bc.jpg", "url"=>"http://web.file.myqcloud.com/files/v1/uploads/user/avatar/5/81b97fdf4f5b4353916c0f40878258bc.jpg"}}

          if result['message'] == 'SUCCESS'
            self.qcloud_info = result['data']
          end
        end

        # file access url on qcloud
        def url
          qcloud_info['access_url']
        end

        # get file stat on qcloud
        def stat
          result = QcloudCos.stat(path)
          if result['message'] == 'SUCCESS'
            self.qcloud_info = result['data']
          end
        end

        # delete file on qcloud
        def delete
          result = QcloudCos.delete(path)
          result['message'] == 'SUCCESS'
          # TODO: delete parent dir if it's empty
          # ref: https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Make-a-fast-lookup-able-storage-directory-structure
        end

        # TODO: retrieve/download file from qcloud
        def retrieve
          # TODO
        end
      end

    end
  end
end
