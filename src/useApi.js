import React from 'react'
import axios from 'axios'

axios.interceptors.request.use( x => {
  x.meta = x.meta || {}
  x.meta.requestStartedAt = new Date().getTime()

  return x
})

axios.interceptors.response.use( x => {
      x.responseTime = new Date().getTime() - x.config.meta.requestStartedAt
      return x
  },
  // Handle 4xx & 5xx responses
  x => {
      x.responseTime = new Date().getTime() - x.config.meta.requestStartedAt
      throw x
  }
)

export const apiStates = {
  LOADING: 'LOADING',
  SUCCESS: 'SUCCESS',
  ERROR: 'ERROR',
}

export const useApi = url => {
  const [data, setData] = React.useState({
    state: apiStates.LOADING,
    error: '',
    responseTime: '',
    data: [],
  })

  const setPartData = (partialData) => setData({ ...data, ...partialData })

  React.useEffect(() => {
    setPartData({
      state: apiStates.LOADING,
    })
     axios.get(url)
      .then((response) => response)
      .then((data) => {
        setPartData({
          state: apiStates.SUCCESS,
          data: data.data,
          responseTime: data.responseTime
        })
      })
      .catch(() => {
       setPartData({
          state: apiStates.ERROR,
          error: 'Fetch failed'
        })
      })
  }, [])

  return data
}