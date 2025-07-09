const profiles: Record<string, { displayName: string; following: Set<string> }> = {};

export async function createProfile(address: string, displayName: string) {
  profiles[address] = { displayName, following: new Set() };
  return { address, displayName };
}

export async function follow(follower: string, followee: string) {
  if (!profiles[follower]) profiles[follower] = { displayName: "", following: new Set() };
  profiles[follower].following.add(followee);
}

export async function unfollow(follower: string, followee: string) {
  if (!profiles[follower]) return;
  profiles[follower].following.delete(followee);
}