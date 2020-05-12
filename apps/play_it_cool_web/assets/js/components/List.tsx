import React from 'react';
import { makeStyles } from '@material-ui/styles';
import { ITheme } from '../shared/theme';
import Button from './Button';

const useStyle = makeStyles((theme: ITheme) => ({
  listContainer: {
    height: 'calc(100% - 180px)',
    width: '100%',
    maxWidth: 600,
    display: 'flex',
    flexDirection: 'column',
  },
  listItem: {
    padding: 8,
    borderRadius: 4,
    width: '100%',
    background: theme.palette.secondaryTint,
    marginBottom: 8,

    '&:hover': {
      color: theme.palette.primary,
    },
  },
}));

type Item = {
  label: string;
  key: string | number;
  onClick?: () => void;
};

interface IListProps {
  itemList?: Item[];
  loading: boolean;
  buttons?: boolean;
}

const List: React.FC<IListProps> = ({ itemList = [], loading, buttons }) => {
  const classes = useStyle();
  if (loading) {
    return (
      <div className={classes.listContainer}>
        <div className={classes.listItem}>Loading...</div>
      </div>
    );
  }
  if (buttons) {
    return (
      <div className={classes.listContainer}>
        {itemList.map((item) => (
          <Button
            label={item.label}
            fullWidth
            onClick={
              item.onClick ||
              (() => console.error('No onClick passed to List', { itemList }))
            }
            key={item.key}
          />
        ))}
      </div>
    );
  }
  return (
    <div className={classes.listContainer}>
      {itemList.map((item) => (
        <div className={classes.listItem} key={item.key}>
          {item.label}
        </div>
      ))}
    </div>
  );
};

export default List;
