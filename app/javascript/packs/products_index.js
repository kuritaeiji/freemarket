import Vue from 'vue';
import axios from './wrapper_axios';

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    data: {
      selected_index: [true, false, false],
      products: []
    },
    methods: {
      onClick: async function(index) {
        if (this.selected_index[index] === true) { return; }
        this.selected_index.fill(false);
        this.selected_index.splice(index, 1, true);
        let response = null;
        try {
          if (index === 0) { response = await this.getUntradedProducts(); }
          else if (index === 1) { response = await this.getTradedProducts(); }
          else { response = await this.getSoldedProducts(); }
          this.products = response.data;
        } catch (error) {
          console.error(error.message);
        }
      },
      getUntradedProducts: function() {
        return axios.get('api/products')
      },
      getTradedProducts: function() {
        return axios.get('api/products/traded_index')
      },
      getSoldedProducts: function() {
      }
    },
    mounted: function() {
      axios.get('api/products')
      .then((response) => {
        console.log(response.data)
        this.products = response.data;
      })
      .catch((error) => {
        console.error(error.message);
      })
    }
  }).$mount('#products-index');
});