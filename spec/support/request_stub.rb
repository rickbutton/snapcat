module RequestStub
  extend WebMock::API
  extend self

  BASE_URI = Snapcat::Client.base_uri
  NOW = 1384635477196
  REQUEST_TOKEN = '9309075617c17ae86eefa3e6fca2e344f7e04d8419456a8299b4f814d7c5126b'

  def stub_user
    stub_basics
    block
    clear_feed
    fetch_updates
    logout
    register
    registeru
    send_snap_to_multiple
    send_snap_to_single
    unblock
    update_email
    update_privacy
    upload
  end

  def stub_snap
    stub_basics
    media
  end

  def stub_friend
    stub_basics
    delete
    set_display_name
  end

  def upload
    Snapcat::Client.any_instance.stubs(:generate_media_id).
      returns(UserExperience::MEDIA_ID)

    request_body = requestify(
      {
        data: DataHelper.data_for(:decrypted)
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/upload").with(
      body: request_body
    ).to_return(
      status: 200,
      body: '',
      headers: json_headers
    )
  end

  def send_snap_to_multiple
    request_body = requestify(
      {
        media_id: UserExperience::MEDIA_ID,
        recipient: UserExperience::RECIPIENTS.join(','),
        time: UserExperience::VIEW_DURATION
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/send").with(
      body: request_body
    ).to_return(
      status: 200,
      body: '',
      headers: json_headers
    )
  end

  def send_snap_to_single
    request_body = requestify(
      {
        media_id: UserExperience::MEDIA_ID,
        recipient: UserExperience::RECIPIENT,
        time: UserExperience::VIEW_DURATION
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/send").with(
      body: request_body
    ).to_return(
      status: 200,
      body: '',
      headers: json_headers
    )
  end

  def media
    request_body = requestify({ id: UserExperience::SNAP_ID }, username: true)
    stub_request(:post, "#{BASE_URI}/blob").with(
      body: request_body
    ).to_return(
      status: 200,
      body: DataHelper.data_for(:encrypted),
      headers: { 'Content-Type' => 'application/octet-stream' }
    )
  end

  def block
    request_body = requestify(
      {
        action: 'block',
        friend: UserExperience::FRIEND_USERNAME
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/friend").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:block),
      headers: json_headers
    )
  end

  def clear_feed
    request_body = requestify({}, username: true)
    stub_request(:post, "#{BASE_URI}/clear").with(
      body: request_body
    ).to_return(
      status: 200,
      body: '', #ResponseHelper.json_for(:clear_feed),
      headers: json_headers
    )
  end

  def login
    request_body = requestify(
      { password: UserExperience::PASSWORD },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/login").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:login),
      headers: json_headers
    )
  end

  def logout
    request_body = requestify({}, username: true)
    stub_request(:post, "#{BASE_URI}/logout").with(
      body: request_body
    ).to_return(
      status: 200,
      body: '',
      headers: json_headers
    )
  end

  def delete
    request_body = requestify(
      {
        action: 'delete',
        friend: UserExperience::FRIEND_USERNAME
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/friend").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:delete),
      headers: json_headers
    )
  end

  def set_display_name
    request_body = requestify(
      {
        action: 'display',
        display: UserExperience::FRIEND_DISPLAY_NAME,
        friend: UserExperience::FRIEND_USERNAME
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/friend").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:set_display_name),
      headers: json_headers
    )
  end

  def register
    request_body = requestify(
      {
        birthday: UserExperience::BIRTHDAY,
        email: UserExperience::EMAIL,
        password: UserExperience::PASSWORD
      }
    )
    stub_request(:post, "#{BASE_URI}/register").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:register),
      headers: json_headers
    )
  end

  def registeru
    request_body = requestify(
      {
        email: UserExperience::EMAIL
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/registeru").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:registeru),
      headers: json_headers
    )
  end

  def fetch_updates
    request_body = requestify(
      {
        update_timestamp: 0
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/updates").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:updates),
      headers: json_headers
    )
  end

  def update_email
    request_body = requestify(
      {
        action: 'updateEmail',
        email: UserExperience::EMAIL
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/settings").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:update_email),
      headers: json_headers
    )
  end

  def unblock
    request_body = requestify(
      {
        action: 'unblock',
        friend: UserExperience::FRIEND_USERNAME
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/friend").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:unblock),
      headers: json_headers
    )
  end

  def update_privacy
    request_body = requestify(
      {
        action: 'updatePrivacy',
        privacySetting: Snapcat::User::Privacy::EVERYONE
      },
      username: true
    )
    stub_request(:post, "#{BASE_URI}/settings").with(
      body: request_body
    ).to_return(
      status: 200,
      body: ResponseHelper.json_for(:update_privacy),
      headers: json_headers
    )
  end

  private

  def default_request_hash
    {
      req_token: REQUEST_TOKEN,
      timestamp: NOW,
      version: Snapcat::Client::APP_VERSION
    }
  end

  def json_headers
    { 'Content-Type' => 'application/json' }
  end

  def requestify(data, options = {})
    if options[:username]
      data.merge!({ username: UserExperience::USERNAME })
    end

    data.merge!(default_request_hash)

    data = data.map do |key, value|
      escaped_value = URI::encode(value.to_s).gsub(/@/, '%40').gsub(/,/, '%2C')
      [key, escaped_value].join('=')
    end

    data.join('&')
  end

  def stub_auth
    Snapcat::Response.any_instance.stubs(:auth_token).returns(
      Snapcat::Client::STATIC_TOKEN
    )
    Snapcat::Timestamp.stubs(:micro).returns(NOW)
  end

  def stub_basics
    stub_auth
    login
  end
end
