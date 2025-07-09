
package com.quantora.blockchain.data.api

import retrofit2.http.*

interface BlockchainApiService {
    
    @GET("wallet/{seedPhrase}")
    suspend fun getBalance(@Path("seedPhrase") seedPhrase: String): BalanceResponse
    
    @GET("tokens")
    suspend fun getTokens(): List<TokenResponse>
    
    @POST("transaction/send")
    suspend fun sendTransaction(@Body request: Map<String, Any>): TransactionResponse
    
    @POST("swap/calculate")
    suspend fun calculateSwap(@Body request: SwapRequest): SwapResponse
    
    @POST("swap/execute")
    suspend fun executeSwap(@Body request: SwapRequest): TransactionResponse
    
    @GET("nft/{address}")
    suspend fun getNFTs(@Path("address") address: String): List<NFTResponse>
    
    @POST("token/create")
    suspend fun createToken(@Body request: CreateTokenRequest): TransactionResponse
    
    @POST("nft/create")
    suspend fun createNFT(@Body request: CreateNFTRequest): TransactionResponse
}

data class BalanceResponse(
    val balance: Double,
    val address: String
)

data class TokenResponse(
    val name: String,
    val symbol: String,
    val balance: Double,
    val price: Double,
    val change24h: Double,
    val contractAddress: String?
)

data class TransactionResponse(
    val transactionHash: String,
    val status: String
)

data class SwapRequest(
    val fromToken: String,
    val toToken: String,
    val amount: Double
)

data class SwapResponse(
    val toAmount: Double,
    val exchangeRate: Double,
    val minimumReceived: Double,
    val networkFee: Double
)

data class NFTResponse(
    val tokenId: String,
    val name: String,
    val description: String,
    val imageUrl: String,
    val contractAddress: String
)

data class CreateTokenRequest(
    val name: String,
    val symbol: String,
    val totalSupply: Long,
    val decimals: Int
)

data class CreateNFTRequest(
    val name: String,
    val description: String,
    val imageUrl: String,
    val attributes: Map<String, String>
)
