class MassagesController < ApplicationController
	 before_filter :authenticate_user!
 
  def create
    @converzation = Converzation.find(params[:converzation_id])
    @massage = @converzation.massages.build(massage_params)
    @massage.user_id = current_user.id
    @massage.save!
 
    @path = converzation_path(@converzation)

    PrivatePub.publish_to("/converzations/#{@converzation}/new", "alert('#{@massage.body}');")
  end
 
  private
 
  def massage_params
    params.require(:massage).permit(:body)
  end
end
