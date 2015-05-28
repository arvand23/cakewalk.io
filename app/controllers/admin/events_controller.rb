class Admin::EventsController < ApplicationController
  def index
    @tests = current_user.tests
                 .order(created_at: :desc)
                 .paginate(:page => params[:page], :per_page => 30)
  end

  def screen_shares
    if params[:id]
      @screen_shares = ScreenShare.where(test_id: params[:id])
                                  .group(:recording_id)
                                  .order(created_at: :desc)
                                  .paginate(:page => params[:page], :per_page => 30)
    else
      @screen_shares = ScreenShare.group(:recording_id)
                                  .order(created_at: :desc)
                                  .paginate(:page => params[:page], :per_page => 30)
    end
  end

  def screen_share_events
    if params[:id]
      @screen_share_events = ScreenShareEvent.joins(:screen_share)
                                             .where(screen_share_id: params[:id])
                                             .group('screen_shares.recording_id')
                                             .order(:created_at => :desc)
                                             .paginate(:page => params[:page], :per_page => 30)
    else
      @screen_share_events = ScreenShareEvent.joins(:screen_share)
                                             .group('screen_shares.recording_id')
                                             .order(:created_at => :desc)
                                             .paginate(:page => params[:page], :per_page => 30)
    end
  end
end
