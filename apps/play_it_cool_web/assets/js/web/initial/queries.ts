import { User } from '../../shared/interfaces';
import { gql } from 'apollo-boost';

export interface ILoginResponse {
  user: User;
  token: string;
}

export const LOGIN = gql`
  mutation login($email: String!, $password: String!) {
    login(email: $email, password: $password) {
      user {
        id
        username
        email
      }
      token
    }
  }
`;

export const REGISTER = gql`
  mutation register($email: String!, $password: String!, $username: String!) {
    register(email: $email, password: $password, username: $username) {
      email
      username
      id
    }
  }
`;
