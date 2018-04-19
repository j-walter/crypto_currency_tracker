defmodule CryptoCurrencyTracker.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  @primary_key {:id, :string, autogenerate: false}

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :follow_btc, :boolean
    field :follow_ltc, :boolean
    field :follow_eth, :boolean
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :follow_btc, :follow_ltc, :follow_eth])
    |> validate_required([:email])
    |> unique_constraint(:users_id_email_index_unique, name: :users_id_email_index)
  end

  def register_ueberauth_user(auth) do
    case Repo.insert(
      %User{id: auth.extra.raw_info.user["sub"],
        email: auth.extra.raw_info.user["email"],
        first_name: auth.extra.raw_info.user["given_name"],
        last_name: auth.extra.raw_info.user["family_name"]},
      on_conflict: [set: [email: auth.extra.raw_info.user["email"],
                          first_name: auth.extra.raw_info.user["given_name"],
                          last_name: auth.extra.raw_info.user["family_name"]]],
      conflict_target: :id) do
      {:ok, user} ->
        user
      _ ->
        %{}
    end
  end

  def client_view(user) do
    if !!user do
      %{first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        follow_btc: user.follow_btc || false,
        follow_ltc: user.follow_ltc || false,
        follow_eth: user.follow_eth || false}
    else
      nil
    end
  end


end
