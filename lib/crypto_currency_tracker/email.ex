defmodule CryptoCurrencyTracker.Email do
  import Bamboo.Email
  alias Phoenix.HTML.Format
  alias Phoenix.HTML

  def passed_digital_currency_threshold(currency_id, recipient_emails, threshold, old_price, new_price) do
    body = "Currency: " <> currency_id <> "\n" <>
            "Old price: " <> Float.to_string(old_price) <> "\n" <>
            "New price: " <> Float.to_string(new_price) <> "\n" <>
            "Threshold: " <> Float.to_string(threshold)
    new_email(
      from: "cointrack@loopback.onl",
      bcc: recipient_emails,
      subject: "Your " <> currency_id <> " threshold limit was triggered",
      text_body: body,
      html_body: Format.text_to_html(body) |> HTML.safe_to_string
    )
  end

end
