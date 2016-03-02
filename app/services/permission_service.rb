class PermissionService
  def initialize(user)
    @user = user
  end

  def allow?(controller, action)
    return true if @user
    return true if controller == "sessions" && action == "new"
    return true if controller == "sessions" && action == "create"
  end
end
