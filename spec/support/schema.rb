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

  def self.seed
    @aira = User.create! :name => 'harune aira'
    ['fresh fruit basket', 'munekyun taiken', 'heartful splash',
     'lovely rainbow', 'hirahira hiraku koi no hana', 'crystal splash'
    ].each do |jump|
      Status.create! :text => jump, :user => @aira
    end

    @rizumu = User.create! :name => 'amamiya rizumu'
    ['heartful splash', 'colorful choco parade', 'fun fun heart dive',
     'stardust shower', 'happy macaron spin', 'pop\'n candy rocket'
    ].each do |jump|
      Status.create! :text => jump, :user => @rizumu
    end
  end
end
