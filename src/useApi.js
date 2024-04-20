import { useState, useEffect } from 'react'
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
  const [data, setData] = useState({
    state: apiStates.LOADING,
    error: '',
    responseTime: '',
    data: [],
  })

  useEffect(() => {
    let didCancel = false;

    const fetchData = async () => {
      setData(prevData => ({ ...prevData, state: apiStates.LOADING }))
      
      try {
        const response = await axios.get(url)
        if (!didCancel) {
          setData({
            state: apiStates.SUCCESS,
            data: response.data.data,
            responseTime: response.responseTime,
            error: ''
          });
        }
      } catch (error) {
        if (!didCancel) {
          setData(prevData => ({
            ...prevData,
            state: apiStates.ERROR,
            error: 'Fetch failed',
            data: [],
          }));
        }
      }
    };

    fetchData();

    return () => {
      didCancel = true
    };
  }, [url])

  return data
}