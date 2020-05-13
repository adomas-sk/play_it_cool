import React from 'react';
import Button from '../../../components/Button';
import { useSelector, useDispatch } from 'react-redux';
import { IRootStore } from '../../../shared/store';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../../../shared/theme';
import { END_GAME } from '../actionTypes';

const useStyle = makeStyles((theme: ITheme) => ({
  header: {
    display: 'flex',
    justifyContent: 'space-between',
    width: '100%',
    padding: 12,
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
  },
}));

interface IResultsProps {
  nextStage: () => void;
}

const Results: React.FC<IResultsProps> = ({ nextStage }) => {
  const players = useSelector((store: IRootStore) => store.game.players);
  const scores = useSelector((store: IRootStore) => store.game.scores);
  const votes = useSelector((store: IRootStore) => store.game.votes);
  const classes = useStyle();
  const dispatch = useDispatch();

  if (!scores || !players || !votes) {
    return (
      <div>
        Waiting for results...
        <Button label="Don't wait" onClick={nextStage} />
      </div>
    );
  }

  const combinedScoresWithPlayers = scores.map((score, index) => {
    const player = players.find((p) => p.id === score.playerId);
    if (!player) {
      return {
        playerId: index,
        score: '-',
        playerName: '-',
      };
    }
    return {
      playerId: player?.id,
      score: score.score,
      playerName: player.name,
    };
  });
  return (
    <div className={classes.container}>
      <div className={classes.header}>
        <div>Name</div>
        <div>Score</div>
      </div>
      {combinedScoresWithPlayers.map((combination) => (
        <div key={combination.playerId} className={classes.row}>
          <div>{combination.playerName}</div>
          <div>{combination.score}</div>
        </div>
      ))}
      <Button
        label="Continue"
        onClick={() => {
          nextStage();
          dispatch({ type: END_GAME });
        }}
      />
    </div>
  );
};

export default Results;
