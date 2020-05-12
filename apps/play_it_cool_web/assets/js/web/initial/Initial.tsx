import React from 'react';
import Layout from '../../components/Layout';
import { Link } from 'react-router-dom';

const Initial = () => {
  return (
    <Layout>
      <div>
        THIS IS THE FIRST PAGE <br /> GO TO <Link to="/lobby">LOBBY</Link>
      </div>
    </Layout>
  );
};

export default Initial;
