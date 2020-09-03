# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  # GET /resource/password/new
  def new
    form_class
    super
  end

  # POST /resource/password
  def create
    form_class
    super
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    form_class
    super
  end

  # PUT /resource/password
  def update
    form_class
    super
  end

  # protected

  def after_resetting_password_path_for(resource)
    form_class
    super(resource)
  end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    form_class
    root_path
    # super(resource_name)
  end
end
