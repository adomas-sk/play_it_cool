export type Player = {
  id: number;
  confirmed?: boolean;
  score: number;
  ready: boolean;
  name: string;
};

export type Question = {
  id: number;
  question: string;
};

export type Vote = {
  playerId: number;
  votedForWord: string;
  votedWhoPlayedCool: string;
};

export type Score = {
  playerId: number;
  score: number;
};
