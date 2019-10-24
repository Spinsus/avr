# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email, null: false

      # Password uses default encryption via bcrypt
      t.string :encrypted_password, null: false

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :encrypted_current_sign_in_ip
      t.string   :encrypted_current_sign_in_ip_iv
      t.string   :encrypted_last_sign_in_ip
      t.string   :encrypted_last_sign_in_ip_iv

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.datetime :locked_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true

    # All initialization vectors must be unique per attr_encrypted Gem
    add_index :users, :encrypted_current_sign_in_ip_iv, unique: true
    add_index :users, :encrypted_last_sign_in_ip_iv, unique: true
  end
end
