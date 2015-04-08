
Dir[".*/model/*.rb"].each {|file| require(file)}

DataMapper::Model.raise_on_save_failure = true

DataMapper::setup(:default, DATA_SOURCE)

DataMapper.finalize.auto_upgrade!

