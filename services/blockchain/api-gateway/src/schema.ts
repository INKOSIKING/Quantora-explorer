import { gql } from "apollo-server-express";

export const typeDefs = gql`
  type Query {
    chainStatus: ChainStatus
    dexMarkets: [Market!]
    explorerBlock(number: Int!): Block
  }

  type ChainStatus {
    height: Int
    hash: String
    peers: Int
  }

  type Market {
    symbol: String!
    price: Float!
    volume24h: Float
  }

  type Block {
    number: Int!
    hash: String!
    timestamp: String!
    txCount: Int!
  }
`;