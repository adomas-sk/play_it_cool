defmodule PlayItCoolWeb.Resolvers.User do
  def register(_parent, new_user, _resolution) do
    PlayItCool.Auth.Registration.register(new_user)
  end

  def login(_parent, login_data, _resolution) do
    PlayItCool.Auth.Login.login(login_data)
  end
end
