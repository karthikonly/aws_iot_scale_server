class PoliciesController < ApplicationController
  def index
    @policies = $aws_iot_client.list_policies.policies
  end

  def destroy
    # @policy = Policy.find params[:id]
    redirect_to things_path if @policy.destroy
  end
end
