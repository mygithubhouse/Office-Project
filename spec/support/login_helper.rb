module LoginHelper
  def authenticated_header(user)
    token = BuilderJsonWebToken.encode(user.id, {account_type: user.type}, 1.year.from_now)
  end
end
