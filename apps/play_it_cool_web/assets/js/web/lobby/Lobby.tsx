import React, { useEffect } from 'react';
import { makeStyles } from '@material-ui/styles';
import { useDispatch } from 'react-redux';
import { useMutation } from '@apollo/react-hooks';
import { ITheme } from '../../shared/theme';
import Button from '../../components/Button';
import Layout from '../../components/Layout';
import { CREATE_LOBBY } from './queries';
import { startSocket } from './actions';

const useStyle = makeStyles((theme: ITheme) => ({
  lobbyContainer: {
    height: '100%',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center'
  }
}));

const Lobby: React.FC = () => {
  const classes = useStyle();
  const [addTodo, { data }] = useMutation(CREATE_LOBBY);
  const dispatch = useDispatch();

  useEffect(() => {
    if (data) {
      console.log(data);
      dispatch(startSocket(data))
    }
  }, [data]);

  return (
    <Layout>
      <div className={classes.lobbyContainer}>
        <Button label="Create a Lobby" onClick={() => addTodo({variables: {id: "1", username: "ponasAdomas"}})} />
      </div>
    </Layout>
  );
};

export default Lobby;
