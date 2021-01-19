import Vue from 'vue';
import axios from 'axios';

document.addEventListener('DOMContentLoaded', () => {
  const postalCodeForm = document.querySelector('#user_postal_code');
  const addressForm = document.querySelector('#user_address')

  new Vue({
    el: '#app',
    data: {
      user: {
        postalCode: postalCodeForm.value,
        address: addressForm.value
      }
    },
    methods: {
      onClick: function() {
        Vue.set(this.user, 'postalCode', this.user.postalCode.replace('-', ''));
        const url = 'https://api.anko.education/zipcode';

        axios.get(url, { params: { zipcode: parseInt(this.user.postalCode) } })
        .then((response) => {
          const prefCode = response.data.prefcode;
          const city = response.data.city;
          const area = response.data.area;
          Vue.set(this.user, 'address', city + area);
          document.querySelector('select').value = prefCode;
        })
        .catch((error) => {
          console.error(error);
        })
      }
    }
  });
});