# Carrierwave::Qcloud

This gem adds storage support for [Qcloud COS](https://www.qcloud.com/doc/product/227/%E4%BA%A7%E5%93%81%E4%BB%8B%E7%BB%8D) to [CarrierWave](https://github.com/carrierwaveuploader/carrierwave)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'carrierwave-qcloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-qcloud

## Usage

You'll need to configure the to use this in config/initializes/carrierwave.rb

```ruby
CarrierWave.configure do |config|
  #config.storage           = :qcloud # set default storage
  config.qcloud_app_id     = 'xxxxxx'
  config.qcloud_secret_id  = 'xxxxxx'
  config.qcloud_secret_key = 'xxxxxx'
  config.qcloud_bucket     = "bucketname"
end
```

If dont want to use `qcloud` as default storage, just set the storage to `:qcloud` in the specified uploader:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :qcloud
end
```

You can override configuration item in individual uploader like this:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :qcloud

  self.qcloud_bucket = "avatars"
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rainchen/carrierwave-qcloud.

