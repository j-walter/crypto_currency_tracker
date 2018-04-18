defmodule CryptoCurrencyTracker.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  @primary_key {:id, :string, autogenerate: false}

  schema "users" do
    field :email, :string
    field :follow_btc, :boolean
    field :follow_ltc, :boolean
    field :follow_eth, :boolean
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end

  def register_ueberauth_user(auth) do
    case Repo.insert(
      %User{id: auth.extra.raw_info.user["sub"],
        email: auth.extra.raw_info.user["email"]},
      on_conflict: [set: [email: auth.extra.raw_info.user["email"]]],
      conflict_target: :id) do
      {:ok, user} ->
        user
      _ ->
        %{}
    end
  end


end
