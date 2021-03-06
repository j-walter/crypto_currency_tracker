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
        Repo.get(User, user.id)
      _ ->
        %{}
    end
  end

  def change(user_id, change_key, value) do
    case Repo.get!(User, user_id)
    |> Ecto.Changeset.cast(%{change_key => value}, [String.to_atom(change_key)])
    |> Repo.update do
      {:ok, user} ->
        user
      _ ->
        nil
    end
  end

  def client_view(user) do
    if !!user do
      %{first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        follow_btc: user.follow_btc,
        follow_ltc: user.follow_ltc,
        follow_eth: user.follow_eth}
    else
      nil
    end
  end


end
