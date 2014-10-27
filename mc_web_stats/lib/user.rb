require 'dm-core'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/db/mc_log.db")

class User
  include DataMapper::Resource
  property :user_id, Serial
  property :username, String
  property :playtime, Integer
  property :missing_message, String
end

DataMapper.finalize
