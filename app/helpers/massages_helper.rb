module MassagesHelper
	  def self_or_other(massage)
    massage.user == current_user ? "self" : "other"
  end
 
  def massage_interlocutor(massage)
    massage.user == massage.converzation.sender ? massage.converzation.sender : massage.converzation.recipient
  end
end
