import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import List from '../../../components/List';
import { vote } from '../actions';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';

const useStyle = makeStyles((theme: ITheme) => ({
  title: {
    '@media screen and (max-width: 800px)': {
      fontSize: '1rem',
    },
  },
}));

interface IVotingProps {
  nextStage: () => void;
}

const Voting: React.FC<IVotingProps> = ({ nextStage }) => {
  const word = useSelector((store: IRootStore) => store.game.word);
  const words = useSelector((store: IRootStore) => store.game.words);
  const players = useSelector((store: IRootStore) => store.game.players);
  const dispatch = useDispatch();
  const classes = useStyle();

  if (word === 'NONE' && words) {
    return (
      <>
        <div className={classes.title}>
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

  const otherPlayers = players?.filter((p) => p.name !== localStorage.getItem('currentUsername'));

  return (
    <>
      <div className={classes.title}>
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
