class CertsController < ApplicationController
  def index
    @certs = $aws_iot_client.list_certificates.certificates
  end

  def destroy
    # @cert = Cert.find params[:id]
    redirect_to things_path if @cert.destroy
  end
end
