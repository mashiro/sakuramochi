require 'active_record'

ActiveRecord::Base.configurations = {'test' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('test')

class User < ActiveRecord::Base
  has_many :statuses
end

class Status < ActiveRecord::Base
  belongs_to :user
end

class CreateTestTables < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.integer :age
    end

    create_table :statuses do |t|
      t.references :user
      t.string :text
    end
  end
end
