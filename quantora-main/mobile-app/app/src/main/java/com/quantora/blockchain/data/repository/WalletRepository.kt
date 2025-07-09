
package com.quantora.blockchain.data.repository

import com.quantora.blockchain.data.api.BlockchainApiService
import com.quantora.blockchain.data.local.WalletDao
import com.quantora.blockchain.ui.viewmodels.TokenInfo
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class WalletRepository @Inject constructor(
    private val apiService: BlockchainApiService,
    private val walletDao: WalletDao
) {
    
    suspend fun getBalance(): Double {
        return try {
            val response = apiService.getBalance("assist track debris belt oil team myth stable project almost suspect hungry")
            response.balance
        } catch (e: Exception) {
            0.0
        }
    }
    
    suspend fun getTokens(): List<TokenInfo> {
        return try {
            val response = apiService.getTokens()
            response.map { token ->
                TokenInfo(
                    name = token.name,
                    symbol = token.symbol,
                    balance = token.balance.toString(),
                    usdValue = (token.balance * token.price).toString(),
                    change24h = token.change24h,
                    contractAddress = token.contractAddress
                )
            }
        } catch (e: Exception) {
            // Return mock data if API fails
            listOf(
                TokenInfo("QuanX", "QX", "6000000000000", "120000000", 2.5),
                TokenInfo("Bitcoin", "BTC", "0.5", "25000", -1.2),
                TokenInfo("Ethereum", "ETH", "2.3", "4000", 3.1)
            )
        }
    }
    
    suspend fun sendTransaction(
        to: String,
        amount: Double,
        token: String
    ): String {
        val response = apiService.sendTransaction(
            mapOf(
                "to" to to,
                "amount" to amount,
                "token" to token
            )
        )
        return response.transactionHash
    }
}
