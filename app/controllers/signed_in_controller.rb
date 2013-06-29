class SignedInController < ApplicationController
  before_filter :signed_in

private

  def signed_in
    redirect_to root_path unless current_user
  end
end
