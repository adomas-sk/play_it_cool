import { gql } from 'apollo-boost';

export type LobbyData = {
  id: string;
  lobbyAuthToken: string;
  lobbyToken: number;
};

export interface ICreateLobbyResult {
  createLobby: LobbyData;
}

export const CREATE_LOBBY = gql`
  mutation createLobby($id: String!, $username: String!) {
    createLobby(id: $id, username: $username) {
      id
      lobbyAuthToken
      lobbyToken
    }
  }
`;

export interface IJoinLobbyResult {
  joinLobby: LobbyData;
}

export const JOIN_LOBBY = gql`
  mutation joinLobby($lobbyToken: Int!, $playerName: String!) {
    joinLobby(lobbyToken: $lobbyToken, playerName: $playerName) {
      id
      lobbyAuthToken
      lobbyToken
    }
  }
`;
