defmodule CryptoCurrencyTracker.Alert do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias CryptoCurrencyTracker.Repo
  alias CryptoCurrencyTracker.ApiAgent
  alias CryptoCurrencyTracker.Alert

  schema "alerts" do
    field :threshold1, :float
    field :threshold2, :float
    field :digital_currency, :string
    belongs_to :user, CryptoCurrencyTracker.User, foreign_key: :user_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:threshold1, :threshold2, :digital_currency])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:threshold1, :digital_currency])
    |> validate_inclusion(:digital_currency, ApiAgent.digital_currencies())
  end
end
