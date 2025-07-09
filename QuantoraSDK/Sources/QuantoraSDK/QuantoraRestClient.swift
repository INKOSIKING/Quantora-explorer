import Foundation

public class QuantoraRestClient {
    let baseUrl: URL
    let session = URLSession.shared

    public init(baseUrl: String) {
        self.baseUrl = URL(string: baseUrl)!
    }

    public func getAssets(completion: @escaping ([String]?, Error?) -> Void) {
        let req = URLRequest(url: baseUrl.appendingPathComponent("assets"))
        let task = session.dataTask(with: req) { data, _, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                let assets = json?["assets"] as? [String]
                completion(assets, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    // ...etc.
}