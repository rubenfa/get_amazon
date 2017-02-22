defmodule GetAmazon.RequestProcessor do

  import SweetXml

  def get_items(xml) do

    xml
    |> xpath(~x"//Items",    
    Items: [
        ~x"./Item"l,
        asin: ~x"./ASIN/text()"s,
        title: ~x"./ItemAttributes/Title/text()"s,
        brand: ~x"./ItemAttributes/Brand/text()"s,
        color: ~x"./ItemAttributes/Color/text()"s,
        features: ~x"./ItemAttributes/Feature/text()"sl,
        text_price: ~x"./ItemAttributes/ListPrice/FormattedPrice/text()"s,
        price: ~x"./ItemAttributes/ListPrice/Amount/text()"s  |> transform_by(&transform_price/1),
        detail_url: ~x"./DetailPageURL/text()"s,
        image_small: ~x"./SmallImage/URL/text()"s,
        image_medium: ~x"./MediumImage/URL/text()"s,
        image_large: ~x"./LargeImage/URL/text()"s,
        review_iframe_url: ~x"./CustomerReviews/IFrameURL/text()"s,
        is_prime: ~x"./Offers/Offer/OfferListing/IsEligibleForPrime/text()"o |> transform_by(&transform_bool/1)
    ] )



  end

  defp transform_price(price) do
    price
    |> String.codepoints
    |> decimal_separation    
  end

  defp decimal_separation(num_list) do
    {amount, decimals} = num_list |> Enum.split(-2)

    "#{amount}.#{decimals}"
  end

  defp transform_bool(num_val) do
    cond do
      num_val == "1" -> true
      num_val == "0"-> false
      true -> false
    end
  end
end 
