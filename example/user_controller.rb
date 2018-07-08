# frozen_string_literal: true

require_relative "service"

class UserController
  def create(user_info)
    Service.create_user(user_info) do |on|
      on.success { puts "Success Handled" }
      on.lied_about_age { |age| puts "The user lied about their age, no way they're #{age}" }
      on.validation_error { |validation_errors| puts "Validation errors: #{validation_errors} " }
      on.catastrophic_failure { puts "Oh Sh!t" }
    end
  end
end

UserController.new.create(name: "Bob", age: -1)
UserController.new.create(name: "George", age: 30)
UserController.new.create(name: "Rupert", age: 180)
