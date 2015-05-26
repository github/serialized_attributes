require 'rubygems'

if ENV['VERSION']
  gem 'activerecord', ENV['VERSION']
end

require 'test/unit'
require 'active_record'
require 'active_support/test_case'

require File.dirname(__FILE__) + '/../init'

begin
  require 'ruby-debug'
  Debugger.start
rescue LoadError
end

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:",
)

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE serialized_records (id INTEGER PRIMARY KEY, raw_data BLOB)
SQL

ActiveRecord::Base.connection.execute(<<-SQL)
  CREATE TABLE serialized_record_with_defaults (id INT NOT NULL PRIMARY KEY, raw_data BLOB)
SQL

class SerializedRecord < ActiveRecord::Base
  serialize_attributes :data do
    string  :title, :body
    integer :age
    float   :average
    time    :birthday
    boolean :active
    boolean :default_in_my_favor, :default => true
    array   :names
    array   :lottery_picks, :type => :integer
    hash    :extras, :types => {
        :num        => :integer,
        :started_at => :time
      }
  end
end

class SerializedRecordWithDefaults < ActiveRecord::Base
  serialize_attributes :data do
    string  :title, :body, :default => 'blank'
    integer :age,          :default => 18
    float   :average,      :default => 5.2
    time    :birthday,     :default => Time.utc(2009, 1, 1)
    boolean :active,       :default => true
    array   :names,        :default => %w(a b c)
    hash    :extras,       :default => {:a => 1}
    boolean :clearance,    :default => nil
    string  :symbol,       :default => :foo
  end
end
