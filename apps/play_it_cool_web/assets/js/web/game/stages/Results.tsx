import React from 'react';
import Button from '../../../components/Button';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';
import List from '../../../components/List';
import { ready } from '../actions';

const useStyle = makeStyles((theme: ITheme) => ({
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    width: '100%',
    padding: 12,

    '@media screen and (max-width: 800px)': {
      fontSize: '1rem',
    },
  },
  row: {
    display: 'flex',
    justifyContent: 'space-between',
    width: '100%',
    padding: 12,
    backgroundColor: theme.palette.secondaryTint,
  },
  container: {
    height: '100%',
    width: '100%',
    maxWidth: 500,
    padding: 24,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
}));

interface IResultsProps {
  nextStage: () => void;
}

const Results: React.FC<IResultsProps> = ({ nextStage }) => {
  const players = useSelector((store: IRootStore) => store.game.players);
  const classes = useStyle();
  const dispatch = useDispatch();

  const loading = !players || !players?.every((p) => p.score);

  return (
    <>
      <div className={classes.container}>
        <div></div>
        <div className={classes.header}>
          <div>Name</div>
          <div>Score</div>
        </div>
        <List
          loading={loading}
          itemList={players?.map((p) => ({
            key: p.id,
            label: p.name,
            right: p.score,
          }))}
        />
      </div>
      <Button
        label={loading ? "Don't wait" : 'Continue'}
        onClick={() => {
          nextStage();
          dispatch(ready());
        }}
      />
    </>
  );
};

export default Results;
