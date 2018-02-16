defmodule GetAmazon.RequestProcessor do
  @moduledoc """
  Used to take a XML result from Amazon and extract all needed attributes in a map
  """

  import SweetXml

  def get_items(xml) do
    xml
    |> xpath(
      ~x"//Items",
      TotalResults: ~x"//Items/TotalResults/text()"s |> transform_by(&transform_to_integer/1),
      TotalPages: ~x"//Items/TotalPages/text()"s |> transform_by(&transform_to_integer/1),
      Items: [
        ~x"./Item"l,
        asin: ~x"./ASIN/text()"s,
        title: ~x"./ItemAttributes/Title/text()"s,
        brand: ~x"./ItemAttributes/Brand/text()"s,
        color: ~x"./ItemAttributes/Color/text()"s,
        features: ~x"./ItemAttributes/Feature/text()"sl,
        text_price: ~x"./ItemAttributes/ListPrice/FormattedPrice/text()"s,
        price: ~x"./ItemAttributes/ListPrice/Amount/text()"s |> transform_by(&transform_price/1),
        detail_url: ~x"./DetailPageURL/text()"s,
        image_small: ~x"./SmallImage/URL/text()"s,
        image_medium: ~x"./MediumImage/URL/text()"s,
        image_large: ~x"./LargeImage/URL/text()"s,
        review_iframe_url: ~x"./CustomerReviews/IFrameURL/text()"s,
        is_prime:
          ~x"./Offers/Offer/OfferListing/IsEligibleForPrime/text()"o
          |> transform_by(&transform_bool/1),
        offers: [
          ~x"./Offers/Offer"l,
          merchant: ~x"./Merchant/Name/text()"s,
          condition: ~x"./OfferAttributes/Condition/text()"s,
          price: ~x"./OfferListing/Price/Amount/text()"s |> transform_by(&transform_price/1),
          text_price: ~x"./OfferListing/Price/FormattedPrice/text()"s,
          availability: ~x"./OfferListing/AvailabilityAttributes/AvailabilityType/text()"s
        ]
      ]
    )
  end

  def get(xml, query) do
    xml |> xmap(query)
  end

  defp transform_price(price) do
    price
    |> String.codepoints()
    |> decimal_separation
  end

  defp decimal_separation(num_list) do
    {amount, decimals} = num_list |> Enum.split(-2)

    "#{amount}.#{decimals}"
  end

  defp transform_to_integer(number_string) do
    String.to_integer(number_string)
  end

  defp transform_bool(num_val) do
    cond do
      num_val == "1" -> true
      num_val == "0" -> false
      true -> false
    end
  end
end
