//
//  MarketData.swift
//  CryptoX
//
//  Created by Alpay Calalli on 11.09.23.
//

import Foundation

// JSON data
/*
 
 url: https://api.coingecko.com/api/v3/global

 
 {
   "data": {
     "active_cryptocurrencies": 9980,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 853,
     "total_market_cap": {
       "btc": 41667268.31332935,
       "eth": 670142332.3956581,
       "ltc": 17617253464.081123,
       "bch": 5696208924.651714,
       "bnb": 5078638430.365656,
       "eos": 1942770879479.1516,
       "xrp": 2217702966879.0273,
       "xlm": 8298698580236.536,
       "link": 178779509819.80768,
       "dot": 261570335395.7386,
       "yfi": 205757942.55694136,
       "usd": 1042913502394.3573,
       "aed": 3830699512807.145,
       "ars": 365005542214391.6,
       "aud": 1621243455617.6025,
       "bdt": 114548061416941.6,
       "bhd": 393141888430.08813,
       "bmd": 1042913502394.3573,
       "brl": 5148863961320.924,
       "cad": 1417800232878.5347,
       "chf": 929475800738.9202,
       "clp": 926712079957574.4,
       "cny": 7603778054606.997,
       "czk": 23792557246721.727,
       "dkk": 7238236872017.779,
       "eur": 970354881292.2736,
       "gbp": 832575578490.9565,
       "hkd": 8169151893390,
       "huf": 372720526135759,
       "idr": 16003246965865766,
       "ils": 3971675345493.3027,
       "inr": 86466965629861.53,
       "jpy": 152797604870154.9,
       "krw": 1384385619037053,
       "kwd": 321793046990.783,
       "lkr": 337126782075911.5,
       "mmk": 2191784072487161,
       "mxn": 18204746635945.562,
       "myr": 4875099166942.431,
       "ngn": 783332331648401.4,
       "nok": 11111895034902.07,
       "nzd": 1762169228455.6467,
       "php": 59103470465114.9,
       "pkr": 310551766020946.94,
       "pln": 4508090605055.309,
       "rub": 99493932484718.89,
       "sar": 3911835054552.9194,
       "sek": 11549443137350.586,
       "sgd": 1418822288110.8794,
       "thb": 37056914158821.01,
       "try": 28035913645415.766,
       "twd": 33346950656359.023,
       "uah": 38539041296527.21,
       "vef": 104426928994.74667,
       "vnd": 25088129967367900,
       "zar": 19686608873622.168,
       "xdr": 790714073418.3488,
       "xag": 45311556800.74276,
       "xau": 542356737.7851601,
       "bits": 41667268313329.34,
       "sats": 4166726831332934.5
     },
     "total_volume": {
       "btc": 1627920.0214919883,
       "eth": 26182136.826263707,
       "ltc": 688297572.6225419,
       "bch": 222548127.83288348,
       "bnb": 198419947.2962831,
       "eos": 75903118680.42404,
       "xrp": 86644582369.93753,
       "xlm": 324226140036.4581,
       "link": 6984828985.659356,
       "dot": 10219426500.845966,
       "yfi": 8038863.305139936,
       "usd": 40746126155.07092,
       "aed": 149663577327.0368,
       "ars": 14260590006959.082,
       "aud": 63341197730.22068,
       "bdt": 4475337360766.696,
       "bhd": 15359863446.046284,
       "bmd": 40746126155.07092,
       "brl": 201163624827.58447,
       "cad": 55392769408.89885,
       "chf": 36314170013.18375,
       "clp": 36206192778872.78,
       "cny": 297075931184.00574,
       "czk": 929563704852.7638,
       "dkk": 282794413966.65356,
       "eur": 37911295920.08414,
       "gbp": 32528325193.737774,
       "hkd": 319164813633.93115,
       "huf": 14562010697575.006,
       "idr": 625239119318022.8,
       "ils": 155171434930.04852,
       "inr": 3378222529204.8174,
       "jpy": 5969728524885.667,
       "krw": 54087276606396.84,
       "kwd": 12572298717.399418,
       "lkr": 13171380331332.562,
       "mmk": 85631943701182.81,
       "mxn": 711250646718.4027,
       "myr": 190467766711.87936,
       "ngn": 30604415355073.758,
       "nok": 434136364976.14465,
       "nzd": 68847099519.17702,
       "php": 2309144006904.853,
       "pkr": 12133107306520.223,
       "pln": 176128919695.02557,
       "rub": 3887179824001.864,
       "sar": 152833503703.52286,
       "sek": 451231157727.7468,
       "sgd": 55432700612.53075,
       "thb": 1447795714377.4768,
       "try": 1095349587138.4606,
       "twd": 1302849234583.159,
       "uah": 1505701704847.6199,
       "vef": 4079909611.907239,
       "vnd": 980181104471544.5,
       "zar": 769146287672.5027,
       "xdr": 30892816435.999355,
       "xag": 1770300610.2107167,
       "xau": 21189615.445683025,
       "bits": 1627920021491.9883,
       "sats": 162792002149198.84
     },
     "market_cap_percentage": {
       "btc": 46.75715924906835,
       "eth": 17.918240346114573,
       "usdt": 7.93302744624607,
       "bnb": 3.0262269119048693,
       "usdc": 2.4915464765860533,
       "xrp": 2.3904854261038917,
       "steth": 1.286662255595719,
       "ada": 0.812888597802364,
       "doge": 0.8094598341163695,
       "sol": 0.6922265299184147
     },
     "market_cap_change_percentage_24h_usd": -2.9870003496728104,
     "updated_at": 1694445674
   }
 }
 */

struct GlobalData: Codable {
    let data: MarketData
}

// MARK: - DataClass  
struct MarketData: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String {
        guard let result = totalMarketCap.first(where: { $0.key == "usd"} ) else { return "" }
        
        return "$" + result.value.formattedWithAbbreviations()
    }
    
    var volume: String {
        guard let result = totalVolume.first(where: { $0.key == "usd"} ) else { return "" }
        
        return "$" + result.value.formattedWithAbbreviations()
    }
    
    var btcDominance: String {
        guard let result = marketCapPercentage.first(where: { $0.key == "btc"} ) else { return "" }
        
        return result.value.asPercentString()
    }
}
