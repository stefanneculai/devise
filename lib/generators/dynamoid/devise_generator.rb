require 'generators/devise/orm_helpers'

module Dynamoid
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      include Devise::Generators::OrmHelpers

      def generate_model
        invoke "dynamoid:model", [name] unless model_exists? && behavior == :invoke
      end

      def inject_field_types
        inject_into_file model_path, migration_data, :after => "include Dynamoid::Document\n" if model_exists?
      end

      def inject_devise_content
        inject_into_file model_path, model_contents, :after => "include Dynamoid::Document\n" if model_exists?
      end

      def migration_data
<<RUBY
  ## Database authenticatable
  field :email,              :string, :default => ""
  field :encrypted_password, :string, :default => ""
  
  ## Recoverable
  field :reset_password_token,   :string
  field :reset_password_sent_at, :datetime

  ## Rememberable
  field :remember_created_at, :datetime

  ## Trackable
  field :sign_in_count,      :integer, :default => 0
  field :current_sign_in_at, :datetime
  field :last_sign_in_at,    :datetime
  field :current_sign_in_ip, :string
  field :last_sign_in_ip,    :string

  ## Confirmable
  # field :confirmation_token,   :string
  # field :confirmed_at,         :datetime
  # field :confirmation_sent_at, :datetime
  # field :unconfirmed_email,    :string # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :string # Only if unlock strategy is :email or :both
  # field :locked_at,       :datetime

  ## Token authenticatable
  # field :authentication_token, :string
RUBY
      end
    end
  end
end