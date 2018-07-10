# frozen_string_literal: true

require_relative "./user_controller"

UserController.new.reset_password_request(email: 'me@me.me')

# Fails due to invalid token
UserController.new.reset_password(
  password: "hunter2",
  password_confirmation: "hunter2",
  token: "invalidtoken"
)

# Fails due to invalid token
UserController.new.reset_password(
  password: "hunter2",
  password_confirmation: "hunter2",
  token: "expiredtoken"
)

# Fails due to password mismatch
UserController.new.reset_password(
  password: "hunter2",
  password_confirmation: "hunter22",
  token: "validtoken"
)

# Successful
UserController.new.reset_password(
  password: "hunter2",
  password_confirmation: "hunter2",
  token: "validtoken"
)
