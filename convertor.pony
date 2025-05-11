use "collections"
use "net/http"
use "json"

actor Main
  new create(env: Env) =>
    let api_key = "YOUR_API_KEY"
    let url = "https://v6.exchangerate-api.com/v6/" + api_key + "/latest/USD"
    HTTPClient(env.root as AmbientAuth).get(url, ExchangeHandler)

class ExchangeHandler is HTTPHandler
  fun ref apply(response: HTTPResponse ref) =>
    try
      let json = JsonDoc.parse(String.from_array(response.body))?.data as JsonObject
      let rates = json.data("conversion_rates") as JsonObject
      let uzs = rates.data("UZS") as JsonNumber
      @printf[I32]("1 USD = %.2f UZS\n".cstring(), uzs.f64())
    else
      @printf[I32]("Xatolik\n".cstring())
    end
