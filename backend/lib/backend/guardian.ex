defmodule Backend.Guardian do
  use Guardian, otp_app: :backend

  alias Backend.User

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.id)}
  end

  # def resource_from_claims(claims) do
  #   case User.find(claims["sub"]) do
  #     nil -> {:error, :resource_not_found}
  #     user -> {:ok, user}
  #   end
  # end

  def resource_from_claims(claims) do
    {:ok, User.find(claims["sub"])}
  end
end
