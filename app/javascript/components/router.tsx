import React from 'react';
import { 
  Routes,
  Route
 } from 'react-router-dom'
import Home from './home'
import Aboutus from './about';
import ContactUs from './contact';
import Profile from '../components/profile';

import Layout from './Layout/layout';

function Xrouters() {
    return (
      <Layout>
       <Routes>
          <Route  path='/' element={<Home />} />  
          <Route path='/about' element={<Aboutus />} />
          <Route path='/contact' element={<ContactUs />} />
          <Route path='/profile' element={<Profile />} />
      </Routes>
      </Layout>      
    );
}
export default Xrouters;