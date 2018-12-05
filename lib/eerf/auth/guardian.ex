# https://medium.com/@tylerpachal/session-authentication-example-for-phoenix-1-3-using-guardian-1-0-beta-a228c78478e6

defmodule Eerf.Auth.Guardian do
  use Guardian, otp_app: :eerf
  alias Eerf.Auth

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    user = claims["sub"]
    |> Auth.get_user!

    {:ok, user}
    # If something goes wrong here return {:error, reason}
  end
end
