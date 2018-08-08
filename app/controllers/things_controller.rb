class ThingsController < ApplicationController
  before_action :set_thing, only: [:destroy]

  def index
    @things = $aws_iot_client.list_things().things
  end

  def destroy
    redirect_to things_path if @thing.destroy
  end

  private

  def set_thing
    # @thing = Post.find params[:id]
  end
end
