class CallbackController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    if params['callback']
      event_type = params['eventType']
      recording_id = params['callback']['recordingId']

      @screen_share = ScreenShare.find_by(recording_id: recording_id.to_s)
      if event_type == 'PRESENTER_CONNECT' &&  @screen_share == nil
        @screen_share = ScreenShare.create(recording_id: recording_id.to_s)
      end

      @screen_share_event = ScreenShareEvent.create(
        event_type: event_type, screen_share: @screen_share
      )

      if event_type == 'RECORDING_COMPLETE'
        @screen_share_file = ScreenShareFile.create(url: params['callback']['recordingVideoUrl'], screen_share_event: @screen_share_event)
      end
    end

    render json: { success: true  }
  end
end

# When it starts recording:
#
# {
#     "screenShareCode"=>"969419935",
#     "isSecure"=>false,
#     "isSubscription"=>false,
#     "startTime"=>1432375827236,
#     "durationInMinutes"=>0,
#     "recordingId"=>6619,
#     "eventType"=>"PRESENTER_CONNECT",
#     "callback"=>{
#         "screenShareCode"=>"969419935",
#         "isSecure"=>false,
#         "isSubscription"=>false,
#         "startTime"=>1432375827236,
#         "durationInMinutes"=>0,
#         "recordingId"=>6619,
#         "eventType"=>"PRESENTER_CONNECT"
#     }
# }
#
# When it ends recording
#
# {
#     "screenShareCode"=>"969419935",
#     "isSecure"=>false,
#     "isSubscription"=>false,
#     "startTime"=>1432375827236,
#     "endTime"=>1432375946925,
#     "totalViewers"=>0,
#     "durationInMinutes"=>2,
#     "recordingId"=>6619,
#     "eventType"=>"SHARE_END",
#     "controller"=>"callback",
#     "action"=>"index",
#     "callback"=>{
#         "screenShareCode"=>"969419935",
#         "isSecure"=>false,
#         "isSubscription"=>false,
#         "startTime"=>1432375827236,
#         "endTime"=>1432375946925,
#         "totalViewers"=>0,
#         "durationInMinutes"=>2,
#         "recordingId"=>6619,
#         "eventType"=>"SHARE_END"
#     }
# }
#
# {
#     "screenShareCode"=>"969419935",
#     "recordingId"=>6619,
#     "recordingStartTime"=>1432375827950,
#     "recordingEndTime"=>1432375944502,
#     "recordingDurationInMinutes"=>1,
#     "recordingVideoUrl"=>"https://s3.amazonaws.com/assets.screenleap.com/mp4/6619?Expires=1434006000&AWSAccessKeyId=AKIAJXDP3JP7PKZRI42Q&Signature=fzIa2YUBUM%2B0FN7Evi0EXhomjn8%3D",
#     "eventType"=>"RECORDING_COMPLETE",
#     "controller"=>"callback",
#     "action"=>"index",
#     "callback"=>{
#         "screenShareCode"=>"969419935",
#         "recordingId"=>6619,
#         "recordingStartTime"=>1432375827950,
#         "recordingEndTime"=>1432375944502,
#         "recordingDurationInMinutes"=>1,
#         "recordingVideoUrl"=>"https://s3.amazonaws.com/assets.screenleap.com/mp4/6619?Expires=1434006000&AWSAccessKeyId=AKIAJXDP3JP7PKZRI42Q&Signature=fzIa2YUBUM%2B0FN7Evi0EXhomjn8%3D",
#         "eventType"=>"RECORDING_COMPLETE"
#     }
# }
