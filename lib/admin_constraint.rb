class AdminConstraint
  def matches?(request)
    return false unless request.cookies['auth_token']
    user = User.find_by auth_token: request.cookies['auth_token']
    user && user.admin?
  end
end
