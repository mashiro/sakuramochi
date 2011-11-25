# encoding: utf-8
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
    items = {
      '春音あいら' => [
        'フレッシュフルーツバスケット',
        'ハートフルスプラッシュ',
        'カラフルチョコパレード',
        '胸キュン体験',
        'スターダストシャワー',
        'ラブリーレインボー',
        'ヒラヒラヒラク恋の花',
        'ドレミファスライダー',
        'クリスタルスプラッシュ',
        'ポップンキャンディロケット',
        'チカラ合わせて！ワンダースイーツShow',
        'ココロ重ねて！ハートアーチファンタジー',
        'フライハイチアガール',
        'チアフルHip Hop Win!',
        'ドキドキハロウィンナイト',
        'ビタミンガーデンサンシャイン',
      ],
      '天宮りずむ' => [
        'ハートフルスプラッシュ',
        'カラフルチョコパレード',
        'FUNFUNハートダイブ',
        'スターダストシャワー',
        'ハッピーマカロンスピン',
        'ドレミファスライダー',
        'ポップンキャンディロケット',
        'ドルフィンビーナル',
        'チカラ合わせて！ワンダースイーツShow',
        'ココロ重ねて！ハートアーチファンタジー',
        'フライハイチアガール',
        'チアフルHip Hop Win!',
        'ドキドキハロウィンナイト',
        'ビタミンガーデンサンシャイン',
      ],
      '高峰みおん' => [
        'スターダストシャワー',
        'ヒラヒラヒラク恋の花',
        'ドレミファスライダー',
        'ゴールデンスターマジック',
        'ときめきメモリーリーフ',
        'はちみつキッス',
        'ココロ重ねて！ハートアーチファンタジー',
        'フライハイチアガール',
        'チアフルHip Hop Win!',
        'ドキドキハロウィンナイト',
        'ビタミンガーデンサンシャイン',
      ],
      '春音うる' => [],
      '春音える' => [],
    }

    items.each do |name, jumps|
      User.create! :name => name do |user|
        jumps.each do |jump|
          Status.create! :user => user, :text => jump
        end
      end
    end
  end
end
