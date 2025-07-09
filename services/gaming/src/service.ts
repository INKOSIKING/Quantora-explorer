let games: any[] = [];
let gameId = 1;

export async function createGame(creator: string, game: any) {
  const id = gameId++;
  games.push({ id, creator, ...game, players: [creator] });
  return { id, status: "created" };
}

export async function joinGame(user: string, gameId: number) {
  const game = games.find(g => g.id === gameId);
  if (!game) return { error: "game not found" };
  game.players.push(user);
  return { gameId, user, status: "joined" };
}

export async function getGames() {
  return games;
}