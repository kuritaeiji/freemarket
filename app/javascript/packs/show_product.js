import Vue from 'vue';
import axios from './wrapper_axios'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      image: document.querySelector('#product-image').dataset.image
    },
    methods: {
      onClick: function(event) {
        const index = event.target.dataset.index;
        const product_id = location.pathname.match(/\d+/);
        axios.get(`/api/products/${product_id}/image`, { params: { index: index } })
        .then((response) => {
          this.image = response.data.image;
        })
        .catch((error) => {
          console.error(error.message);
        })
      },
      requestUserPath: function(event) {
        const id = event.target.dataset.userId;
        window.location = `/users/${id}`;
      }
    }
  }).$mount('#show-product')
});