let proposals: any[] = [];
let proposalId = 1;

export async function createProposal(proposer: string, details: string) {
  const id = proposalId++;
  proposals.push({ id, proposer, details, votes: {} });
  return { id, status: "created" };
}

export async function voteProposal(voter: string, proposalId: number, vote: string) {
  const proposal = proposals.find(p => p.id === proposalId);
  if (!proposal) return { error: "proposal not found" };
  proposal.votes[voter] = vote;
  return { proposalId, voter, vote, status: "voted" };
}

export async function getProposals() {
  return proposals;
}