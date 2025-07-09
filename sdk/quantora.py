# ...existing code...
    def get_portfolio(self, token):
        return requests.get(f"{self.base_url}/analytics/portfolio", headers={"Authorization": f"Bearer {token}"}).json()
    def get_watchlist(self, token):
        return requests.get(f"{self.base_url}/analytics/watchlist", headers={"Authorization": f"Bearer {token}"}).json()
    def comment(self, token, target, body):
        return requests.post(f"{self.base_url}/community/comment", headers={"Authorization": f"Bearer {token}"}, json={"target": target, "body": body}).json()
    def report_bug(self, token, detail, page):
        return requests.post(f"{self.base_url}/community/bug", headers={"Authorization": f"Bearer {token}"}, json={"detail": detail, "page": page}).json()
    def stake(self, token, amount):
        return requests.post(f"{self.base_url}/rewards/stake", headers={"Authorization": f"Bearer {token}"}, json={"amount": amount}).json()
    def get_stake_rewards(self, token):
        return requests.get(f"{self.base_url}/rewards/stake/rewards", headers={"Authorization": f"Bearer {token}"}).json()