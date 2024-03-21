import SwiftUI
import Alamofire

struct ExchangeResponse: Codable {
    var success: Bool
    var terms: String
    var privacy: String
    var timestamp: Int
    var target: String
    var rates: Rates
}
    
struct Rates: Codable {
    var BTC: Double
    var ETH: Double
}

struct ContentView: View {
    
    @State var cryptoImage = "btc"
    @State var cryptoValue = 1.0
    @State var btcValue = 1.0
    @State var ethValue = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            Spacer()
            Image(cryptoImage)
                //.frame(width: 200, height: 200, alignment: .center)
                .resizable()
                .frame(width: 100, height:100)
            Text("$\(cryptoValue) CAD")
                .font(.system(size: 40))
                .bold()
            List {
                HStack {
                    Text("BTC")
                        .bold()
                    Text("= $\(btcValue) CAD")
                }
                .onTapGesture {
                    Task {
                        await fetchCryptoRates(currency: "btc")
                    }
                }
                HStack {
                    Text("ETH")
                        .bold()
                    Text("= $\(ethValue) CAD")
                }
                .onTapGesture {
                    Task {
                        await fetchCryptoRates(currency: "eth")
                    }
                }
            }
        }
        .task {
           await fetchCryptoRates(currency: "btc")
        }
    }
    
    func fetchCryptoRates(currency: String) async {
        let request = AF.request("http://api.coinlayer.com/live?access_key=insertkethere&target=CAD")
        request.responseDecodable(of: ExchangeResponse.self) { response in
            dump(response)
            switch response.result {
            case .success(let exchange):
                btcValue = exchange.rates.BTC
                ethValue = exchange.rates.ETH
                cryptoImage = currency
                if currency == "btc" {
                    cryptoValue = btcValue
                } else {
                    cryptoValue = ethValue
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}