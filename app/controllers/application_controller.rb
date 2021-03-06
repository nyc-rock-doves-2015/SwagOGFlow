class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user

  def current_user
    User.find_by(id: session[:user_id])
  end

  def gate_keeper
    if !current_user
      flash[:notice] = "Please sign in to view that page."
      redirect_to signin_path
    end
  end

  def page_voted_from_path
    session[:return_to] = request.referrer
  end

  def sort_by_popularity(array_of_objects)
    array_of_objects.sort{|a, b| b.count_votes <=> a.count_votes}
  end

  def vote_if_havent_voted(object)
    if !object.votes.find_by(voter_id: current_user.id)
      vote = object.votes.build(vote_params)
      vote.voter_id = current_user.id
      vote.save
    end
  end
end
