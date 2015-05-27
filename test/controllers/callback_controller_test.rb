require 'test_helper'

class CallbackControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  PRESENTER_CONNECT_COLLECTION = {"screenShareCode"=>"969419935", "isSecure"=>false, "isSubscription"=>false, "startTime"=>1432375827236, "durationInMinutes"=>0, "recordingId"=>6619, "eventType"=>"PRESENTER_CONNECT", "callback"=>{"screenShareCode"=>"969419935", "isSecure"=>false, "isSubscription"=>false, "startTime"=>1432375827236, "durationInMinutes"=>0, "recordingId"=>6619, "eventType"=>"PRESENTER_CONNECT"}}
  SHARE_END_COLLECTION = {"screenShareCode"=>"969419935", "isSecure"=>false, "isSubscription"=>false, "startTime"=>1432375827236, "endTime"=>1432375946925, "totalViewers"=>0, "durationInMinutes"=>2, "recordingId"=>6619, "eventType"=>"SHARE_END", "controller"=>"callback", "action"=>"index", "callback"=>{"screenShareCode"=>"969419935", "isSecure"=>false, "isSubscription"=>false, "startTime"=>1432375827236, "endTime"=>1432375946925, "totalViewers"=>0, "durationInMinutes"=>2, "recordingId"=>6619, "eventType"=>"SHARE_END"}}
  RECORDING_COMPLETE_COLLECTION = {"screenShareCode"=>"969419935", "recordingId"=>6619, "recordingStartTime"=>1432375827950, "recordingEndTime"=>1432375944502, "recordingDurationInMinutes"=>1, "recordingVideoUrl"=>"https://s3.amazonaws.com/assets.screenleap.com/mp4/6619?Expires=1434006000&AWSAccessKeyId=AKIAJXDP3JP7PKZRI42Q&Signature=fzIa2YUBUM%2B0FN7Evi0EXhomjn8%3D", "eventType"=>"RECORDING_COMPLETE", "callback"=>{"screenShareCode"=>"969419935", "recordingId"=>6619, "recordingStartTime"=>1432375827950, "recordingEndTime"=>1432375944502, "recordingDurationInMinutes"=>1, "recordingVideoUrl"=>"https://s3.amazonaws.com/assets.screenleap.com/mp4/6619?Expires=1434006000&AWSAccessKeyId=AKIAJXDP3JP7PKZRI42Q&Signature=fzIa2YUBUM%2B0FN7Evi0EXhomjn8%3D", "eventType"=>"RECORDING_COMPLETE"}}

  test "log all callbacks" do

    # PRESENTER_CONNECT

    sign_in users(:pama)

    assert_difference('ScreenShareEvent.count', 1) do
      assert_difference('ScreenShareFile.count', 0) do
        get :index, PRESENTER_CONNECT_COLLECTION
      end
    end

    assert_equal('PRESENTER_CONNECT', assigns('screen_share_event').event_type)
    assert_response :success

    # SHARE_END

    assert_difference('ScreenShareEvent.count', 1) do
      assert_difference('ScreenShareFile.count', 0) do
        get :index, SHARE_END_COLLECTION
      end
    end

    assert_equal('SHARE_END', assigns('screen_share_event').event_type)
    assert_response :success

    # RECORDING_COMPLETE

    assert_difference('ScreenShareEvent.count', 1) do
      assert_difference('ScreenShareFile.count', 1) do
        get :index, RECORDING_COMPLETE_COLLECTION
      end
    end

    assert_equal('RECORDING_COMPLETE', assigns('screen_share_event').event_type)
    url = "https://s3.amazonaws.com/assets.screenleap.com/mp4/6619?Expires=1434006000&AWSAccessKeyId=AKIAJXDP3JP7PKZRI42Q&Signature=fzIa2YUBUM%2B0FN7Evi0EXhomjn8%3D"
    assert_equal(url, assigns('screen_share_file').url)
    assert_response :success

  end

end
