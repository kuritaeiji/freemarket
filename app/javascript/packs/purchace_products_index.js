import Vue from 'vue';
import axios from './wrapper_axios';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      selected_index: [true, false],
      products: []
    },
    methods: {
      onClick: async function(index) {
        if (this.selected_index[index] === true) { return; }
        this.selected_index.fill(false);
        this.selected_index.splice(index, 1, true);
        let response = null;
        if (index == 0) { response = await this.getTradingProducts(); }
        else { response = await this.getReceivedProducts(); }
        this.products = response.data;
      },
      getTradingProducts: function() {
        return axios.get('/api/purchace_products');
      },
      getReceivedProducts: function() {
        return axios.get('/api/purchace_products/received_index');
      }
    },
    mounted: async function() {
      try {
        const response = await this.getTradingProducts();
        this.products = response.data;
      } catch(error) {
        console.error(error.message);
      }
    }
  }).$mount('#purchace-products-index');
});