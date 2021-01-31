import axios from 'axios';
import process from 'process';

if (document.querySelector('meta[name="csrf-token"]')) {
  const csrf_token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
  axios.defaults.headers.common = {
    "X-Requested-With": "XMLHttpRequest",
    "X-CSRF-Token": csrf_token
  }
}

export default axios.create({
  withCredentials: true,
  baseURL: process.env.BASE_URL
});
