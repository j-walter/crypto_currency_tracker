defmodule CryptoCurrencyTrackerWeb.ApiChannel do

  use CryptoCurrencyTrackerWeb, :channel
  alias CryptoCurrencyTracker.Api

  def join("api:", _payload, socket) do
    cond do
      # one sock is assigned per user
      authenticated?(socket) ->
        {:ok, %{}, socket |> assign(:name, socket.assigns[:user_details])}
      true ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  defp authenticated?(socket) do
    !!Map.get(socket.assigns, :user_details, nil)
  end

end
