# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    form_class
    super
  end

  # POST /resource/confirmation
  def create
    form_class
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    form_class
    super
  end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    form_class
    root_path
    # super(resource_name)
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    form_class
    super(resource_name, resource)
  end
end
