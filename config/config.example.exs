use Mix.Config

config :amazon_security,
AWSAccessKeyId: "ACCESKEYID",
AWSAccessKey: "ACCESSKEY",
AssociateTag: "ASSOCIATETAG"

config :amazon_url,
APIProtocol: "http",
APIMethod: "GET",
APIBaseURL: "webservices.amazon.com",
APIBasePath: "/onca/xml"

config  :amazon_parameters,
APIService: "AWSECommerceService",
APIVersion: "2016-01-01"
