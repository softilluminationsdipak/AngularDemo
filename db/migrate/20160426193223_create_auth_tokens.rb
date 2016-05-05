class CreateAuthTokens < ActiveRecord::Migration
  def change
    create_table :auth_tokens do |t|
      t.integer :user_id
      t.string :authentication_token
      t.timestamps null: false
    end
    add_index :auth_tokens, :authentication_token, :unique => true
    add_index :auth_tokens, :user_id
  end
end
