defmodule CryptoCurrencyTracker.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.User
  @primary_key {:id, :string, autogenerate: false}

  schema "users" do
    field :email, :string
    has_many :sessions, CryptoCurrencyTracker.Session, on_delete: :delete_all
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
    Repo.insert(
      %User{id: auth.extra.raw_info.user["sub"],
        email: auth.extra.raw_info.user["email"]},
      on_conflict: [set: [email: auth.extra.raw_info.user["email"]]],
      conflict_target: :id)
  end


end