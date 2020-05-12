import { gql } from 'apollo-boost';

export type Topic = {
  id: number;
  label: string;
};

export const FETCH_TOPICS = gql`
  {
    subjects {
      id
      label
    }
  }
`;
