import subprocess

class UpgradeOrchestrator:
    def __init__(self, nodes):
        self.nodes = nodes

    def upgrade_all(self, new_version):
        results = {}
        for node in self.nodes:
            # Simulate SSH and upgrade
            cmd = f"ssh {node} 'docker pull quantora/node:{new_version} && docker restart quantora-node'"
            try:
                output = subprocess.check_output(cmd, shell=True, timeout=60)
                results[node] = output.decode()
            except Exception as e:
                results[node] = f"Error: {e}"
        return results