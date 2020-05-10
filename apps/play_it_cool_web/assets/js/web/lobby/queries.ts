import { gql } from 'apollo-boost';

export interface ILobbyData {
  id: string;
  state: string;
  lobbyToken: number;
}

export interface ICreateLobbyResult {
  createLobby: ILobbyData
}

export const CREATE_LOBBY = gql`
  mutation createLobby($id: String!, $username: String!) {
    createLobby(id: $id, username: $username) {
      id
      state
      lobbyToken
    }
  }
`;

export interface IJoinLobbyResult {
  joinLobby: ILobbyData
}

export const JOIN_LOBBY = gql`
  mutation joinLobby($lobbyToken: Integer!, $username: String!) {
    joinLobby(lobbyToken: $lobbyToken, playerName: $username) {
      id
      state
      lobbyToken
    }
  }
`;
