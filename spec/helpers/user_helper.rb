module UserHelper
  def load_user
    user = User.create(name: "Peter")
    allow_any_instance_of(Api::ApiController)
      .to receive(:current_user)
      .and_return(user)
  end

  def json
    JSON.parse(response.body)
  end
end
