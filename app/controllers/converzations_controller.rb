class ConverzationsController < ApplicationController
	before_filter :authenticate_user!
 
  #layout false
 
  def create
    if Converzation.between(params[:sender_id],params[:recipient_id]).present?
      @converzation = Converzation.between(params[:sender_id],params[:recipient_id]).first
    else
      @converzation = Converzation.create!(converzation_params)
    end
 
    render json: { converzation_id: @converzation.id }
  end
 
  def show
    @converzation = Converzation.find(params[:id])
    @reciever = interlocutor(@converzation)
    @massages = @converzation.massages
    @massage = Massage.new
  end
 
  private
  def converzation_params
    params.permit(:sender_id, :recipient_id)
  end
 
  def interlocutor(converzation)
    current_user == converzation.recipient ? converzation.sender : converzation.recipient
  end
end
