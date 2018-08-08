class HomeController < ApplicationController

  def index
  end

  def get_credentials
    serial = params[:serial_number]
    thing_cert = ThingCertificate.find_by(serial_number: serial)
    if thing_cert
      render json: thing_cert
    else
      # TODO: implement the aws API calls for creating a certificate
    end
  end
end
