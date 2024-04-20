import React from 'react'
import Emoji from './Emoji'
import { motion } from 'framer-motion'
import CountUp from 'react-countup'
import { apiStates, useApi } from './useApi.js'
import './App.css'

const App = () => {
  const { state, error, data, responseTime } = useApi(import.meta.env.VITE_REACT_APP_API_URL)

  const container = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        delayChildren: 0.5
      }
    }
  }

  const item = {
    hidden: { opacity: 0 },
    show: { opacity: 1 }
  }

  switch (state) {
    case apiStates.ERROR:
      return (
        <div className="container">
          <h3>Error: { error || 'General error' }</h3>
        </div>
      )

    case apiStates.SUCCESS:
      return (
        <React.Fragment>
          <motion.div animate={{ x: 100, scale: [4, 1], rotate: [0, 0, 0, 0, 0] }} transition={{ duration: 2 }}>
            <div className="container">
              <h2>Most popular public GitHub repositories</h2>
              <div className="grid">
              <p>Execution time for fetching data from API took</p>
              <motion.p initial={{ x: 50 }} animate={{ x: 10, rotate: [100, 100, 50, 50, 0] }} transition={{ duration: 4 }}><strong><CountUp delay={2} duration={1} end={responseTime}>{responseTime}</CountUp> ms</strong></motion.p>
                {data.map((element) => (
                  <React.Fragment key={element.name}>
                    <motion.ul variants={container} initial="hidden" animate="show" className="card">
                      <motion.li variants={item}><a href={element.html_url}>{element.full_name}</a></motion.li>
                      <motion.li variants={item}><em>{element.stargazers_count}</em> <Emoji symbol="⭐"/> </motion.li>
                    </motion.ul>
                  </React.Fragment>
                ))}
              </div>
            </div>
          </motion.div>
        </React.Fragment>
      )

    default:
      return (
        <div className="container">
          <h3>Loading..</h3>
        </div>
      )
  }
}

export default App
