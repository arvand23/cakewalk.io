class Admin::EventsController < ApplicationController
  def index
    @tests = current_user.tests
                 .order(created_at: :desc)
                 .paginate(:page => params[:page], :per_page => 30)
  end

  def screen_shares
    if params[:id]
      @screen_shares = ScreenShare.where(test_id: params[:id])
                         .order(created_at: :desc)
                         .paginate(:page => params[:page], :per_page => 30)
    else
      @screen_shares = ScreenShare.order(created_at: :desc)
                           .paginate(:page => params[:page], :per_page => 30)
    end
  end

  def screen_share_events
    if params[:id]
      @screen_share_events = ScreenShareEvent.where(screen_share_id: params[:id])
                                 .order(:created_at => :desc)
                                 .paginate(:page => params[:page], :per_page => 30)
    else
      @screen_share_events = ScreenShareEvent.order(:created_at => :desc)
                                 .paginate(:page => params[:page], :per_page => 30)
    end
  end
end
