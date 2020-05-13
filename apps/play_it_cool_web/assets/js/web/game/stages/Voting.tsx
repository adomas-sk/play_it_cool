import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import List from '../../../components/List';
import { vote } from '../actions';

interface IVotingProps {
  nextStage: () => void;
}

const Voting: React.FC<IVotingProps> = ({ nextStage }) => {
  const word = useSelector((store: IRootStore) => store.game.word);
  const words = useSelector((store: IRootStore) => store.game.words);
  const players = useSelector((store: IRootStore) => store.game.players);
  const dispatch = useDispatch();

  if (word === 'NONE' && words) {
    return (
      <>
        <div>
          Guess what the <strong>word</strong> was:
        </div>
        <List
          loading={!words.length}
          itemList={words.map((w) => ({
            key: w,
            label: w,
            onClick: () => {
              dispatch(vote(w));
              nextStage();
            },
          }))}
          buttons
        />
      </>
    );
  }

  const otherPlayers = players?.filter(
    (p) => p.name !== localStorage.getItem('currentUsername')
  );

  return (
    <>
      <div>
        Guess who <strong>didn't know the word</strong>:{' '}
      </div>
      <List
        loading={false}
        itemList={otherPlayers?.map((p) => ({
          key: p.id,
          label: p.name,
          onClick: () => {
            dispatch(vote(p.name));
            nextStage();
          },
        }))}
        buttons
      />
    </>
  );
};

export default Voting;
