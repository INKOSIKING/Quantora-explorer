openapi: 3.0.0
info:
  title: Quantora API
  version: 1.0.0
servers:
  - url: http://localhost:8080
paths:
  /api/creator/token:
    post:
      summary: Create Token
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateTokenRequest'
      responses:
        '200':
          description: Token Created
        '400':
          description: Error
  /api/creator/nft:
    post:
      summary: Create NFT
      # ... (similar to above)
  /api/creator/dao:
    post:
      summary: Create DAO
      # ... (similar to above)
  /api/wallet/send:
    post:
      summary: Send tokens
      # ...
  /api/stake:
    post:
      summary: Stake tokens
      # ...
  /api/unstake:
    post:
      summary: Unstake tokens
      # ...
  /api/governance/proposal:
    post:
      summary: Submit proposal
      # ...
  /api/governance/vote:
    post:
      summary: Vote on proposal
      # ...
  /api/validators/update:
    post:
      summary: Update validator set
      # ...
  /api/validators/slash:
    post:
      summary: Slash validator
      # ...
  /api/crypto/suite:
    post:
      summary: Set crypto suite
      # ...
components:
  schemas:
    CreateTokenRequest:
      type: object
      properties:
        user:
          type: string
        name:
          type: string
        symbol:
          type: string
        decimals:
          type: integer
        initial_supply:
          type: string
        owner:
          type: string
        mintable:
          type: boolean
        burnable:
          type: boolean
        pausable:
          type: boolean
        access_control:
          type: boolean