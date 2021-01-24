import Vue from 'vue'

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#header',
    data: {
      product: {
        category_id: '',
        status_ids: [],
        shipping_day_ids: [],
      },
      order_option: '',
      show_detail_form: false
    },
    methods: {
      onCategoryChange: function(event) {
        // const categoryId = document.querySelector('#category_id').value;
        Vue.set(this.product, 'category_id', event.target.value);
      },
      onStatusChange: function(event) {
        if (event.target.checked) {
          this.product.status_ids.push(event.target.value);
        } else {
          const index = this.product.status_ids.indexOf(event.target.value);
          if (index >= 0) { this.product.status_ids.splice(index, 1); }
        }
      },
      onShippingDayChange: function(event) {
        if (event.target.checked) {
          this.product.shipping_day_ids.push(event.target.value);
        } else {
          const index = this.product.shipping_day_ids.indexOf(event.target.value);
          if (index >= 0) { this.product.shipping_day_ids.splice(index, 1); }
        }
      },
      onOrderChange: function(event) {
        this.order_option = event.target.value;
      },
      onClick: function() {
        this.show_detail_form = !this.show_detail_form;
      }
    }
  });
});