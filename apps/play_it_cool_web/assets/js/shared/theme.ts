type Color = string;

export interface ITheme {
  palette: {
    primary: Color;
    primaryLight: Color;
    secondary: Color;
    green: Color;
    red: Color;
    black: Color;
    white: Color;
  };
}

const theme: ITheme = {
  palette: {
    primary: '#FFF643',
    primaryLight: '#FFF864',
    secondary: '#662E9B',
    green: '#71e284',
    red: '#e03c5a',
    black: '#030303',
    white: '#FEFEFF',
  },
};

export default theme;
