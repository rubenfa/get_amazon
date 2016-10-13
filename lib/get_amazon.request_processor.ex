defmodule GetAmazon.RequestProcessor do

  import SweetXml

  def get_items(xml) do

    xml
    |> xpath(~x"//Items",
    MoreResultsURL: ~x"./MoreSearchResultsUrl/text()"s,
    Items: [
        ~x"./Item"l,
        ASIN: ~x"./ASIN/text()"s,
        Title: ~x"./ItemAttributes/Title/text()"s,
        Brand: ~x"./ItemAttributes/Brand/text()"s,
        Color: ~x"./ItemAttributes/Color/text()"s,
        Features: ~x"./ItemAttributes/Feature/text()"sl,
        TextPrice: ~x"./ItemAttributes/ListPrice/FormattedPrice/text()"s,
        Price: ~x"./ItemAttributes/ListPrice/Amount/text()"s  |> transform_by(&transform_price/1),
        DetailURL: ~x"./DetailPageURL/text()"s,
        SmallImage: ~x"./SmallImage/URL/text()"s,
        MediumImage: ~x"./MediumImage/URL/text()"s,
        LargeImage: ~x"./LargeImage/URL/text()"s,
        ReviewIFrameURL: ~x"./CustomerReviews/IFrameURL/text()"s,
        Prime: ~x"./Offers/Offer/OfferListing/IsEligibleForPrime/text()"o |> transform_by(&transform_bool/1)
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
